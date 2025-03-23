{ pkgs, ... }:
{
  programs.tofi = {
    enable = true;
    settings = {
      ascii-input = true;
      late-keyboard-init = false;

      width = "100%";
      height = "100%";
      border-width = 0;
      outline-width = 0;
      padding-left = "35%";
      padding-top = "35%";
      result-spacing = 25;
      num-results = 5;

      # cd $(nix build nixpkgs#nerd-fonts.jetbrains-mono --print-out-paths --no-link)/share/fonts/truetype/NerdFonts/JetBrainsMono
      font = "${pkgs.nerd-fonts.jetbrains-mono}/share/fonts/truetype/NerdFonts/JetBrainsMono/JetBrainsMonoNerdFont-Regular.ttf";
    };
  };
}
