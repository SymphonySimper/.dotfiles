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

    # PDF
    programs.zathura.enable = true;

    my.programs.desktop =
      let
        id = "org.pwmt.zathura";
      in
      {
        mime.${id} = [
          "application/pdf"
        ];

        automove = [
          {
            name = "${id}.desktop";
            workspace = 4;
          }
        ];
      };
  };
}
