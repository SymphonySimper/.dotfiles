{ lib, ... }: {
  # refer: https://sourceware.org/git/?p=glibc.git;a=blob;f=localedata/SUPPORTED
  i18n.defaultLocale = "en_US.UTF-8";

  time.timeZone = lib.mkDefault "Asia/Kolkata";
  services.timesyncd.enable = lib.mkDefault true;
}
