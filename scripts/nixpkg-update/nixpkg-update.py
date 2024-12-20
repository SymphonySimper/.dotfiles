import os
import subprocess
import sys
from typing import List, Set

HOME = os.getenv("HOME")

NIXPKGS_REPO = "git@github.com:SymphonySimper/fork-nixpkgs"
NIXPKGS_PARENT_DIR = f"{HOME}/lifeisfun/nix"


def run(*args: str) -> str:
    formatted_args: List[str] = []
    for arg in args:
        if len(arg.strip()) > 0:
            formatted_args.append(arg)

    try:
        output = subprocess.run(formatted_args, capture_output=True, text=True)
        output.check_returncode()

        return output.stdout
    except Exception as e:
        print(e)
        sys.exit(1)


class Git:
    def __init__(self, repo: str, location: str, remote_name: str = "origin") -> None:
        self.repo: str = repo

        self.remote_name: str = remote_name

        self.location: str = location
        self.repo_location: str = os.path.join(location, self.repo.split("/")[-1])

        if not os.path.isdir(self.location):
            os.makedirs(self.location, exist_ok=True)

        if not os.path.exists(self.repo_location):
            self.clone()

        self._cd_repo()

    def _cd_repo(self) -> None:
        os.chdir(self.repo_location)

    def clone(self) -> None:
        # shallow clone
        run("git", "clone", "--depth", "1", self.repo, self.repo_location)

    def reset(self) -> None:
        run("git", "reset", "--hard", "HEAD")

    def pull(self) -> None:
        run("git", "pull")

    def push(self, *args: str) -> None:
        run("git", "push", *args)

    def commit(self, message: str) -> None:
        run("git", "commit", "-m", message)

    def switch(self, branch: str, create: bool = False) -> None:
        run(
            "git",
            "switch",
            "-c" if create else "",
            branch,
        )

    def get_current_branch(self) -> str:
        return run("git", "branch", "--show-current")

    def get_all_branches(self) -> List[str]:
        all_branches: Set[str] = set()

        branches = run("git", "branch", "-a", "--format", "%(refname:short)")
        for branch in branches.split("\n"):
            if branch == self.remote_name or len(branch.strip()) == 0:
                continue

            if branch.startswith(self.remote_name):
                branch = branch.replace(f"{self.remote_name}/", "")

            all_branches.add(branch)

        return list(all_branches)

    def delete_branch(self, branch: str) -> None:
        # delete remote branch
        self.push("-d", self.remote_name, branch)

        # delete local branch
        run("git", "branch", "-d", branch)

    def create_branch(self, branch: str) -> None:
        all_branches = self.get_all_branches()

        if branch in all_branches:
            self.delete_branch(branch)

        self.switch(branch, create=True)
