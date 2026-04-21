#!/usr/bin/env python3
import sqlite3
import subprocess
import json
import os
import sys

CONFIG_DIR = os.path.expanduser("~/.config/resolution-manager")
DB = os.path.join(CONFIG_DIR, "resolutions.db")

# ------------------------
# INIT
# ------------------------
def ensure_db():
    os.makedirs(CONFIG_DIR, exist_ok=True)

    conn = sqlite3.connect(DB)
    cur = conn.cursor()

    cur.execute("""
    CREATE TABLE IF NOT EXISTS presets (
        name TEXT PRIMARY KEY,
        width INTEGER,
        height INTEGER,
        refresh INTEGER,
        scale REAL,
        aspect TEXT
    )
    """)

    conn.commit()
    conn.close()

# ------------------------
# HYPRLAND
# ------------------------
def get_monitor():
    data = json.loads(subprocess.check_output(["hyprctl", "monitors", "-j"]))
    return data[0]["name"], data[0]["availableModes"]

# ------------------------
# DB
# ------------------------
def get_presets():
    conn = sqlite3.connect(DB)
    cur = conn.cursor()
    cur.execute("SELECT name, width, height, refresh, scale, aspect FROM presets")
    rows = cur.fetchall()
    conn.close()
    return rows

def add_preset(name, w, h, r, scale, aspect):
    conn = sqlite3.connect(DB)
    cur = conn.cursor()

    cur.execute("""
    INSERT OR REPLACE INTO presets
    VALUES (?, ?, ?, ?, ?, ?)
    """, (name, w, h, r, scale, aspect))

    conn.commit()
    conn.close()

def delete_preset(name):
    conn = sqlite3.connect(DB)
    cur = conn.cursor()
    cur.execute("DELETE FROM presets WHERE name=?", (name,))
    conn.commit()
    conn.close()

# ------------------------
# LIST
# ------------------------
def list_modes():
    monitor, available = get_monitor()
    presets = get_presets()

    result = []

    for name, w, h, r, scale, aspect in presets:
        mode = f"{w}x{h}@{r}"
        if mode in available:
            result.append(f"{name}|{mode}")

    return result

# ------------------------
# APPLY
# ------------------------
def apply(name):
    monitor, _ = get_monitor()

    conn = sqlite3.connect(DB)
    cur = conn.cursor()

    cur.execute("""
    SELECT width, height, refresh, scale, aspect
    FROM presets WHERE name=?
    """, (name,))
    row = cur.fetchone()
    conn.close()

    if not row:
        print("Preset não encontrado")
        return

    w, h, r, scale, aspect = row

    subprocess.run([
        "hyprctl", "keyword", "monitor",
        f"{monitor},{w}x{h}@{r},auto,{scale}"
    ])

# ------------------------
# CLI
# ------------------------
if __name__ == "__main__":
    ensure_db()

    if len(sys.argv) == 1:
        print("\n".join(list_modes()))

    elif sys.argv[1] == "apply":
        apply(sys.argv[2])

    elif sys.argv[1] == "add":
        # name w h r scale aspect
        add_preset(
            sys.argv[2],
            int(sys.argv[3]),
            int(sys.argv[4]),
            int(sys.argv[5]),
            float(sys.argv[6]),
            sys.argv[7]
        )

    elif sys.argv[1] == "delete":
        delete_preset(sys.argv[2])

    elif sys.argv[1] == "raw_modes":
        _, modes = get_monitor()
        print("\n".join(modes))

    elif sys.argv[1] == "list_names":
        presets = get_presets()
        for p in presets:
            print(p[0])
