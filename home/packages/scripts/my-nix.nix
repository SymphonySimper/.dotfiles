{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "my-nix" # bash
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
              y|Y) nix flake lock --update-input $input ;;
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
          *) echo "Unknown option" ;;
        esac
      ''
    )
  ];
}
