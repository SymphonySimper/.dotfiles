{
  my,
  pkgs,
  lib,
  ...
}:
let
  mkOpenDesktopEntry =
    file: "${lib.getExe pkgs.dex} ${my.dir.home}/.nix-profile/share/applications/${file}.desktop";

  keybinds = {
    terminal = {
      default = {
        key = "Return";
        cmd = my.programs.terminal;
      };
    };
    notifybar = {
      default = {
        key = "b";
        cmd = "mynotifybar";
      };
    };
    launcher = {
      default = {
        key = "d";
        cmd = "uwsm app -- $(${my.programs.launcher} --show drun --define=drun-print_desktop_file=true)";
      };
    };
    files = {
      default = {
        key = "e";
        cmd = "uwsm app -- ${lib.getExe pkgs.nautilus}";
      };
    };
    browser = {
      default = {
        key = "f";
        cmd = my.programs.browser;
      };
    };
    power = {
      off = {
        mod = "Shift";
        key = "x";
        cmd = "poweroff";
      };
    };
    volume = {
      down = {
        key = "F2";
        cmd = "myvolume -d";
      };
      up = {
        key = "F3";
        cmd = "myvolume -u";
      };
      toggle = {
        mod = "Shift";
        key = "F2";
        cmd = "myvolume -m";
      };
    };
    network = {
      reload = {
        mod = "Shift";
        key = "F5";
        cmd = "myreload";
      };
    };
    brightness = {
      down = {
        key = "F5";
        cmd = "mybrightness -d";
      };
      up = {
        key = "F6";
        cmd = "mybrightness -u";
      };
    };
    music = {
      open = {
        key = "F7";
        super = false;
        cmd = (mkOpenDesktopEntry "ytmusic");
      };
    };
    mic = {
      toggle = {
        super = false;
        key = "F8";
        cmd = "myvolume -M";
      };
    };
    caffiene = {
      toggle = {
        key = "F10";
        cmd = "mycaffiene";
      };
    };
    maxFps = {
      toggle = {
        mod = "Shift";
        key = "F10";
        cmd = "mytogglefps";
      };
    };
    screenshot = {
      screen = {
        key = "F11";
        cmd = "myscreenshot -s";
      };
      window = {
        mod = "Ctrl";
        key = "F11";
        cmd = "myscreenshot -w";
      };
      region = {
        mod = "Shift";
        key = "F11";
        cmd = "myscreenshot -r";
      };
    };
  };
in
(builtins.concatMap (
  key:
  (map (
    action:
    let
      set = keybinds.${key}.${action};
    in
    {
      inherit action;
      name = key;
      key = set.key;
      cmd = set.cmd;
      super = lib.my.mkGetDefault set "super" true;
    }
    // (if builtins.hasAttr "mod" set then { mod = set.mod; } else { })
  ) (builtins.attrNames keybinds.${key}))
) (builtins.attrNames keybinds))
