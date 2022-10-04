# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Switch to nixos unstable:
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos

let
  current-de = import ./de.nix;
  use-lightdm = (current-de == "fluxbox" || current-de == "icewm" || current-de == "pantheon" || current-de == "xfce");
in
assert (builtins.elem current-de [ "gnome" "xfce" "startx" "fluxbox" "icewm" "pantheon" ]);
{ config, pkgs, ... }:
let
  emacsCustom = pkgs.emacs.override { 
    #withXwidgets = true;
    withWebP = true;
    withXinput2 = true;
  };
in
rec {
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only
  boot.supportedFilesystems = [ "ntfs" ];
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [ "mitigations=off" ];
  # boot.kernelParams = [
  #   "zswap.enabled=1"
  #   "zswap.compressor=zstd"
  #   "zswap.max_pool_percent=100"
  #   "zswap.zpool=z3fold"
  # ];
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 90;
  };
  # boot.initrd.availableKernelModules = [
  #   "zstd"
  #   "z3fold"
  # ];
  # boot.kernelModules = [
  #   "zstd"
  #   "z3fold"
  # ];
  # boot.initrd.kernelModules = [
  #   "zstd"
  #   "z3fold"
  # ];

  networking.hostName = "enix"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  #networking.interfaces.enp2s0.useDHCP = true;
  # networking.interfaces.wlp0s19f2u6.useDHCP = true;
  #networking.interfaces.wlp0s18f2u1.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  environment.etc."nixos/configuration_backup.nix" = {
    enable = true;
    source = /etc/nixos/configuration.nix;
    mode = "0444";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Display manager
  #  LightDM
  services.xserver.displayManager.lightdm.enable = use-lightdm;
  #  GDM
  services.xserver.displayManager.gdm.enable = (current-de != "startx" && !use-lightdm);
  services.xserver.displayManager.gdm.wayland = true;
  # services.xserver.displayManager.gdm.nvidiaWayland = false;
  #  startx
  services.xserver.displayManager.startx.enable = (current-de == "startx");

  # Desktop Environment.
  #  Gnome
  services.xserver.desktopManager.gnome.enable = (current-de == "gnome");
  environment.gnome.excludePackages = with pkgs; let g = gnome; in [
    g.epiphany
    g.cheese
    g.yelp
    g.gnome-contacts
    g.gnome-music
    g.gedit
    gnome-connections
    gnome-tour
  ];

  #  XFCE
  services.xserver.desktopManager.xfce.enable = (current-de == "xfce");
  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  #  Fluxbox
  services.xserver.windowManager.fluxbox.enable = (current-de == "fluxbox");

  #  IceWM
  services.xserver.windowManager.icewm.enable = (current-de == "icewm");

  #  Pantheon
  services.xserver.desktopManager.pantheon.enable = (current-de == "pantheon");
  environment.pantheon.excludePackages = with pkgs.pantheon; [
    elementary-camera
    elementary-code
    elementary-tasks
    epiphany
  ];
  programs.pantheon-tweaks.enable = (current-de == "pantheon");

  # Configure keymap in X11
  services.xserver.layout = "pl";
  # services.xserver.xkbOptions = "eurosign:e";

  # Remap mouse side buttons to scroll and disable acceleration
  services.xserver.libinput.mouse = {
    accelProfile = "flat";
    accelSpeed = "-1";
    buttonMapping = "1 2 3 4 5 6 7 5 4 10 11 12";
    additionalOptions = "Option \"AccelerationScheme\" \"none\"\n";
  };

  # services.xserver.config = ''
  #   Section "InputClass"
  #       Identifier "evdev pointer catchall"
  #       MatchIsPointer "on"
  #       MatchDevicePath "/dev/input/event*"
  #       Driver "evdev"
  #       Option "ButtonMapping" "1 2 3 4 5 6 7 5 4 10 11 12"
  #       Option "AccelProfile" "flat"
  #       Option "AccelerationProfile" "-1"
  #       Option "AccelerationScheme" "none"
  #       Option "AccelSpeed" "-1"
  #   EndSection
  # '';

  # Enable CUPS to print documents.
  services.printing.enable = true;
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Users
  users.users.emil = {
    description = "Emil";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "sound" "scanner" "lp"  ];
  };

  # Packages
  programs.steam.enable = true;

  # Fixes touchpad scrolling in firefox
  environment.variables = {
    MOZ_USE_XINPUT2 = "1";
  };

  environment.systemPackages = with pkgs; let
    httpdirfs = import ./httpdirfs.nix { inherit pkgs; };
    wine64launcher = import ./wine64launcher.nix { inherit pkgs; };
    emacsWithGTK2 = emacs.override { withGTK2 = true; withGTK3 = false; };
    hashlink = import ./hashlink.nix { inherit pkgs; };
    airshipperFixedIcon = import ./airshipper.nix { inherit pkgs; };
    ffmpegWithFFplay = import ./ffmpeg-with-ffplay.nix { inherit pkgs; };
    lbry-desktop-custom = import ./lbry-desktop-custom.nix { inherit lib fetchurl appimageTools; };
    emacsnw = import ./emacsnw.nix { inherit pkgs; };
  in [
    wine64launcher
    #httpdirfs
    #emacsWithGTK2
    #airshipperFixedIcon
    #ffmpegWithFFplay
  	lbry-desktop-custom
    hashlink
    emacsnw

    _7zz
    #btfs
    #cdrkit
    amberol
    curlFull
    #dino
    dbeaver
    desktop-file-utils
    #emacs
    emacsCustom
    evolution
    ffmpeg
    #ffmpegWithFFplay
    firefox
    firejail
    freecad
    #fuse-7z-ng
    gcc
    ghostscript
    gitFull
    graphviz
    gimp
    gnuplot
    gnome.dconf-editor
    gnome.dconf-editor
    gnome.gnome-disk-utility
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    go_1_17
    gopls
    godot
    haxe
    hugo
    imagemagick
    inkscape
    #julia-bin
    #jami-client-qt
    #jami-daemon
    #latest.firefox-nightly-bin
    libreoffice
    luajit_2_1
    lutris
    #mpv
    nix-index
    nomacs
    nwjs
    nodejs
    openjdk11
    openssl
    p7zip
    patchelf
    pdftk
    plowshare
    php81
    pkg-config
    (python3.withPackages (p: with p; [ pip ]))
    qbittorrent
    rclone
    R
    #session-desktop-appimage
    steam-run
    sumneko-lua-language-server
    tageditor
    #tor-browser-bundle-bin
    texmacs
    tetex
    #ungoogled-chromium
    unzip
    unrar
    veracrypt
    virt-manager
    vlc
    wget
    wine
    wine64
    winetricks
    xorg.xmodmap
    xorg.xhost
    xdotool
    xclip
    yt-dlp
    zlib
    i2pd
		emem
		gallery-dl

		jre8
		openjfx11
		streamlink
		clementine

		mimic
    gnome-podcasts
    #minetest
    #polymc
    #airshipperFixedIcon
    #(import ./xenia.nix { inherit pkgs; })

    #netsurf-browser
  ] ++ (if current-de != "gnome" && current-de != "pantheon" then [
    gnome.file-roller
  ] else []) ++ (if current-de == "pantheon" then [
    gnome.gnome-characters
    gnome.gnome-maps
    gnome.gnome-weather
  ] else []);

	programs.firejail.enable = true;
	security.apparmor.enable = true;
  services.tor.enable = true;
  services.tor.client.enable = true;

	services.i2pd = {
		enable = true;
		proto.http.enable = true;
		proto.httpProxy.enable = true;
	};

  # services.emacs = {
  #   enable = true;
  #   package = emacsCustom;
  # };

  nixpkgs.config.allowUnfree = true;

  # Firefox nightly
  nixpkgs.overlays =
    let
      # Change this to a rev sha to pin
      moz-rev = "master";
      moz-url = builtins.fetchTarball { url = "https://github.com/mozilla/nixpkgs-mozilla/archive/${moz-rev}.tar.gz";};
      nightlyOverlay = (import "${moz-url}/firefox-overlay.nix");
    in [
      nightlyOverlay
    ];

  # Nix flakes
   nix = {
     package = pkgs.nixFlakes;
     extraOptions = ''
       experimental-features = nix-command flakes
     '';
   };

  # VMs
  # - Virtual Box
  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "emil" ];

  # - KVM
  virtualisation.libvirtd.enable = true;
  programs.dconf.enable = true;
  users.extraGroups.libvirtd.members = [ "emil" ];

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    8080
  ];
  networking.firewall.allowedUDPPorts = [ ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
}
