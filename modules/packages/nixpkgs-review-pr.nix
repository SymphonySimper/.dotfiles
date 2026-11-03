{
  nixpkgs-review,
  writeShellApplication,
}:

writeShellApplication {
  name = "nixpkgs-review-pr";
  runtimeInputs = [ nixpkgs-review ];
  text = ''
    if [[ $# -ne 1 ]]; then
      echo "Requires PR ID (ex: 481226)." >&2
      exit 1
    fi

    nixpkgs-review pr --post-result "$1"
  '';
}
