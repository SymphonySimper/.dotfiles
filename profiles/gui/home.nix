{ pkgs, lib, ... }:
{
  my.programs = {
    vcs.profiles.gnome = rec {
      host = "ssh.gitlab.gnome.org";
      email = "164710-SymphonySimper@users.noreply.gitlab.gnome.org";
      config.user.email = email;
    };
  };

  programs = {
    gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };

  home.packages = [
    pkgs.libreoffice

    (pkgs.writeShellScriptBin "mynixpkgsreview" ''
      pr_id="$1"

      if [ -z "$1" ]; then
        echo "Requires PR ID (ex: 481226)."
        exit 1
      fi

      ${lib.getExe' pkgs.nixpkgs-review "nixpkgs-review"} pr --post-result "$pr_id"
    '')
  ];
}
