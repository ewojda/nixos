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

  networking.hostName = "emil-nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Warsaw";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.wlp0s19f2u6.useDHCP = true;

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];

  # Display manager
  #  LightDM
  services.xserver.displayManager.lightdm.enable = use-lightdm;
  #  GDM
  services.xserver.displayManager.gdm.enable = (current-de != "startx" && !use-lightdm);
  services.xserver.displayManager.gdm.wayland = false;
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
  services.xserver.config = ''
    Section "InputClass"
        Identifier "evdev pointer catchall"
        MatchIsPointer "on"
        MatchDevicePath "/dev/input/event*"
        Driver "evdev"
        Option "ButtonMapping" "1 2 3 4 5 6 7 5 4 10 11 12"
      	Option "AccelProfile" "flat"
    		Option "AccelerationProfile" "-1"
        Option "AccelerationScheme" "none"
      	Option "AccelSpeed" "-1"
    EndSection
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Users
  users.users.emil = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # Packages
  programs.steam.enable = true;

  environment.systemPackages = with pkgs; let
    httpdirfs = import ./httpdirfs.nix { inherit pkgs; };
    wine64launcher = import ./wine64launcher.nix { inherit pkgs; };
    emacsWithGTK2 = emacs.override { withGTK2 = true; withGTK3 = false; };
    hashlink = import ./hashlink.nix { inherit pkgs; };
    airshipperFixedIcon = import ./airshipper.nix { inherit pkgs; };
    ffmpegWithFFplay = import ./ffmpeg-with-ffplay.nix { inherit pkgs; };
  in [
    _7zz
#    archivemount
    btfs
    cdrkit
    curlFull
    dino
    emacs
    ffmpegWithFFplay
    firefox
    fuse-7z-ng
    gcc
    git
    gnome.dconf-editor
    gnome.dconf-editor
    gnome.gnome-disk-utility
    gnome.gnome-system-monitor
    gnome.gnome-tweaks
    go_1_17
    gopls
    hashlink
    haxe
    httpdirfs
    hugo
    imagemagick
    #(import ./tageditor-no-gui.nix { inherit pkgs; })
    inkscape
    jami-client-qt
    jami-daemon
    #latest.firefox-nightly-bin
    libreoffice
    luajit_2_1
    mpv
    nix-index
    nomacs
    openjdk11
    openssl
    p7zip
    patchelf
    pdftk
    pkg-config
    qbittorrent
    rclone
    session-desktop-appimage
    sumneko-lua-language-server
    tageditor
#    ungoogled-chromium
    unzip
    veracrypt
    virt-manager
    vlc
    wget
    wine
    wine64
    wine64launcher
    winetricks
    xorg.xmodmap
    yt-dlp
    zlib

#    minetest
    polymc
#    airshipperFixedIcon
#    (import ./xenia.nix { inherit pkgs; })

    netsurf-browser
  ] ++ (if current-de != "gnome" && current-de != "pantheon" then [
    gnome.file-roller
  ] else []) ++ (if current-de == "pantheon" then [
    gnome.gnome-characters
    gnome.gnome-maps
    gnome.gnome-weather
  ] else []);

  systemd.services.musics = {
    enable = true;
    description = "Music server";
    serviceConfig = {
      Type = "simple";
      ExecStart =
        "/home/emil/Documents/Go/musics-main/main" +
        " -dir /home/emil/Music" +
        " -db /home/emil/Documents/Go/musics-main/audio.sqlite" +
        " -templates '/home/emil/Documents/Go/musics-main/templates/*'";
    };
    wantedBy = [ "network.target" ];
  };

  # services.tor.enable = true;
  # services.tor.client.enable = true;

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

