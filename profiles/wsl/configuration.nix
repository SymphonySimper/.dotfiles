{ userSettings, ... }:
{
  imports = [
    ../../system/default.nix
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = userSettings.username;
}
