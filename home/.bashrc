export EDITOR="emacs"
export PATH="$PATH:/home/emil/go/bin"
export WINE=wine64

alias 7z=7zz

function edit-nixcfg() {
	sudo emacs /etc/nixos/configuration.nix "$@"
}

function fhsenv() {
	nix-shell --expr "with import <nixpkgs> {}; (buildFHSUserEnv { name = \"fhs-env\"; targetPkgs = pkgs: [ zlib xorg.libXxf86vm libglvnd openssl xorg.libX11 xorg.libXext xorg.libXrandr libGLU openal $@];	}).env"	
}
