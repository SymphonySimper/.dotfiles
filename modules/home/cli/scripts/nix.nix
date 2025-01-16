{ pkgs, my, ... }:
let
  flake_loc = "${my.dir.home}/.dotfiles";
in
# bash
''
  case "$1" in
    cpu)
      input=$(nix flake metadata --json | ${pkgs.jq}/bin/jq -r ".locks.nodes.root.inputs | keys[]" | ${pkgs.fzf}/bin/fzf)
      if [ ''${#input} -eq 0 ]; then
        echo "No input."
        exit 1
      fi

      echo "$input"
      read -n 1 -p  "Would you like to continue? [y/N]" user_input
      case "$user_input" in
        y|Y) nix flake update $input ;;
        *) echo "Aborted."
      esac
      ;;
    diff)
      nix profile diff-closures --profile /nix/var/nix/profiles/system
      nix profile diff-closures --profile ~/.local/state/nix/profiles/home-manager
      ;;
    cln|clean)
      sudo nix-collect-garbage -d && nix-collect-garbage -d
      ;;
    new|init)
      if [ -z "$2" ]; then
        echo "Template name not passed."
        exit 1
      fi

      if [[ "$1" == "new" ]] && [ -z "$3" ]; then
        echo "Requires directory."
        exit 1
      fi

      nix flake "$1" --template "${flake_loc}#templates.$2" $3
      ;;
    dev)
      shift;
      devshell="$1"
      shift;
      
      nix develop "$devshell" -c "${my.programs.shell}" $@
      ;;
    gdev)
      shift;
      
      devshell="$1"
      if [[ -z "$devshell" ]]; then
        devshell="default"
      fi

      nix develop "${my.dir.home}/.dotfiles#$devshell" -c "${my.programs.shell}"
      ;;
    *) echo "Unknown option" ;;
  esac
''
