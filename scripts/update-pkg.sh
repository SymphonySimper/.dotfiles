#!/usr/bin/env zsh

# base_dir="$HOME/lifeisfun/nix"

repo='git@github.com:SymphonySimper/fork-nixpkgs'
repo_upstream='git@github.com:NixOS/nixpkgs.git'

repo_name=$(basename "$repo")
repo_dir="$HOME/lifeisfun/nix/$repo_name"

branch_main="master"
remote_name="origin"
remote_upstream_name="upstream"

if [[ ! -d "$repo_dir" ]]; then
  # shallow clone to repo_dir
  git clone --depth 1 "$repo" "$repo_dir"

  cd "$repo_dir"
  git remote add "$remote_upstream_name" "$repo_upstream"
fi

cd "$repo_dir"

git fetch "$remote_upstream_name"
git switch "$branch_main"
git rebase "$remote_upstream_name/$branch_main"
git push -f "$remote_name" "$branch_main"
