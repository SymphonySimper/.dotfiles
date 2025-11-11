{
  config,
  lib,
  inputs,
  ...
}:
let
  cfg = config.my.hardware.disko;
in
{
  imports = [
    inputs.disko.nixosModules.default
  ];

  options.my.hardware.disko = {
    enable = lib.mkEnableOption "Disko";
    disk = lib.mkOption {
      type = lib.types.str;
      description = "Disk to use in partitioning (ex: /dev/nvme0n1)";
    };
    swap = lib.mkOption {
      type = lib.types.str;
      description = "Swap space (ex: 16G)";
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = {
      disk.main = {
        device = cfg.disk;
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              type = "EF00";
              size = "1G";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              end = "-${cfg.swap}";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
            swap = {
              size = "100%";
              content = {
                type = "swap";
                discardPolicy = "both";
                resumeDevice = true;
              };
            };
          };
        };
      };
    };
  };
}
