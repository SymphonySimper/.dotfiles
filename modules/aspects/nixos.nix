{ den, lib, ... }: {
  den.default.includes = [ den.aspects.nixos ];

  den.aspects.nixos = {
    nixos = { pkgs, ... }: {
      # FHS environment
      programs.nix-ld = {
        enable = true;
        libraries = [
          pkgs.stdenv.cc.cc
          pkgs.zlib
        ];
      };

      # Clean /tmp folder on boot
      boot.tmp = {
        cleanOnBoot = true;
        useTmpfs = true;
      };

      time.timeZone = lib.mkDefault "Asia/Kolkata";
      services.timesyncd.enable = lib.mkDefault true;

      # refer: https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
      i18n.defaultLocale = "en_US.UTF-8";

      system.stateVersion = "25.11";
    };
  };
}
