{ userSettings, ... }:
{
  "terminal" = {
    "default" = {
      "key" = "Return";
      "cmd" =
        if userSettings.programs.terminal == "foot" then "footclient" else userSettings.programs.terminal;
    };
  };
  "browser" = {
    "default" = {
      "key" = "f";
      "cmd" = userSettings.programs.browser;
    };
  };
  "launcher" = {
    "default" = {
      "key" = "d";
      "cmd" = "${userSettings.programs.launcher} --show drun";
    };
  };
  "brightness" = {
    "down" = {
      "key" = "F5";
      "cmd" = "brightness -d";
    };
    "up" = {
      "key" = "F6";
      "cmd" = "brightness -u";
    };
  };
  "volume" = {
    "down" = {
      "key" = "F2";
      "cmd" = "volume -d";
    };
    "up" = {
      "key" = "F3";
      "cmd" = "volume -u";
    };
    "toggle" = {
      "mod" = "Shift";
      "key" = "F2";
      "cmd" = "volume -m";
    };
  };
  "mic" = {
    "toggle" = {
      "key" = "F8";
      "cmd" = "volume -M";
    };
  };
  "screenshot" = {
    "screen" = {
      "key" = "F11";
      "cmd" = "screenshot -s";
    };
    "window" = {
      "mod" = "Ctrl";
      "key" = "F11";
      "cmd" = "screenshot -s";
    };
    "region" = {
      "mod" = "Shift";
      "key" = "F11";
      "cmd" = "screenshot -r";
    };
  };
  "caffiene" = {
    "toggle" = {
      "key" = "F10";
      "cmd" = "caffiene";
    };
  };
  "spotify" = {
    "toggle" = {
      "key" = "F7";
      "cmd" = "myspotify o";
    };
    "prev" = {
      "mod" = "Ctrl";
      "key" = "F7";
      "cmd" = "myspotify p";
    };
    "next" = {
      "mod" = "Shift";
      "key" = "F7";
      "cmd" = "myspotify n";
    };
  };
}
