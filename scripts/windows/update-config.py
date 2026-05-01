import os
import shutil
import sys
from pathlib import Path


if os.name != "nt":
    print("Can only be ran on windows!.")
    sys.exit(1)

source_dir = Path("config/windows")
home_dir = Path(os.environ["USERPROFILE"])
config_dir = Path(os.environ["APPDATA"])
local_dir = Path(os.environ["LOCALAPPDATA"])

terminal_base = local_dir / "Packages"
try:
    terminal_path = (
        next(terminal_base.glob("Microsoft.WindowsTerminal_*")) / "LocalState"
    )
except StopIteration:
    terminal_path = None

destinations = {
    "wsl": home_dir,
    "starship": home_dir / ".config",
    "terminal": terminal_path,
    "PowerToys": local_dir / "Microsoft" / "PowerToys",
    "yazi": config_dir / "yazi" / "config",
}

exclude_sources = []

for entry in source_dir.iterdir():
    if not entry.is_dir() or str(entry) in exclude_sources:
        continue

    folder_name = entry.name

    dest = destinations.get(folder_name)
    if dest is None:
        dest = config_dir / folder_name

    if not dest.exists():
        print(f"Creating directory: {dest}")
        dest.mkdir(parents=True, exist_ok=True)

    print(f"Copying {folder_name} -> {dest}")
    for item in entry.iterdir():
        dest_item = dest / item.name
        if item.is_dir():
            shutil.copytree(item, dest_item, dirs_exist_ok=True)
        else:
            shutil.copy2(item, dest_item)
