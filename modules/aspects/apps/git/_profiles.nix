{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.programs.git;

  defaultProfile = "default";
  sshAlgorithm = "ed25519";
  mkSSHIdentityFilename = name: "\${HOME}/.ssh/${name}-id-${sshAlgorithm}";
  mkProfileDir = name: "${config.xdg.userDirs.projects}/${name}";
in
{
  options.programs.git = {
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

  config = {
    programs.git = {
      includes = (
        map
          (profile: {
            condition = "gitdir:${mkProfileDir profile.name}/";
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

      profiles = {
        ${defaultProfile} = {
          host = "github.com";
          email = cfg.settings.user.email;
        };
      };
    };

    programs.ssh.settings = builtins.mapAttrs (name: value: {
      Hostname = value.host;
      IdentityFile = mkSSHIdentityFilename name;
      IdentitiesOnly = true;
    }) cfg.profiles;

    home.packages = [
      (pkgs.writeShellScriptBin "my-git-profiles-init" (
        lib.strings.concatLines (
          builtins.concatMap (
            profile:
            let
              identityFile = mkSSHIdentityFilename profile.name;
              dir = mkProfileDir profile.name;
            in
            [
              (lib.strings.optionalString (profile.name != defaultProfile) ''
                if [ ! -d "${dir}" ]; then
                  mkdir --parents --verbose "${dir}"
                fi
              '')

              ''
                if [ ! -f "${identityFile}" ]; then
                  echo "Generating identity for '${profile.name}':"
                  /run/current-system/sw/bin/ssh-keygen -t ${sshAlgorithm} -f "${identityFile}" -C "${profile.value.email}"
                fi
              ''
            ]
          ) (lib.attrsets.attrsToList cfg.profiles)
        )
      ))
    ];
  };
}
