{
  my,
  config,
  lib,
  ...
}:
let
  cfg = config.my.programs.ssh;
in
{
  imports = [
    (lib.modules.mkAliasOptionModule [ "my" "programs" "ssh" "root" ] [ "programs" "ssh" ])
  ];

  options.my.programs.ssh.dir = lib.mkOption {
    type = lib.types.str;
    description = "Directory where config id files are stored.";
    readOnly = true;
    default = "${my.dir.home}/.ssh";
  };

  config = {
    services.ssh-agent.enable = true;

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      matchBlocks = {
        "*" = {
          forwardAgent = false;
          addKeysToAgent = "yes";
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "${cfg.dir}/known_hosts";
          controlMaster = "no";
          controlPath = "${cfg.dir}/master-%r@%n:%p";
          controlPersist = "no";
        };

        "github" = {
          hostname = "github.com";
          identityFile = "${cfg.dir}/id_ed25519";
          identitiesOnly = true;
        };
      };
    };

    my.programs.scripts.reload.commands."SSH Agent" = {
      command = "systemctl restart --user ssh-agent.service";
      check = "ssh-agent";
    };
  };
}
