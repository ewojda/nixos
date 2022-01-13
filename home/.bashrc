export EDITOR="emacs"
export PATH="$PATH:/home/emil/go/bin"

alias 7z=7zz

function edit-nixcfg() {
	sudo emacs /etc/nixos/configuration.nix "$@"
}

function rebuild-with() {
	echo "\"$1\"" | sudo dd of=/etc/nixos/de.nix
	sudo nixos-rebuild switch -p $1
}

function fhsenv() {
	NIXPKGS_ALLOW_UNFREE=1 nix-shell --expr "with import <nixpkgs> {};\
	(buildFHSUserEnv {\
		name = \"fhs-env\";\
		targetPkgs = pkgs: [\
			xorg.appres xorg.bdftopcf xorg.bitmap xorg.editres xorg.encodings xorg.fontadobe100dpi xorg.fontadobe75dpi xorg.fontadobeutopia100dpi xorg.fontadobeutopia75dpi xorg.fontadobeutopiatype1 xorg.fontalias xorg.fontarabicmisc xorg.fontbh100dpi xorg.fontbh75dpi xorg.fontbhlucidatypewriter100dpi xorg.fontbhlucidatypewriter75dpi xorg.fontbhttf xorg.fontbhtype1 xorg.fontbitstream100dpi xorg.fontbitstream75dpi xorg.fontbitstreamtype1 xorg.fontcronyxcyrillic xorg.fontcursormisc xorg.fontdaewoomisc xorg.fontdecmisc xorg.fontibmtype1 xorg.fontisasmisc xorg.fontjismisc xorg.fontmicromisc xorg.fontmisccyrillic xorg.fontmiscethiopic xorg.fontmiscmeltho xorg.fontmiscmisc xorg.fontmuttmisc xorg.fontschumachermisc xorg.fontscreencyrillic xorg.fontsonymisc xorg.fontsunmisc xorg.fonttosfnt xorg.fontutil xorg.fontwinitzkicyrillic xorg.fontxfree86type1 xorg.gccmakedep xorg.iceauth xorg.ico xorg.imake xorg.libFS xorg.libICE xorg.libSM xorg.libX11 xorg.libXScrnSaver xorg.libXTrap xorg.libXau xorg.libXaw xorg.libXaw3d xorg.libXcomposite xorg.libXcursor xorg.libXdamage xorg.libXdmcp xorg.libXext xorg.libXfixes xorg.libXfont xorg.libXfont2 xorg.libXft xorg.libXi xorg.libXinerama xorg.libXmu xorg.libXp xorg.libXpm xorg.libXpresent xorg.libXrandr xorg.libXrender xorg.libXres xorg.libXt xorg.libXtst xorg.libXv xorg.libXvMC xorg.libXxf86dga xorg.libXxf86misc xorg.libXxf86vm xorg.libdmx xorg.libfontenc xorg.libpciaccess xorg.libpthreadstubs xorg.libxcb xorg.libxkbfile xorg.libxshmfence xorg.listres xorg.lndir xorg.luit xorg.makedepend xorg.mkfontdir xorg.mkfontscale xorg.oclock xorg.pixman xorg.sessreg xorg.setxkbmap xorg.smproxy xorg.transset xorg.twm xorg.utilmacros xorg.viewres xorg.x11perf xorg.xauth xorg.xbacklight xorg.xbitmaps xorg.xcalc xorg.xcbproto xorg.xcbutil xorg.xcbutilcursor xorg.xcbutilerrors xorg.xcbutilimage xorg.xcbutilkeysyms xorg.xcbutilrenderutil xorg.xcbutilwm xorg.xclock xorg.xcmsdb xorg.xcompmgr xorg.xconsole xorg.xcursorgen xorg.xcursorthemes xorg.xdm xorg.xdpyinfo xorg.xdriinfo xorg.xev xorg.xeyes xorg.xf86inputevdev xorg.xf86inputjoystick xorg.xf86inputkeyboard xorg.xf86inputlibinput xorg.xf86inputmouse xorg.xf86inputsynaptics xorg.xf86inputvmmouse xorg.xf86inputvoid xorg.xfd xorg.xfontsel xorg.xfs xorg.xfsinfo xorg.xgamma xorg.xgc xorg.xhost xorg.xinit xorg.xinput xorg.xkbcomp xorg.xkbevd xorg.xkbprint xorg.xkbutils xorg.xkeyboardconfig xorg.xkill xorg.xlibsWrapper xorg.xload xorg.xlsatoms xorg.xlsclients xorg.xlsfonts xorg.xmag xorg.xmessage xorg.xmodmap xorg.xmore xorg.xorgcffiles xorg.xorgdocs xorg.xorgproto xorg.xorgserver xorg.xorgsgmldoctools xorg.xpr xorg.xprop xorg.xrandr xorg.xrdb xorg.xrefresh xorg.xset xorg.xsetroot xorg.xsm xorg.xstdcmap xorg.xtrans xorg.xtrap xorg.xvinfo xorg.xwd xorg.xwininfo xorg.xwud xorg-rgb xorg_sys_opengl\
			zlib libglvnd openssl libGLU libGL libglvnd xorg_sys_opengl openal libudev alsa-lib libpulseaudio $@\
		];\
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
