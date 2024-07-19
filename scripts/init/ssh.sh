#!/usr/bin/env bash

gen_ssh() {
  ssh-keygen -t ed25519 -f "$1" -C "$(git config --get user.email)"
}

get_email() {
  git config --get user.email
}

create_ssh_key() {
  if [ ! -f "$2" ]; then
    echo "$1"
    cd

    email="$(get_email)"
    echo "$1 Email: $email"

    gen_ssh "$2"
  else
    echo "$1 ssh exists!"
  fi
}

personal_ssh="$HOME/.ssh/id_ed25519"
work_ssh="$HOME/.ssh/work_id_ed25519"

create_ssh_key "Personal" "$personal_ssh"
create_ssh_key "Work" "$work_ssh"
