{ config, pkgs, lib, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      palette = "catppuccin_mocha";
      format = lib.concatStrings [
        "$all"
        "$fill"
        "$time"
        "$line_break"
        "$character"
      ];

      character = {
        success_symbol = "[>](bold lavender)";
        error_symbol = "[x](bold red)";
        vimcmd_symbol = "[v](bold peach)";
      };

      fill = {
        disabled = false;
        symbol = " ";
      };

      directory = {
        style = "bold lavender";
        truncate_to_repo = false;
      };

      time = {
        disabled = false;
        format = "[($time)](overlay0)";
        time_format = "%H:%M";
        utc_time_offset = "local";
      };

      gcloud = {
        disabled = true;
      };

      palettes = {
        catppuccin_mocha =
          {
            rosewater = "#f5e0dc";
            flamingo = "#f2cdcd";
            pink = "#f5c2e7";
            mauve = "#cba6f7";
            red = "#f38ba8";
            maroon = "#eba0ac";
            peach = "#fab387";
            yellow = "#f9e2af";
            green = "#a6e3a1";
            teal = "#94e2d5";
            sky = "#89dceb";
            sapphire = "#74c7ec";
            blue = "#89b4fa";
            lavender = "#b4befe";
            text = "#cdd6f4";
            subtext1 = "#bac2de";
            subtext0 = "#a6adc8";
            overlay2 = "#9399b2";
            overlay1 = "#7f849c";
            overlay0 = "#6c7086";
            surface2 = "#585b70";
            surface1 = "#45475a";
            surface0 = "#313244";
            base = "#1e1e2e";
            mantle = "#181825";
            crust = "#11111b";
          };
      };
    };
  };
}
