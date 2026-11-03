{ pkgs, ... }: {
  imports = [ ../../users/symph/home.nix ];

  desktop.enable = true;

  theme.fonts.enable = true;
  theme.gtk.enable = true;

  dev.ai.packages = [
    "claude-code"
    "opencode2"
    "t3code-desktop"
  ];

  dev.android.enable = true;
  dev.go.enable = true;
  dev.json.enable = true;
  dev.markdown.enable = true;
  dev.nix.enable = true;
  dev.python.enable = true;
  dev.rust.enable = true;
  dev.toml.enable = true;
  dev.typst.enable = true;
  dev.web.enable = true;
  dev.yaml.enable = true;

  programs.bitwarden.enable = true;
  programs.chromium.enable = true;
  programs.clipboard.enable = true;
  programs.discord.enable = true;
  programs.hex.enable = true;
  programs.kitty.enable = true;

  programs.gh = {
    enable = true;
    settings.git_protocol = "ssh";
  };

  programs.git.user = {
    name = "SymphonySimper";
    email = "50240805+SymphonySimper@users.noreply.github.com";
  };

  home.packages = [
    pkgs.libreoffice
  ];
}
