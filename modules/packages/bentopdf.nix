{
  lib,
  bentopdf,
  lighttpd,
  writeShellScriptBin,
  writeText,
}:

let
  port = "3456";

  config = writeText "bentopdf.lighttpd.conf" ''
    server.document-root = "${bentopdf}"
    server.port = ${port}

    server.modules = (
      "mod_indexfile",
      "mod_staticfile"
    )

    index-file.names = ( "index.html" )
  '';
in
writeShellScriptBin "bentopdf" ''
  echo "Starting server at http://localhost:${port}"
  exec ${lib.getExe lighttpd} -D -f "${config}"
''
