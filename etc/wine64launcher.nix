{ pkgs ? import <nixpkgs> {} }:
pkgs.stdenv.mkDerivation {
  name = "wine64-launcher-v1";
  phases = [ "installPhase" ];
  installPhase = ''
    mkdir -p $out/share/applications/
    
    echo "[Desktop Entry]
Type=Application
Name=Wine 64 Windows Program Loader
Name[ar]=منظومة واين لتشغيل برامج وندوز
Name[cs]=Zavaděč programů pro Wine
Name[de]=Wine Windows-Programmstarter
Name[es]=Wine Cargador de programas de Windows
Name[lt]=Wine Windows programų paleidyklė
Name[nl]=Wine Windows programmalader
Name[sv]=Wine Windows Programstartare
Name[ro]=Wine - Încărcătorul de programe Windows
Name[ru]=Wine - загрузчик Windows программ
Name[uk]=Wine - завантажувач Windows програм
Name[fr]=Wine - Chargeur de programmes Windows
Name[ca]=Wine - Carregador d'aplicacions del Windows
Name[pt]=Carregador de aplicativos Windows Wine
Name[pt_br]=Carregador de aplicativos Windows Wine
Name[it]=Wine Carica Programmi Windows
Name[da]=Wine, Programstarter til Windows-programmer
Name[nb]=Wine - for kjøring av Windows-programmer
Name[nn]=Wine - for køyring av Windows-program
Name[sr]=Wine - дизач Windows програма
Name[sr@latin]=Wine - dizač Windows programa
Name[tr]=Wine - Windows programı yükleyicisi
Name[hr]=Wine - dizač Windows programa
Name[he]=Wine — מריץ תכניות Windows
Name[ja]=Wine Windowsプログラムローダー
Exec=wine64 %f
MimeType=application/x-ms-dos-executable;application/x-msi;application/x-ms-shortcut;
Icon=wine
NoDisplay=true
StartupNotify=true
" > $out/share/applications/wine64.desktop
  '';
}
