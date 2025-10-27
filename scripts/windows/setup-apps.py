import json
import os
import re
import shutil
from http import client
from pathlib import Path
from typing import Mapping, Optional, Pattern, TypedDict
from urllib.parse import urlparse

config_dir = os.getenv("APPDATA")
if config_dir is None:
    raise Exception("APPDATA doesn't exist")

CONFIG_DIR = Path(config_dir).absolute()
BIN_DIR = Path("~/.local/bin").expanduser().resolve().absolute()
DOWNLOADS_DIR = Path("~/Downloads").expanduser().resolve().absolute()

if not BIN_DIR.exists():
    os.makedirs(BIN_DIR, exist_ok=True)


class ReleaseConfig(TypedDict):
    owner: str
    repo: str
    name: Pattern


class ReleaseAsset(TypedDict):
    name: str
    path: Path


def print_line() -> None:
    print("=" * shutil.get_terminal_size()[0])


def print_title(msg: str) -> None:
    print_line()
    print(msg)
    print_line()


class GitHub:
    def __init__(self) -> None:
        self.api = client.HTTPSConnection("api.github.com")

        self.headers: Mapping[str, client._HeaderValue] = {"User-Agent": "Setup Apps"}

    def __del__(self) -> None:
        self.api.close()

    def download_release(self, config: ReleaseConfig) -> Optional[ReleaseAsset]:
        self.api.request(
            "GET",
            f"/repos/{config['owner']}/{config['repo']}/releases/latest",
            headers=self.headers,
        )
        res = self.api.getresponse()
        data = res.read()
        data = data.decode("utf-8")
        data = json.loads(data)

        for asset in data["assets"]:
            name: str = asset["name"]

            if config["name"].match(name):
                print(f"Downloading: {name}")
                download_url: str = asset["browser_download_url"]
                for _ in range(5):
                    parsed_url = urlparse(download_url)

                    if parsed_url.scheme == "https":
                        web_conn = client.HTTPSConnection(parsed_url.netloc)
                    else:
                        web_conn = client.HTTPConnection(parsed_url.netloc)

                    web_conn.request(
                        "GET",
                        f"{parsed_url.path}?{parsed_url.query}",
                        headers=self.headers,
                    )
                    res = web_conn.getresponse()

                    if res.status in (301, 302, 303, 307, 308):
                        location = res.getheader("Location")

                        if not location:
                            raise RuntimeError("Redirect without Location header.")
                        download_url = location
                        web_conn.close()
                        continue

                    filename = DOWNLOADS_DIR / name
                    with open(filename, "wb") as f:
                        while chunk := res.read(8192):
                            f.write(chunk)

                    print(f"Download Complete: {filename}")

                    web_conn.close()
                    return ReleaseAsset(path=filename, name=name)

        return None


github = GitHub()


print_title("1. Helix")
asset = github.download_release(
    ReleaseConfig(
        owner="SymphonySimper",
        repo="fork-helix",
        name=re.compile(r"helix.*-x86_64-windows\.zip"),
    )
)
if asset is not None:
    only_name = asset["name"][:-4]
    shutil.unpack_archive(asset["path"], DOWNLOADS_DIR)

    exe_name = "hx.exe"
    exe_from = DOWNLOADS_DIR / only_name / "hx.exe"
    exe_to = BIN_DIR / exe_name

    if exe_to.exists():
        exe_to.unlink()

    shutil.copy2(exe_from, exe_to)

    runtime_name = "runtime"
    runtime_from = DOWNLOADS_DIR / only_name / runtime_name
    runtime_to = CONFIG_DIR / "helix" / runtime_name

    if runtime_to.exists():
        shutil.rmtree(runtime_to)

    shutil.copytree(runtime_from, runtime_to)
