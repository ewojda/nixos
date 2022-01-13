{ pkgs ? import <nixpkgs>{} }:

pkgs.airshipper.overrideAttrs (old: {
  pname = "arshipper-fixedicon";

  nativeBuildInputs = old.nativeBuildInputs ++ [
    pkgs.imagemagick
  ];

  postInstall = ''
    mkdir -p "$out/share/applications" && mkdir -p "$out/share/icons"
    cp "client/assets/net.veloren.airshipper.desktop" "$out/share/applications"
    magick convert "client/assets/logo.ico" "client/assets/logo.png"

    mkdir -p "$out/share/icons/hicolor/16x16/apps/"
    cp "client/assets/logo-0.png" "$out/share/icons/hicolor/16x16/apps/net.veloren.airshipper.png"
    mkdir -p "$out/share/icons/hicolor/32x32/apps/"
    cp "client/assets/logo-1.png" "$out/share/icons/hicolor/32x32/apps/net.veloren.airshipper.png"
    mkdir -p "$out/share/icons/hicolor/48x48/apps/"
    cp "client/assets/logo-2.png" "$out/share/icons/hicolor/48x48/apps/net.veloren.airshipper.png"
    mkdir -p "$out/share/icons/hicolor/64x64/apps/"
    cp "client/assets/logo-3.png" "$out/share/icons/hicolor/64x64/apps/net.veloren.airshipper.png"
    mkdir -p "$out/share/icons/hicolor/256x256/apps/"
    cp "client/assets/logo-4.png" "$out/share/icons/hicolor/256x256/apps/net.veloren.airshipper.png"
  '';
})
