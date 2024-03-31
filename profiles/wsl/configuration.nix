{ userSettings, ... }:
{
  imports = [
    ../../system/default.nix
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl = {
    enable = true;
    defaultUser = userSettings.username;
    wslConf = {
      user.default = userSettings.username;
      interop.appendWindowsPath = false;
    };
  };
}
