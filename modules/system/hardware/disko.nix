{
  lib,
  config,
  inputs,
  ...
}:
let
  cfg = config.my.hardware.disko;
in
{
  imports = [ inputs.disko.nixosModules.default ];

  options.my.hardware.disko = {
    enable = lib.mkEnableOption "disko";
    device = lib.mkOption {
      type = lib.types.str;
      description = "Device path (ex: /dev/nvme0n1)";
    };
    swap = lib.mkOption {
      type = lib.types.str;
      description = "Swap size (ex: 16G)";
    };
  };

  config = lib.mkIf cfg.enable {
    disko.devices = {
      disk.main = {
        device = cfg.device;
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
