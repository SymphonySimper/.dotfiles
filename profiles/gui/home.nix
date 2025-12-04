{ config, pkgs, ... }:
{
  my.programs = {
    vcs.profiles.gnome = rec {
      host = "ssh.gitlab.gnome.org";
      email = "164710-SymphonySimper@users.noreply.gitlab.gnome.org";
      config.user.email = email;
    };
  };

  # Add Google Chrome
  home.packages = [
    (pkgs.google-chrome.override {
      commandLineArgs = builtins.concatStringsSep " " config.my.programs.browser.args.chromium;
    })
  ];
}
