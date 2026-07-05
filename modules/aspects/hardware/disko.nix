{ inputs, lib, ... }: {
  flake-file.inputs.disko = {
    url = "github:nix-community/disko";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  den.aspects.hardware.disko = {
    nixos =
      { config, ... }:
      let
        cfg = config.hardware.disko;
      in
      {
        imports = [ inputs.disko.nixosModules.default ];

        options.hardware.disko = {
          disk = lib.mkOption {
            type = lib.types.str;
            description = "Disk to use in partitioning";
            example = "/dev/nvme0n1";
          };
          swap = lib.mkOption {
            type = lib.types.str;
            description = "Swap space";
            example = "16G";
          };
        };

        config = {
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
      };
  };
}
