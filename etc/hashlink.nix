{ pkgs ? import <nixpkgs> {}}:

pkgs.stdenv.mkDerivation {
  pname = "hashlink";
  version = "1.11";
  src = pkgs.fetchFromGitHub {
    owner = "HaxeFoundation";
    repo = "hashlink";
    rev = "cd269136628a1d445b2253ded9fd10ab9fe2f9be";
    sha256 = "330d0030f2b87dd68076af818e7143a68d01f6a853ade703f2ba0b03f245fdad";
  };
  buildInputs = with pkgs; [ libpng libjpeg libvorbis openal SDL2 mbedtls libuv libGLU ];
  installPhase = '' make PREFIX=$out install '';
}
