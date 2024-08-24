{ pkgs, profileSettings, ... }:
{
  imports = [
    ./go.nix
    ./js.nix
    ./python.nix
    ./rust.nix
    ./ssh.nix
  ];

  home.packages =
    with pkgs;
    [
      gcc
      gnumake
      google-cloud-sdk
    ]
    ++ (if profileSettings.profile == "gui" then [ vscode-fhs ] else [ ]);
}
