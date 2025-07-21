{
  my,
  pkgs,
  lib,
  ...
}:
let
  mynix =
    pkgs.writeShellScriptBin "mynix"
      # sh
      ''
        case "$1" in
          cpu)
            input=$(nix flake metadata --json | ${lib.getExe pkgs.jq} -r ".locks.nodes.root.inputs | keys[]" | ${lib.getExe' pkgs.fzf "fzf"})
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
          update) nix flake update --commit-lock-file ;;
          *) echo "Unknown option" ;;
        esac
      '';
in
{
  home.packages = [ mynix ];

  programs = {
    nix-index = {
      enable = true;
      enableBashIntegration = false;
    };

    nix-index-database.comma.enable = true;
  };

  my.programs.editor = {
    lsp.nixd = {
      command = "${lib.getExe pkgs.nixd}";
      args = [ "--inlay-hints=false" ];

      config.nixd = {
        nixpkgs.expr = "import <nixpkgs> { }";

        options = {
          nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${my.profile}.options";
          home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.${my.profile}.options";
        };
      };
    };

    language.nix = {
      formatter.command = "${lib.getExe pkgs.nixfmt}";

      language-servers = [
        {
          name = "nixd";
          except-features = [ "format" ];
        }
      ];
    };
  };
}
