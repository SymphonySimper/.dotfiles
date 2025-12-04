{
  config,
  my,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.programs.vcs;
  defaultProfile = "default";
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
              host = lib.mkOption {
                type = lib.types.str;
                description = "Hostname for SSH";
              };

              email = lib.mkOption {
                type = lib.types.str;
                description = "VCS user email and for SSH key generation";
              };

              config = lib.mkOption {
                type = lib.types.nullOr (lib.types.attrsOf lib.types.anything);
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
          ${defaultProfile} = {
            host = "github.com";
            email = cfg.root.settings.user.email;
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
        algorithm = "ed25519";

        mkSSHIdentityFilename = name: "${config.my.programs.ssh.dir}/${name}-id-${algorithm}";
        mkDir = name: "${my.dir.dev}/${name}";
      in
      {
        home.activation = {
          myVCSProfiles = lib.hm.dag.entryAfter [ "writeBoundary" ] (
            lib.strings.concatLines (
              builtins.concatMap (
                profile:
                let
                  identityFile = mkSSHIdentityFilename profile.name;
                  dir = mkDir profile.name;
                in
                [
                  (lib.strings.optionalString (profile.name != defaultProfile) # sh
                    ''
                      if [ ! -d "${dir}" ]; then
                        mkdir --parents --verbose "${dir}"
                      fi
                    ''
                  )

                  # sh
                  ''
                    if [ ! -f "${identityFile}" ]; then
                      echo "Generating identity for '${profile.name}':"
                      ${my.dir.runBin}/ssh-keygen -t ${algorithm} -f "${identityFile}" -C "${profile.value.email}"
                    fi
                  ''
                ]
              ) (lib.attrsets.attrsToList cfg.profiles)
            )
          );
        };

        my.programs = {
          ssh.root.matchBlocks = builtins.mapAttrs (name: value: {
            hostname = value.host;
            identityFile = mkSSHIdentityFilename name;
            identitiesOnly = true;
          }) cfg.profiles;

          vcs.root = {
            includes = (
              builtins.map
                (profile: {
                  condition = "gitdir:${mkDir profile.name}/";
                  contents = profile.value.config;
                })
                (
                  lib.attrsets.attrsToList (
                    lib.attrsets.filterAttrs (
                      name: value: (name != defaultProfile) && (value.config != null)
                    ) cfg.profiles
                  )
                )
            );

            settings.alias.cs =
              let
                mkClone =
                  name: # sh
                  ''
                    ${cfg.command} clone git@${name}:$suffix "''${@}"
                  '';

                script = lib.getExe (
                  pkgs.writeShellScriptBin "my-vcs-clone-ssh" (
                    lib.strings.concatLines (
                      builtins.concatLists [
                        [
                          # sh
                          ''
                            curr_dir=$(pwd)  
                            suffix="$1"
                            shift
                          ''
                        ]
                        (builtins.map (
                          name: # sh
                          ''
                            if [ "$curr_dir" == "${mkDir name}" ]; then
                              ${mkClone name}
                              exit 0
                            fi
                          '') (builtins.filter (name: name != defaultProfile) (builtins.attrNames cfg.profiles)))
                        [ (mkClone defaultProfile) ]
                      ]
                    )
                  )
                );
              in
              "!${script}";
          };
        };
      }
    )

    {
      catppuccin.lazygit.enable = false;

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

            theme =
              with my.theme.color;
              let
                accent = my.theme.color.${my.theme.accent};
              in
              {
                activeBorderColor = [
                  accent
                  "bold"
                ];
                inactiveBorderColor = [ subtext0 ];
                optionsTextColor = [ blue ];
                selectedLineBgColor = [ surface0 ];
                cherryPickedCommitBgColor = [ surface1 ];
                cherryPickedCommitFgColor = [ accent ];
                unstagedChangesColor = [ red ];
                defaultFgColor = [ text ];
                searchingActiveBorderColor = [ yellow ];
              };

            authorColors."*" = my.theme.color.lavender;
          };
        };
      };

      my.programs.copy.of = [
        {
          from = "CONFIG/lazygit/config.yml";
          to = "WINDOWS/lazygit/config.yml";
        }
      ];
    }
  ];
}
