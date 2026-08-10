#!/usr/bin/python3

# ================================================
# =                                              =
# =    ⚠️ ALERT - This .py is AI Generated ⚠️    =
# =                                              =
# ================================================

#region AI GENERATED CODE

import os
import sys
import fnmatch
from pathlib import Path
import readline
import glob

EXCLUDED_EXTENSIONS = {
    '.bin', '.exe', '.dll', '.so', '.o', '.a', '.obj', '.lib',
    '.zip', '.rar', '.7z', '.tar', '.gz', '.bz2', '.xz', '.tgz',
    '.jpg', '.jpeg', '.png', '.gif', '.bmp', '.tiff', '.webp', '.ico', '.svg',
    '.mp3', '.wav', '.flac', '.ogg',
    '.mp4', '.avi', '.mkv', '.mov',
    '.pdf',
    '.doc', '.docx', '.xls', '.xlsx', '.ppt', '.pptx',
    '.db', '.sqlite', '.sqlite3'
}

def path_completer(text, state):

    buffer = readline.get_line_buffer()
    expanded = os.path.expanduser(buffer)

    matches = glob.glob(expanded + "*")

    results = []

    for m in matches:

        if os.path.isdir(m):
            m += "/"

        if buffer.startswith("~"):
            home = os.path.expanduser("~")
            if m.startswith(home):
                m = "~" + m[len(home):]

        results.append(m)

    results.sort()

    try:
        return results[state]
    except IndexError:
        return None

def enable_path_autocomplete():

    readline.set_completer(path_completer)
    readline.parse_and_bind("tab: complete")

    # importante para paths
    readline.set_completer_delims(" \t\n;")

def ask_save_path(base_dir):

    enable_path_autocomplete()

    while True:

        try:
            user_input = input(
                "\nSave codebase.md to path (TAB for autocomplete): "
            ).strip()

        except KeyboardInterrupt:
            print("\nAborted.")
            sys.exit(1)

        if not user_input:
            print("Path cannot be empty.")
            continue

        user_input = os.path.expanduser(user_input)

        save_path = Path(user_input)

        if not save_path.is_absolute():
            save_path = base_dir / save_path

        if save_path.is_dir():
            save_path = save_path / "codebase.md"

        try:
            save_path.parent.mkdir(parents=True, exist_ok=True)
            return save_path

        except OSError as e:
            print(f"Invalid path: {e}")

def parse_gitignore_patterns(gitignore_path):
    patterns = []
    if not gitignore_path.exists():
        return patterns

    with gitignore_path.open('r', encoding='utf-8', errors='ignore') as f:
        for line in f:
            line = line.strip()
            if not line or line.startswith('#'):
                continue
            
            negated = False
            if line.startswith('!'):
                negated = True
                line = line[1:]

            is_dir_pattern = line.endswith('/')
            if is_dir_pattern:
                line = line[:-1]

            anchored = False
            if line.startswith('/'):
                anchored = True
                line = line[1:]

            patterns.append((line, negated, is_dir_pattern, anchored))
    return patterns

def is_path_ignored(path, gitignore_patterns, base_dir):
    relative_path_str = path.relative_to(base_dir).as_posix()
    match_results = []

    for pattern_raw, negated, is_dir_pattern, anchored in gitignore_patterns:
        current_match = False
        
        if anchored:
            if fnmatch.fnmatch(relative_path_str, pattern_raw) or \
               (path.is_dir() and fnmatch.fnmatch(relative_path_str + '/', pattern_raw + '/')):
                current_match = True
        else:
            if fnmatch.fnmatch(relative_path_str, pattern_raw) or \
               fnmatch.fnmatch(path.name, pattern_raw):
                current_match = True
            
            if not current_match:
                 path_components = relative_path_str.split('/')
                 for component in path_components:
                     if fnmatch.fnmatch(component, pattern_raw):
                         current_match = True
                         break
        
        if current_match:
            if is_dir_pattern and not path.is_dir():
                continue 
            match_results.append(not negated)

    if match_results:
        return match_results[-1]
    return False

def get_user_selection(items, prompt):
    print(prompt)
    for i, item in enumerate(items):
        print(f"{i + 1}. {item}")
    
    while True:
        try:
            choice = input("Enter numbers separated by commas (e.g.: 1,3) or 'all' for all: ").strip()
            if choice.lower() == 'all':
                return list(range(len(items)))
            
            selected_indices = []
            for num_str in choice.split(','):
                idx = int(num_str.strip()) - 1
                if 0 <= idx < len(items):
                    selected_indices.append(idx)
                else:
                    raise ValueError(f"Invalid number: {idx + 1}")
            return sorted(list(set(selected_indices)))
        except ValueError as e:
            print(f"Invalid input: {e}. Please try again.")

def get_directories_and_files(base_path, use_gitignore, gitignore_patterns):
    entries = []

    for item in sorted(base_path.iterdir()):
        if item.name.startswith('.'):
            continue

        if use_gitignore and is_path_ignored(item, gitignore_patterns, base_path):
            continue

        if item.is_dir():
            entries.append((item.name + "/", item))
        else:
            entries.append((item.name, item))

    if not entries:
        print("No files or directories found.")
        return []

    names = [e[0] for e in entries]

    selected_indices = get_user_selection(
        names,
        "\nSelect files or directories to include:"
    )

    selected_items = [entries[i][1] for i in selected_indices]

    all_files = []

    for item in selected_items:

        if item.is_file():

            if item.suffix.lower() not in EXCLUDED_EXTENSIONS:
                all_files.append(item)

        else:

            for root, dirs, files in os.walk(item):

                root_path = Path(root)

                dirs[:] = [
                    d for d in dirs
                    if not d.startswith('.') and
                    (not use_gitignore or not is_path_ignored(root_path / d, gitignore_patterns, base_path))
                ]

                for f in files:
                    fp = root_path / f

                    if f.startswith('.'):
                        continue

                    if fp.suffix.lower() in EXCLUDED_EXTENSIONS:
                        continue

                    if use_gitignore and is_path_ignored(fp, gitignore_patterns, base_path):
                        continue

                    all_files.append(fp)

    return sorted(set(all_files))

def collect_file_contents(file_paths, base_path):
    collected_data = []
    for file_path in file_paths:
        try:
            if file_path.suffix.lower() in EXCLUDED_EXTENSIONS:
                print(f"Warning: File '{file_path.name}' was passed for reading, but its extension is in the exclusion list. Ignoring.")
                continue

            content = file_path.read_text(encoding='utf-8', errors='ignore')
            relative_path = file_path.relative_to(base_path)
            file_extension = file_path.suffix.lstrip('.')
            if not file_extension:
                file_extension = "txt"
            collected_data.append({
                'relative_path': relative_path.as_posix(),
                'extension': file_extension,
                'content': content
            })
        except Exception as e:
            print(f"Warning: Could not read file {file_path}: {e}")
    return collected_data

def save_codebase_md(collected_data, save_path, base_path):
    dirname = base_path.name if base_path.name else "project"
    with save_path.open('w', encoding='utf-8') as f:
        f.write(f"# Codebase {dirname}\n\n")
        for i, item in enumerate(collected_data):
            if i > 0:
                f.write("---\n")
            f.write(f"./{item['relative_path']}\n")
            f.write(f"```{item['extension']}\n")
            f.write(f"{item['content']}\n")
            f.write("```\n\n")
    print(f"\nCodebase saved at: {save_path}")

def main():
    current_dir = Path.cwd()
    gitignore_path = current_dir / ".gitignore"
    use_gitignore = False
    gitignore_patterns = []

    if gitignore_path.exists():
        while True:
            response = input("A .gitignore file was found. Do you want to follow its rules? (yes/no): ").strip().lower()
            if response in ['yes', 'y']:
                use_gitignore = True
                gitignore_patterns = parse_gitignore_patterns(gitignore_path)
                print("Following .gitignore rules.")
                break
            elif response in ['no', 'n']:
                print("Not following .gitignore rules.")
                break
            else:
                print("Invalid input. Please type 'yes' or 'no'.")
    else:
        print("No .gitignore file found.")

    print("\nStarting directory scan...")
    selected_files = get_directories_and_files(current_dir, use_gitignore, gitignore_patterns)

    if not selected_files:
        print("No files selected or found to process. Exiting.")
        return

    print(f"\n{len(selected_files)} files selected for inclusion (excluding binaries/images):")
    for file_path in selected_files:
        print(f" - {file_path.relative_to(current_dir).as_posix()}")

    collected_content = collect_file_contents(selected_files, current_dir)

    while True:
        save_location_str = ask_save_path(current_dir)
        if not save_location_str:
            print("Save path cannot be empty.")
            continue
        
        save_path = Path(save_location_str)
        if not save_path.is_absolute():
            save_path = current_dir / save_path

        try:
            save_path.parent.mkdir(parents=True, exist_ok=True)
            break
        except OSError as e:
            print(f"Error creating directory for save path: {e}. Please try again.")

    save_codebase_md(collected_content, save_path, current_dir)
    print("Process completed.")

if __name__ == '__main__':
    main()
