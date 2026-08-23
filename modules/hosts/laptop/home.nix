{ pkgs, ... }: {
  imports = [ ../../users/symph/home.nix ];

  desktop.enable = true;

  theme.fonts.enable = true;
  theme.gtk.enable = true;

  dev.go.enable = true;
  dev.harper.enable = true;
  dev.json.enable = true;
  dev.markdown.enable = true;
  dev.nix.enable = true;
  dev.python.enable = true;
  dev.rust.enable = true;
  dev.toml.enable = true;
  dev.web.enable = true;
  dev.yaml.enable = true;

  programs.bitwarden.enable = true;
  programs.chromium.enable = true;
  programs.clipboard.enable = true;
  programs.kitty.enable = true;
  programs.yazi.preview = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.git.user = {
    name = "SymphonySimper";
    email = "50240805+SymphonySimper@users.noreply.github.com";
  };

  scripts.nixpkgsReview.enable = true;

  home.packages = [
    pkgs.libreoffice
  ];
}
