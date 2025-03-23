{ my, pkgs, ... }:
let
  theme = {
    frappe = "olhelnoplefjdmncknfphenjclimckaf";
    latte = "jhjnalhegpceacdhbplhnakmkdliaddd";
    macchiato = "cmpdlhmnmjhihmcfnigoememnffkimlk";
    mocha = "bkkmolkhemgaeaeggcmfbghljjjoofoh";
  };
in
{
  programs.chromium = {
    enable = true;
    package = pkgs.google-chrome;

    commandLineArgs = [
      # "--ozone-platform-hint=auto"
      "--disable-features=WebRtcAllowInputVolumeAdjustment"
    ];

    extensions = [
      theme.${my.theme.flavor} # Catppuccin theme
      "ddkjiahejlhfcafbddmgiahcphecmpfh" # ublock origin lite
      "nngceckbapebfimnlniiiahkandclblb" # bitwarden
      "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
    ];
  };
}
