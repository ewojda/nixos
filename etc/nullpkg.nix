{ pkgs ? import <nixpkgs> {} }

pkgs.stdenv.mkDerivation {
  name = "nullpkg";
  phases = [ "makeOutput" ];
  makeOutput = " mkdir -p $out ";
}
