#!/usr/bin/env bash

gh_name="SymphonySimper"
gh_repo=".dotfiles"
cd "$HOME" || exit 1

profile="$1"
if [ -z "$profile" ]; then
  echo "No profile passed (ex: gui)."
  exit 1
fi

echo "Cloning $gh_repo"
if [ ! -d "$HOME/$gh_repo" ]; then
	git clone "https://github.com/$gh_name/$gh_repo"
fi

echo "Buidling flake"
nix build "github:$gh_name/$gh_repo#homeConfigurations.${profile}.activationPackage"
result/activate
