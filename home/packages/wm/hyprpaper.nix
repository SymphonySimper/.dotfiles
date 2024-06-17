{ ... }:
let wallpaper = "~/.dotfiles/assets/images/bg.png"; in {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "off";
      preload = [ wallpaper ];
      wallpaper = [ ",${wallpaper}" ];
    };
  };
}
