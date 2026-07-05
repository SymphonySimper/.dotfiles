{ config, lib, ... }: {
  options.my.fonts = {
    enable = lib.mkEnableOption "Enable fonts";
  };

  config = {
    fonts = lib.mkIf config.my.fonts.enable {
      enableDefaultPackages = true;
      fontDir.enable = true;
    };
  };
}
