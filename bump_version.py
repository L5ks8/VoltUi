import re
import sys
import subprocess
import os
import json

ROOT = os.path.dirname(os.path.abspath(__file__))

def get_current_version():
    lib_path = os.path.join(ROOT, "Library.luau")
    with open(lib_path, "r", encoding="utf-8") as f:
        content = f.read()
    match = re.search(r'Version\s*=\s*"(\d+\.\d+\.\d+)"', content)
    if not match:
        raise ValueError("Could not find Version in Library.luau")
    return match.group(1)

def bump(current, part="patch"):
    parts = [int(x) for x in current.split(".")]
    if part == "major":
        parts[0] += 1
        parts[1] = 0
        parts[2] = 0
    elif part == "minor":
        parts[1] += 1
        parts[2] = 0
    else:
        parts[2] += 1
    return ".".join(str(x) for x in parts)

def update_files(new_ver):
    changed_files = []

    lib_path = os.path.join(ROOT, "Library.luau")
    if os.path.exists(lib_path):
        with open(lib_path, "r", encoding="utf-8") as f:
            content = f.read()
        new_content = re.sub(r'Version\s*=\s*"\d+\.\d+\.\d+"', f'Version = "{new_ver}"', content)
        if new_content != content:
            with open(lib_path, "w", encoding="utf-8", newline="\n") as f:
                f.write(new_content)
            changed_files.append("Library.luau")

    topbar_path = os.path.join(ROOT, "Core", "Topbar.luau")
    if os.path.exists(topbar_path):
        with open(topbar_path, "r", encoding="utf-8") as f:
            content = f.read()
        new_content = re.sub(r'Config\.Title\s+or\s+"Volt\s*-\s*\d+\.\d+\.\d+"', f'Config.Title or "Volt - {new_ver}"', content)
        new_content = re.sub(r'Config\.Version\s+or\s*"\d+\.\d+\.\d+"', f'Config.Version or "{new_ver}"', new_content)
        if new_content != content:
            with open(topbar_path, "w", encoding="utf-8", newline="\n") as f:
                f.write(new_content)
            changed_files.append(os.path.join("Core", "Topbar.luau"))

    pkg_path = os.path.join(ROOT, "Backend", "package.json")
    if os.path.exists(pkg_path):
        with open(pkg_path, "r", encoding="utf-8") as f:
            data = json.load(f)
        if data.get("version") != new_ver:
            data["version"] = new_ver
            with open(pkg_path, "w", encoding="utf-8", newline="\n") as f:
                json.dump(data, f, indent=2)
                f.write("\n")
            changed_files.append(os.path.join("Backend", "package.json"))

    server_path = os.path.join(ROOT, "Backend", "server.js")
    if os.path.exists(server_path):
        with open(server_path, "r", encoding="utf-8") as f:
            content = f.read()
        new_content = re.sub(r'packageVersion\s*=\s*"\d+\.\d+\.\d+"', f'packageVersion = "{new_ver}"', content)
        new_content = re.sub(r'version:\s*"\d+\.\d+\.\d+"', f'version: "{new_ver}"', new_content)
        if new_content != content:
            with open(server_path, "w", encoding="utf-8", newline="\n") as f:
                f.write(new_content)
            changed_files.append(os.path.join("Backend", "server.js"))

    return changed_files

def main():
    part = "patch"
    if len(sys.argv) > 1:
        if sys.argv[1] in ("major", "minor", "patch"):
            part = sys.argv[1]
        elif sys.argv[1] == "--help":
            print("Usage: python bump_version.py [patch|minor|major]")
            sys.exit(0)

    cur = get_current_version()
    new_ver = bump(cur, part)
    changed = update_files(new_ver)
    
    if changed:
        subprocess.run(["git", "add"] + changed, cwd=ROOT)
        print(f"[Volt UI] Bumped version: {cur} -> {new_ver} ({', '.join(changed)})")
    else:
        print(f"[Volt UI] Version already {new_ver}")

if __name__ == "__main__":
    main()
