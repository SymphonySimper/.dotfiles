{ lib, ... }:
{
  home.sessionVariables = {
    STARSHIP_LOG = "error";
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      scan_timeout = 30;
      command_timeout = 80; # default 500
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

      python.symbol = "󰌠 ";

      nix_shell = {
        format = "via [$symbol$state]($style) ";
        symbol = "󱄅 ";
      };

      gcloud.disabled = true;
    };
  };
}
