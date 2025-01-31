{ pkgs, ... }:
let
  mynix =
    pkgs.writeShellScriptBin "mynix"
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

            nix flake "$1" --template "my#templates.$2" $3
            ;;
          dev)
            shift;
            devshell="$1"
            shift;
            
            nix develop "$devshell" 
            ;;
          *) echo "Unknown option" ;;
        esac
      '';
in
{
  home = {
    shellAliases = {
      snrs = "cd $HOME/.dotfiles && sudo nixos-rebuild switch --flake";
      hmbs = "cd $HOME/.dotfiles && home-manager build switch --flake";
      nix_flake_update = "nix flake update --commit-lock-file";
      ncln = "${mynix}/bin/mynix cln";
    };

    packages = [ mynix ];
  };

  programs.nixvim.plugins = {
    treesitter.grammars = [ "nix" ];

    lsp.servers.nil_ls = {
      enable = true;
      settings.nix.flake.autoArchive = true;
    };

    formatter = {
      packages = [
        "nixfmt-rfc-style"
      ];
      ft.nix = "nixfmt";
    };
  };
}
