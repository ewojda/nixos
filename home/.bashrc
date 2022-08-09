export EDITOR="emacs -nw"
export PATH="$PATH:/home/emil/go/bin"
export NIXPKGS_ALLOW_UNFREE=1
export WEBKIT_FORCE_SANDBOX=0

alias 7z=7zz

function edit-nixcfg() {
	sudo emacs /etc/nixos/configuration.nix "$@"
}

function init-rebuild-with() {
	set -o xtrace
    mkdir ~/temp1738715890715
	cd ~/temp1738715890715
	curl -L -o nixpkgs-myrev.tar.gz 'https://github.com/NixOS/nixpkgs/archive/efeefb2af1469a5d1f0ae7ca8f0dfd9bb87d5cfb.tar.gz'
	7z x nixpkgs-myrev.tar.gz
	7z x nixpkgs-myrev.tar
	rm -rf nixpkgs-myrev.tar nixpkgs-myrev.tar.gz
	mkdir ~/nixpkgs-myrev
	mv -T nixpkgs-* ~/nixpkgs-myrev
	rm -rf ~/temp1738715890715/
	set +o xtrace
}

function rebuild-with() {
	echo "\"$1\"" | sudo dd of=/etc/nixos/de.nix
	NP_PIN="-I nixpkgs=/home/emil/nixpkgs-myrev/"
	NP_PIN=""
	sudo nixos-rebuild boot $NP_PIN -p $@
}

function rebuild-with-switch() {
	echo "\"$1\"" | sudo dd of=/etc/nixos/de.nix
	NP_PIN="-I nixpkgs=/home/emil/nixpkgs-myrev/"
	NP_PIN=""
	sudo nixos-rebuild switch $NP_PIN -p $@
}

function fhsenv-small() {
    nix-shell --expr "with import <nixpkgs> {};
	(buildFHSUserEnv {
		name = \"fhs-env\";
		targetPkgs = pkgs: [
			$@
		];
	}).env"
}

function fhsenv() {
	NIXPKGS_ALLOW_UNFREE=1 nix-shell --expr "with import <nixpkgs> {};
	(buildFHSUserEnv {
		name = \"fhs-env\";
		targetPkgs = pkgs: [
			xorg.appres xorg.bdftopcf xorg.bitmap xorg.editres xorg.encodings xorg.gccmakedep xorg.iceauth xorg.ico xorg.imake xorg.libFS xorg.libICE xorg.libSM xorg.libX11 xorg.libXScrnSaver xorg.libXTrap xorg.libXau xorg.libXaw xorg.libXaw3d xorg.libXcomposite xorg.libXcursor xorg.libXdamage xorg.libXdmcp xorg.libXext xorg.libXfixes xorg.libXfont xorg.libXfont2 xorg.libXft xorg.libXi xorg.libXinerama xorg.libXmu xorg.libXp xorg.libXpm xorg.libXpresent xorg.libXrandr xorg.libXrender xorg.libXres xorg.libXt xorg.libXtst xorg.libXv xorg.libXvMC xorg.libXxf86dga xorg.libXxf86misc xorg.libXxf86vm xorg.libdmx xorg.libfontenc xorg.libpciaccess xorg.libpthreadstubs xorg.libxcb xorg.libxkbfile xorg.libxshmfence xorg.listres xorg.lndir xorg.luit xorg.makedepend xorg.mkfontdir xorg.mkfontscale xorg.oclock xorg.pixman xorg.sessreg xorg.setxkbmap xorg.smproxy xorg.transset xorg.twm xorg.utilmacros xorg.viewres xorg.x11perf xorg.xauth xorg.xbacklight xorg.xbitmaps xorg.xcalc xorg.xcbproto xorg.xcbutil xorg.xcbutilcursor xorg.xcbutilerrors xorg.xcbutilimage xorg.xcbutilkeysyms xorg.xcbutilrenderutil xorg.xcbutilwm xorg.xclock xorg.xcmsdb xorg.xcompmgr xorg.xconsole xorg.xcursorgen xorg.xcursorthemes xorg.xdm xorg.xdpyinfo xorg.xdriinfo xorg.xev xorg.xeyes xorg.xf86inputevdev xorg.xf86inputjoystick xorg.xf86inputkeyboard xorg.xf86inputlibinput xorg.xf86inputmouse xorg.xf86inputsynaptics xorg.xf86inputvmmouse xorg.xf86inputvoid xorg.xfd xorg.xfontsel xorg.xfs xorg.xfsinfo xorg.xgamma xorg.xgc xorg.xhost xorg.xinit xorg.xinput xorg.xkbcomp xorg.xkbevd xorg.xkbprint xorg.xkbutils xorg.xkeyboardconfig xorg.xkill xorg.xlibsWrapper xorg.xload xorg.xlsatoms xorg.xlsclients xorg.xlsfonts xorg.xmag xorg.xmessage xorg.xmodmap xorg.xmore xorg.xorgcffiles xorg.xorgdocs xorg.xorgproto xorg.xorgserver xorg.xorgsgmldoctools xorg.xpr xorg.xprop xorg.xrandr xorg.xrdb xorg.xrefresh xorg.xset xorg.xsetroot xorg.xsm xorg.xstdcmap xorg.xtrans xorg.xtrap xorg.xvinfo xorg.xwd xorg.xwininfo xorg.xwud xorg-rgb xorg_sys_opengl
			zlib libglvnd openssl libGLU libGL libglvnd.out xorg_sys_opengl openal udev alsa-lib libpulseaudio $@
 			glib nss nspr gnome2.GConf fontconfig freetype pango cairo dbus gnome2.gtk gdk-pixbuf libnotify
			at-spi2-core mesa libxkbcommon cups atk
		];
	}).env"
}


function autopatch() {
	echo "\
	{ pkgs ? import <nixpkgs> {} }:\
	pkgs.stdenv.mkDerivation {\
		name = \"autoPatchedBinary\";\
		src = ./.;\
		nativeBuildInputs = [\
			pkgs.autoPatchelfHook\
		];\
		buildInputs = [\
			pkgs.patchelf\
		];\
		buildPhase = '' $2 '';\
		installPhase = '' mkdir \$out && cp \"$1\" \$out '';\
	}" > temp.nix &&
	nix-build temp.nix &&
	rm temp.nix
}

function musics() {
	cd /home/emil/Documents/Go/musics-main/
	/home/emil/Documents/Go/musics-main/main\
	 -dir /home/emil/Music\
	 -db /home/emil/Documents/Go/musics-main/audio.sqlite
	 $@
}
#	 -dir /run/media/emil/D26279076278F219/Users/Emil/Music\

function nix-shell-stable() {
	nix-shell -v --expr "
	let
		pkgs = import (\"\" + builtins.fetchTarball(\"https://github.com/NixOS/nixpkgs/archive/nixos-21.11.tar.gz\")) {};
	in
	(pkgs.mkShell {
	  buildInputs = with pkgs; [ $@ ];
	})"
}

function offline() {
	sudo unshare -n sudo -u emil $@
}

# https://unix.stackexchange.com/questions/96358/command-to-run-a-child-process-offline-no-external-network-on-linux
function offline2() {
   	bwrap --bind / / --dev /dev --unshare-net -- $@
}

function eman() {
	emacs --eval "(progn (man \"$1\") (delete-window))"
function eterm() {
    emacs -nw --eval '(term "/run/current-system/sw/bin/bash")'
}

export W32P=/home/emil/.local/share/wineprefixes/32/

function wine32() {
	WINEPREFIX=$W32P wine $@
}
function jap() {
	LANG="ja_JP.UTF8" $@
}
function type-clipboard-after() {
	sleep $1
	xclip -selection clipboard -out | tr \\n \\r | xdotool type --clearmodifiers --delay 25 --file -
}

function force-mount-ntfs () {
	sudo mount -t ntfs-3g -o remove_hiberfile $@
}

function nix-quick-search () {
	WD="$(pwd)"
	cd /nix/var/nix/profiles/per-user/root/channels/nixos
	nix search . $@
	cd "$WD"
}

function find-nixpkgs () {
	find /nix/var/nix/profiles/per-user/root/channels/nixos/ $@
}
