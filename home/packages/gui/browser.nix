{ pkgs, ... }:
{
  home.packages = with pkgs; [ firefox ];

  programs.chromium = {
    enable = true;
    package = pkgs.chromium.override { enableWideVine = true; };
    extensions = [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # ublock origin
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
      "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin mocha
      # "mjdepdfccjgcndkmemponafgioodelna" # df youtube
      "mnjggcdmjocbbbhaepdhchncahnbgone" # sponsor block
      "edibdbjcniadpccecjdfdjjppcpchdlm" # i don't care about cookies
      "jpbjcnkcffbooppibceonlgknpkniiff" # global speed
      "bnclejfcblondkjliiblkojdeloomadd" # mute tab
      "cankofcoohmbhfpcemhmaaeennfbnmgp" # netflix 1080p
    ];
    commandLineArgs = [ "--ozone-platform-hint=auto" ];
  };
}
