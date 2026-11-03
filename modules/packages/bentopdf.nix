{
  lib,
  bentopdf,
  darkhttpd,
  writeShellScriptBin,
  writeText,
}:

let
  port = "3456";

  # darkhttpd serves .mjs as octet-stream, which breaks pdf.js module scripts
  mimetypes = writeText "bentopdf.mime.types" ''
    text/javascript mjs
  '';
in
writeShellScriptBin "bentopdf" ''
  echo "Starting server at http://localhost:${port}"
  # COOP/COEP are needed for SharedArrayBuffer (LibreOffice-based Office -> PDF conversions)
  exec ${lib.getExe darkhttpd} ${bentopdf} \
    --addr 127.0.0.1 \
    --port ${port} \
    --mimetypes ${mimetypes} \
    --header 'Cross-Origin-Opener-Policy: same-origin' \
    --header 'Cross-Origin-Embedder-Policy: require-corp'
''
