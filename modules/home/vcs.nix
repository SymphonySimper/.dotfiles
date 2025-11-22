{
  config,
  my,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vcs;
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "vcs" "root" ] [ "programs" "git" ])
  ];

  options.my.programs.vcs =
    (lib.my.mkCommandOption {
      category = "VCS";
      command = "git";
    })
    // {
      tui = (
        lib.my.mkCommandOption {
          category = "VCS TUI";
          command = "lazygit";
          args.path = "-p";
        }
      );

      profiles = lib.mkOption {
        type = lib.types.attrsOf (
          lib.types.submodule {
            options = {
              name = lib.mkOption {
                type = lib.types.str;
                description = "Perfix for indetity file";
              };

              host = lib.mkOption {
                type = lib.types.str;
                description = "Hostname for SSH";
              };

              email = lib.mkOption {
                type = lib.types.str;
                description = "VCS user email and for SSH key generation";
              };

              config = lib.mkOption {
                type = lib.types.nullOr (
                  lib.types.submodule {
                    options = {
                      dir = lib.mkOption {
                        type = lib.types.str;
                        description = "Directory for VCS condition config";
                      };

                      settings = lib.mkOption {
                        type = lib.types.attrsOf lib.types.anything;
                        description = "VCS config to include for the director";
                      };
                    };
                  }
                );
                default = null;
                description = "Conditional config based on directory";
              };
            };
          }
        );
        description = "Profiles per SSH key";
      };
    };

  config = lib.mkMerge [
    {
      home.packages = with pkgs; [ git-filter-repo ];

      my.programs = {
        editor.ignore = [
          # do not ignore
          "!.gitignore"
          "!.gitattributes"
        ];

        vcs.profiles = {
          github = {
            name = "personal";
            host = "github.com";
            email = cfg.root.settings.user.email;
          };

          gnome-gitlab = rec {
            name = "gnome-gitlab";
            host = "ssh.gitlab.gnome.org";
            email = "164710-SymphonySimper@users.noreply.gitlab.gnome.org";

            config = {
              dir = "${my.dir.dev}/gnome";
              settings.user.email = email;
            };
          };
        };
      };

      programs.git = {
        enable = true;

        ignores = [
          "node_modules"
        ];

        settings = {
          user = {
            name = my.fullName;
            email = "50240805+SymphonySimper@users.noreply.github.com";
          };

          init.defaultBranch = "main";
          core.editor = config.my.programs.editor.command;

          push.autoSetupRemote = true;
          mergetool.keepBackup = false;
          pull.rebase = true;
          rebase.autoStash = true;

          merge = {
            tool = if config.my.programs.editor.command == "nvim" then "nvimdiff" else "";
            conflictStyle = "zdiff3";
          };

          rerere = {
            enabled = true;
            autoUpdate = true;
          };

          # NOTE: Aliases seems to be Case-insensitive
          # (i.e) `p` == `P`
          alias = {
            c = "clone";
            s = "status";
            a = "add";
            m = "commit";

            p = "pull";
            po = "pull origin";

            pu = "push";
            puf = "push --force-with-lease";

            st = "stash";
            stp = "stash pop";

            b = "branch";
            ce = "checkout";
            sw = "switch";

            r = "reset";
            rh = "reset --hard HEAD";
            ro = "!git reset --hard origin/$(git branch --show-current)";

            f = "fetch";
            fpa = "fetch --prune --all";

            # misc
            cln = "clean -fdx";

            # shell
            do = "!git fetch && git diff origin";
            z = "!${cfg.tui.command}";
          };
        };

        lfs.enable = true;
      };
    }

    # Profiles
    (
      let
        mkSSHIdentityFilename = name: "${config.my.programs.ssh.dir}/${name}_id_ed25519";
      in
      {
        home.packages = [
          (pkgs.writeShellScriptBin "myvcssshinit" (
            lib.strings.concatLines (
              builtins.map (
                profile:
                let
                  identityFile = mkSSHIdentityFilename profile.name;
                in
                # sh
                ''
                  if [ ! -f "${identityFile}" ]; then
                    echo "Generating identity for ${profile.name}"
                    ssh-keygen -t ed25519 -f "${identityFile}" -C "${profile.email}"
                  fi
                ''
              ) (builtins.attrValues cfg.profiles)
            )
          ))
        ];

        my.programs = {
          ssh.root.matchBlocks = builtins.mapAttrs (name: value: {
            hostname = value.host;
            identityFile = mkSSHIdentityFilename value.name;
            identitiesOnly = true;
          }) cfg.profiles;

          vcs.root.includes = (
            builtins.map (profile: {
              condition = "gitdir:${profile.config.dir}/";
              contents = profile.config.settings;
            }) (builtins.filter (profile: profile.config != null) (builtins.attrValues cfg.profiles))
          );
        };
      }
    )

    {
      programs.lazygit = {
        enable = true;

        settings = {
          git = {
            disableForcePushing = true;
          };

          gui = {
            showBottomLine = false;
            showPanelJumps = false;
            nerdFontsVersion = "3";
            useHunkModeInStagingView = false;
          };
        };
      };
    }
  ];
}
