{ pkgs ? import <nixpkgs> {}}:
pkgs.stdenv.mkDerivation {
  pname = "httpdirfs";
  version = "1.2.3";
  src = pkgs.fetchFromGitHub {
    owner = "fangfufu";
    repo = "httpdirfs";
    rev = "40c750fac90f508799005f6e15d3f06a95acfd43";
    sha256 = "1b5ka6lh5622in7h6adswnax2z2rz0c1lbfm1gh4icc6x0ihb0ap";
  };
  installPhase = '' DESTDIR=$out prefix=/ make install '';
  buildInputs = with pkgs; [ libgumbo fuse openssl libuuid curl pkg-config expat ];
}
