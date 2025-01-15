{
  my,
  inputs,
  config,
  pkgs,
  lib,
  chaotic-pkgs,
  ...
}:
let
  cfg = config.my.programs.steam;

  args = [
    "-f" # full screen
    "-e" # steam integration
    "-W ${builtins.toString cfg.display.width}"
    "-H ${builtins.toString cfg.display.height}"
    "-r ${builtins.toString cfg.display.refreshRate}" # Refresh rate
    # "--expose-wayland"
    # "--backend wayland"
    # "-C" # hide cursor after time delay :smh
    # "--force-grab-cursor"
  ];
in
{
  options.my.programs.steam = {
    enable = lib.mkEnableOption "steam";
    display = lib.mkOption {
      description = "Display settings to be used in gamescope";
      default = { };
      type = lib.types.submodule {
        options = {
          width = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Width of the display";
            default = my.gui.display.width;
          };
          height = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Height of the display";
            default = my.gui.display.height;
          };
          refreshRate = lib.mkOption {
            type = lib.types.ints.positive;
            description = "Refresh rate fo the display";
            default = my.gui.display.refreshRate;
          };
        };
      };
    };
  };
  config = lib.mkIf cfg.enable {
    programs.steam.enable = true;

    specialisation.steam = {
      inheritParentConfig = true;
      configuration = {
        imports = [
          inputs.nix-gaming.nixosModules.platformOptimizations
        ];

        my.programs.wm.enableLogin = false;
        programs = {
          steam = {
            # Refer: https://nixos.wiki/wiki/Steam
            extest.enable = true;
            platformOptimizations.enable = true;
            dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
            localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
            remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
            gamescopeSession = {
              enable = true;
              args = builtins.filter (arg: arg != "-e") args;
            };
          };

          gamemode.enable = true;
          gamescope = {
            enable = true;
            capSysNice = false;
            # Set launch options to `LD_PRELOAD="" gamescope -- %command%`
            # to launch with mangohud use `gamescope --mangoapp -- %command%`
            inherit args;
          };
        };

        boot.kernelParams = [ "preempt=full" ];
        # https://github.com/sched-ext/scx/blob/main/INSTALL.md#nix
        services.scx = {
          enable = true;
          scheduler = "scx_lavd";
        };

        environment = {
          systemPackages = [ pkgs.mangohud ];
          loginShellInit = lib.my.mkTTYLaunch {
            command = "steam-gamescope";
            dbus = true;
            tty = 1;
          };
        };
      };
    };
  };
}
