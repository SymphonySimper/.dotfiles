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
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      settings."*" = {
        ForwardAgent = false;
        AddKeysToAgent = "yes";
        Compression = false;
        ServerAliveInterval = 0;
        ServerAliveCountMax = 3;
        HashKnownHosts = false;
        UserKnownHostsFile = "${cfg.dir}/known_hosts";
        ControlMaster = "no";
        ControlPath = "${cfg.dir}/master-%r@%n:%p";
        ControlPersist = "no";
      };
    };
  };
}
