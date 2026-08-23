{ lib, ... }: {
  time.timeZone = lib.mkDefault "Asia/Kolkata";
  services.timesyncd.enable = lib.mkDefault true;
}
