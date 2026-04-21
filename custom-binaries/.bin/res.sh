#!/bin/bash

DIR="$HOME/.bin"
PY="$DIR/res.py"

MENU=$(printf "󰍹 Trocar resolução\n➕ Adicionar preset\n❌ Remover preset")

CHOICE=$(echo "$MENU" | wofi --dmenu --prompt "Resolution Manager")

[ -z "$CHOICE" ] && exit 0

# ------------------------
# TROCAR
# ------------------------
if [[ "$CHOICE" == "󰍹 Trocar resolução" ]]; then
  OPTIONS=$(python3 $PY list_names | sed '/^$/d')
  FORMATTED=$(echo "$OPTIONS" | sed 's/|/ | /')

  SELECTED=$(echo "$FORMATTED" | wofi --dmenu --prompt "Escolha")

  [ -z "$SELECTED" ] && exit 0

  NAME=$(echo "$SELECTED" | cut -d'(' -f1 | sed 's/[[:space:]]*$//')

  python3 "$PY" apply "$NAME"
fi

# ------------------------
# ADD
# ------------------------
if [[ "$CHOICE" == "➕ Adicionar preset" ]]; then

  NAME=$(wofi --dmenu --prompt "Nome (ex: CS2 Stretched)")
  [ -z "$NAME" ] && exit 0

  # 🔥 pega resoluções reais do monitor via python
  MODES=$(python3 "$PY" raw_modes | sed 's/@.*//')

  RES=$(echo "$MODES" | sort -u | wofi --dmenu \
    --prompt "🖥️ Escolha resolução")

  [ -z "$RES" ] && exit 0

  REFRESH=$(wofi --dmenu --prompt "⚡ Refresh Hz (ex: 60, 144)")
  [ -z "$REFRESH" ] && exit 0

  SCALE=$(wofi --dmenu --prompt "🔍 Scale (ex: 1.0)")
  [ -z "$SCALE" ] && exit 0

  # ------------------------
  # validação
  # ------------------------
  if [[ ! "$RES" =~ ^[0-9]+x[0-9]+$ ]]; then
    notify-send "Erro" "Resolução inválida"
    exit 1
  fi

  if [[ ! "$REFRESH" =~ ^[0-9]+$ ]]; then
    notify-send "Erro" "Refresh inválido"
    exit 1
  fi

  if [[ ! "$SCALE" =~ ^[0-9]*\.?[0-9]+$ ]]; then
    notify-send "Erro" "Scale inválido"
    exit 1
  fi

  W=$(echo "$RES" | cut -d'x' -f1)
  H=$(echo "$RES" | cut -d'x' -f2)

  # 🧠 calcula aspect automaticamente
  GCD=$(
    python3 - <<EOF
import math
print(math.gcd($W, $H))
EOF
  )

  ASPECT="$((W / GCD)):$((H / GCD))"

  python3 "$PY" add "$NAME" "$W" "$H" "$REFRESH" "$SCALE" "$ASPECT"

  notify-send "Sucesso" "Preset '$NAME' salvo ($RES@$REFRESH)"
fi

# ------------------------
# DELETE
# ------------------------
if [[ "$CHOICE" == "❌ Remover preset" ]]; then

  LIST=$(python3 "$PY" list_names)

  SELECTED=$(echo "$LIST" | wofi --dmenu --prompt "Remover qual?")
  [ -z "$SELECTED" ] && exit 0

  python3 "$PY" delete "$SELECTED"

  notify-send "Removido" "$SELECTED deletado"
fi
