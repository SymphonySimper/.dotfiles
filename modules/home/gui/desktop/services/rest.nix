{ pkgs, lib, ... }:
{
  config = lib.my.mkSystemdTimer rec {
    name = "my-rest";
    time = "15m";
    desc = "Rest timer";
    ExecStart = lib.getExe (
      pkgs.writeShellScriptBin "my-rest" ''
        tmp_file='/tmp/${name}'

        function notify() {
         ${lib.my.mkNotification {
           tag = "my-rest-status";
           title = "$1";
           body = "$2";
           urgency = "critical";
         }}
        }

        if [ ! -f "$tmp_file" ]; then
          echo 0 > "$tmp_file"
        else
          curr_count=$(<$tmp_file)
          new_count=$((curr_count + 1))
          title="Short rest"
          body="15 minutes!"

          if [[ $new_count -eq 5 ]]; then
            new_count=1
            title="Long rest"
            body="60 minutes!"
          fi
          echo $new_count > "$tmp_file"

          notify "$title" "$body"
        fi
      ''
    );
  };
}
