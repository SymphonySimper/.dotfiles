{ pkgs, ... }:
{
  home.packages = [
    (pkgs.writeShellScriptBin "my-network" ''
      case "$1" in
        get) nmcli -p -g type connection show --active | head -n1 | cut -d '-' -f3 ;;
        reload) sudo systemctl restart NetworkManager ;;
      esac
    '')
  ];
}
