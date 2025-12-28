{
  pkgs ? import <nixpkgs> {}
, name ? "http-server-debug-requests-headers"
}:
let
in
pkgs.stdenv.mkDerivation {
  inherit name;

  nativeBuildInputs = with pkgs; [
  ];

  src = ./.;
  
  phases = "installPhase";

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin
  '';


}