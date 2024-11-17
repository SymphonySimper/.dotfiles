{
  pkgs,
  inputs,
  my,
  ...
}:
let
  locale = "en_US.UTF-8";
  defaultDirConfig = {
    d = {
      group = "users";
      user = "${my.name}";
      mode = "0755";
    };
  };
in
{
  imports = [
    ./packages/default.nix
    (import ../modules/common/nix.nix {
      inherit inputs;
      system = true;
    })
  ];

  # Enable flakse
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "23.11"; # Do no change

  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # Required to make mamba-managed Python run without an FHS environment
  programs.nix-ld.enable = true;

  networking.hostName = "nixos"; # Define your hostname.

  users = {
    mutableUsers = true;
    users.${my.name} = {
      initialHashedPassword = "$6$zzXPOtlNAnpUTgHe$.VZIkoqeZQWtACW6JFOZBeUUT5ds7PDpfoMZQOfWNCND0ukdGVd7jA2Ko86g8tPDxfpM3D0rVkCRUfEz/hJiN0";
      isNormalUser = true;
      home = my.dir.home;
      description = "${my.fullName}";
      extraGroups = [
        "wheel"
        "networkmanager"
        "uinput"
        "libvirtd"
        "video"
        "input"
        "disk"
      ];
    };
  };

  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Kolkata";
  services.timesyncd.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = locale;
  i18n.extraLocaleSettings = {
    LC_ADDRESS = locale;
    LC_IDENTIFICATION = locale;
    LC_MEASUREMENT = locale;
    LC_MONETARY = locale;
    LC_NAME = locale;
    LC_NUMERIC = locale;
    LC_PAPER = locale;
    LC_TELEPHONE = locale;
    LC_TIME = locale;
  };

  fonts = {
    fontconfig.enable = true;
    fontDir.enable = true;
  };

  # Clean /tmp folder on boot
  boot.tmp.cleanOnBoot = true;
  boot.tmp.useTmpfs = true;

  systemd.tmpfiles.settings = {
    "${my.name}-fav-dirs" = {
      "${my.dir.dev}" = defaultDirConfig;
      "${my.dir.dev}/work" = defaultDirConfig;
      "${my.dir.data}" = defaultDirConfig;
    };
  };
}
