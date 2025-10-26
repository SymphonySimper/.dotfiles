{
  my,
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.copy;
  rsync = lib.getExe' pkgs.rsync "rsync";

  expansions = [
    {
      key = "CONFIG";
      value = config.xdg.configHome;
    }
    {
      key = "WINDOWS";
      value = "${my.dir.home}/.dotfiles/config/windows";
    }
  ];

  expansionKeys = builtins.map (expansion: expansion.key) expansions;
  expansionValues = builtins.map (expansion: expansion.value) expansions;

  mkReplaceExpansions = content: builtins.replaceStrings expansionKeys expansionValues content;
  mkCliCommand =
    command: args: argsToEscape:
    builtins.concatStringsSep " " (
      builtins.concatLists [
        [ command ]
        args
        [ (lib.strings.escapeShellArgs argsToEscape) ]
      ]
    );
in
{
  options.my.programs.copy = {
    of = lib.mkOption {
      description = "Files to be copied";

      type = lib.types.listOf (
        lib.types.submodule {
          options = {
            from = lib.mkOption {
              type = lib.types.str;
              description = "Location of files to be copied from.";
            };

            to = lib.mkOption {
              type = lib.types.str;
              description = "Destination of files to be copied to.";
            };

            exclude = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              description = "Files to exclude";
              default = [ ];
            };

            post = lib.mkOption {
              type = lib.types.lines;
              description = "Logic to run after copy.";
              default = '''';
            };
          };
        }
      );
    };
  };

  config = lib.mkIf ((builtins.length cfg.of) > 0) {
    home.activation =
      let
        name = "myCopy";
        # filter is not required, but it's here to make sure nothing funky happens
        entries = builtins.filter (entry: entry != name) (builtins.attrNames config.home.activation);
      in
      {
        ${name} = lib.hm.dag.entryAfter entries (
          lib.strings.concatLines (
            builtins.map (
              file:
              let
                from = mkReplaceExpansions file.from;
                to = mkReplaceExpansions file.to;
                exclude = lib.lists.optionals ((builtins.length file.exclude) > 0) (
                  builtins.map (ex: "--exclude=${ex}") file.exclude
                );
                post = mkReplaceExpansions file.post;
              in
              # sh
              ''
                if [ -d "${to}" ] || [ -f "${to}" ] || [ -L "${to}" ]; then
                  ${mkCliCommand "rm"
                    [
                      "--force"
                      "--recursive"
                      # "--verbose"
                    ]
                    [ to ]
                  }
                  # echo "Removed: ${to}"
                fi

                if [ -d "${from}" ] || [ -f "${from}" ] || [ -L "${from}" ]; then
                  ${mkCliCommand rsync
                    (
                      [
                        "--archive"
                        "--no-perms"
                        "--chmod=ugo=rwX"
                        "--force"
                        "--copy-links"
                        "--recursive"
                        # "--verbose"
                      ]
                      ++ exclude
                    )
                    [
                      from
                      to
                    ]
                  }

                  ${post}

                  echo "Copied: ${from} to ${to}"
                fi
              ''
            ) cfg.of
          )
        );
      };
  };
}
