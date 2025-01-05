{ lib, ... }:
let
  mkGetDefault = import ./mkGetDefault.nix { inherit lib; };
  mkGetColor = import ./mkGetColor.nix;

  mkMy =
    {
      settings ? { },
      profile ? { },
    }:
    let
      passedProfile = profile;
    in
    rec {
      name = "symph";
      fullName = "SymphonySimper";
      dir = {
        home = "/home/${name}";
        dev = "${dir.home}/lifeisfun";
        data = "${dir.home}/importantnt";
      };
      profile = mkGetDefault passedProfile "name" "default";
      system = mkGetDefault passedProfile "system" "x86_64-linux";
      gui = {
        enable = mkGetDefault settings "gui.enable" false;
        desktop = {
          enable = mkGetDefault settings "gui.desktop.enable" false;
          type = mkGetDefault settings "gui.desktop.type" "wm"; # wm or de
          wm = gui.desktop.type == "wm";
        };
        display = {
          name = mkGetDefault settings "gui.display.name" "eDP-1";
          scale = mkGetDefault settings "gui.display.scale" 1;
          width = mkGetDefault settings "gui.display.width" 1920;
          height = mkGetDefault settings "gui.display.height" 1080;
          refreshRate = mkGetDefault settings "gui.display.refreshRate" 60;
        };
      };
      theme = {
        dark = mkGetDefault settings "theme.dark" false;
        flavors = {
          dark = "mocha";
          light = "latte";
        };
        flavor = builtins.getAttr (if theme.dark then "dark" else "light") theme.flavors;
        altFlavor = builtins.getAttr (if theme.dark then "light" else "dark") theme.flavors;
        color = mkGetColor theme.flavor;
        gtk = if theme.dark then "Adwaita-dark" else "Adwaita";
        wallpaper = "${dir.home}/.dotfiles/lib/assets/images/bg.png";

        font = {
          sans = "Poppins";
          mono = "JetBrainsMono Nerd Font";
          glyph = "Font Awesome 6 Free";
        };
      };
      programs = {
        terminal = "alacritty";
        editor = "nvim";
        multiplexer = "tmux";
        browser = "chromium";
        launcher = "wofi";
        notification = "dunst";
        music = "yt";
        video = "mpv";
        pdf = "zathura";
        image = "loupe";
      };
    };
in
mkMy
