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
        function abort() {
          printf "\n%s\n" "''${1:-Aborted.}";
          exit 1;
        }

        case "$1" in
          cpu)
            readarray -t flake_inputs < <(nix flake metadata --json | ${lib.getExe pkgs.jq} -r ".locks.nodes.root.inputs | keys[]")
            select input in "Abort" "''${flake_inputs[@]}"; do
              case "$input" in
                "") echo 'Not a vaild Input' ;;
                'Abort') abort ;;
                *)
                  echo "Chosen flake input: $input"
                  read -n 1 -rp "Would you like to continue? [y/N] " user_input
                  case "$user_input" in
                    y|Y) nix flake update "$input" ;;
                    *) abort
                  esac
                  break
                ;;
              esac
            done
            ;;
          new|init)
            if [ -z "$2" ]; then
              abort "Template name not passed."
            fi

            if [[ "$1" == "new" ]] && [ -z "$3" ]; then
              abort "Requires directory."
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
          *) abort "Unknown option." ;;
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

  my.programs.editor =
    let
      formatter = "nixfmt";
      nixdArgs = [ "--inlay-hints=false" ];

      nixdConfig = {
        nixpkgs.expr = "import <nixpkgs> { }";

        options = {
          nixos.expr = "(builtins.getFlake (builtins.toString ./.)).nixosConfigurations.${my.profile}.options";
          home-manager.expr = "(builtins.getFlake (builtins.toString ./.)).homeConfigurations.${my.profile}.options";
        };
      };
    in
    {
      packages = [
        pkgs.nixd
        pkgs.${formatter}
      ];

      lsp.nixd = {
        args = nixdArgs;
        config.nixd = nixdConfig;
      };

      language.nix = {
        formatter.command = formatter;

        language-servers = [
          {
            name = "nixd";
            except-features = [ "format" ];
          }
        ];
      };

      gui = {
        extensions = [ "nix" ];

        language.Nix = {
          language_servers = [
            "nixd"
            "!nil"
          ];
          formatter.external.command = formatter;
        };

        lsp.nixd = {
          binary.arguments = nixdArgs;
          settings = nixdConfig;
        };
      };
    };
}
