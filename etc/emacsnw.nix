{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation rec {
  name = "emacsnw";
  phases = [ "installPhase" ];
  installPhase = ''
		mkdir -p $out/bin
		echo \
			'#!/usr/bin/env bash
			emacs -nw "$@"
			' > $out/bin/emacsnw
		chmod +x $out/bin/emacsnw
  '';
}
