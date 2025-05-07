{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.my.programs.office.enable = lib.mkEnableOption "Office";
  config = lib.mkIf config.my.programs.office.enable {
    home.packages = with pkgs; [ libreoffice ];

    programs.zathura.enable = true;
    my.desktop = {
      mime."org.pwmt.zathura" = [
        "application/pdf"
      ];

      windows = [
        {
          id = "org.pwmt.zathura";
          workspace = 4;
        }
      ];
    };
  };
}
