import os
import shutil
from pathlib import Path

config_dir = os.getenv("APPDATA")

if config_dir is None:
    raise Exception("APPDATA doesn't exist")

FILE_DIR = Path(__file__).parent
CONFIG_DIR = Path(config_dir).absolute()
SOURCE_DIR = (FILE_DIR / "../../config/windows").resolve()

EXCLUDE_SOURCES = ["kanata", "wsl"]
DESTINATIONS = {"yazi": (CONFIG_DIR / "yazi" / "config")}

for source in os.listdir(SOURCE_DIR):
    if source in EXCLUDE_SOURCES:
        continue

    from_dir = (SOURCE_DIR / source).absolute()

    if source in DESTINATIONS:
        to_dir = DESTINATIONS[source]
    else:
        to_dir = (CONFIG_DIR / source).absolute()

    if to_dir.exists():
        shutil.rmtree(to_dir)

    shutil.copytree(from_dir, to_dir, dirs_exist_ok=True)

    print(f"Copied {from_dir} to {to_dir}")
