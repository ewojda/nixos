# Edit this configuration file to define what should be installed on
# your system.	Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

# Switch to nixos unstable:
# nix-channel --add https://nixos.org/channels/nixos-unstable nixos

# git config --global user.email "ewojda22@wp.pl"
# git config --global user.name "Emil Wojda"

{ config, pkgs, ... }:

{
	imports =
		[ # Include the results of the hardware scan.
			./hardware-configuration.nix
		];

	# Bootloader.
	boot.loader.grub.enable = true;
	boot.loader.grub.device = "/dev/sdb";
	boot.loader.grub.useOSProber = true;

	boot.supportedFilesystems = [ "ntfs" ];
	boot.kernelParams = [
		"mitigations=off"
		"vm.max_map_count=2147483642" # https://fedoraproject.org/wiki/Changes/IncreaseVmMaxMapCount
	];
	zramSwap = {
		enable = true;
		algorithm = "zstd";
		memoryPercent = 90;
	};

	# Windows Drive
	fileSystems."/mnt/ntfs" = {
		device = "/dev/disk/by-partuuid/bd7395a2-02";
		fsType = "ntfs";
		options = [ "remove_hiberfile" "nofail" ];
		mountPoint = "/mnt/ntfs";
	};

	# Setup keyfile
	boot.initrd.secrets = {
		"/crypto_keyfile.bin" = null;
	};

	# Enable grub cryptodisk
	boot.loader.grub.enableCryptodisk=true;

	boot.initrd.luks.devices."luks-ddd1257e-540b-4f04-9496-75f8688cff39".keyFile = "/crypto_keyfile.bin";
	# Enable swap on luks
	boot.initrd.luks.devices."luks-9247ad93-f5b4-448a-ac70-ebfe3ae12f25".device = "/dev/disk/by-uuid/9247ad93-f5b4-448a-ac70-ebfe3ae12f25";
	boot.initrd.luks.devices."luks-9247ad93-f5b4-448a-ac70-ebfe3ae12f25".keyFile = "/crypto_keyfile.bin";

	networking.hostName = "enix2"; # Define your hostname.
	# networking.wireless.enable = true;	# Enables wireless support via wpa_supplicant.

	# Configure network proxy if necessary
	# networking.proxy.default = "http://user:password@proxy:port/";
	# networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

	# Enable networking
	networking.networkmanager.enable = true;

	# Set your time zone.
	time.timeZone = "Europe/Warsaw";

	# Select internationalisation properties.
	i18n.defaultLocale = "en_US.UTF-8";

	i18n.extraLocaleSettings = {
		LC_ADDRESS = "pl_PL.UTF-8";
		LC_IDENTIFICATION = "pl_PL.UTF-8";
		LC_MEASUREMENT = "pl_PL.UTF-8";
		LC_MONETARY = "pl_PL.UTF-8";
		LC_NAME = "pl_PL.UTF-8";
		LC_NUMERIC = "pl_PL.UTF-8";
		LC_PAPER = "pl_PL.UTF-8";
		LC_TELEPHONE = "pl_PL.UTF-8";
		LC_TIME = "pl_PL.UTF-8";
	};

	environment.etc."nixos/configuration_backup.nix" = {
		enable = true;
		source = /etc/nixos/configuration.nix;
		mode = "0444";
	};

	# Enable the X11 windowing system.
	services.xserver.enable = true;
	services.xserver.videoDrivers = [ "nvidia" ];

	# Enable the GNOME Desktop Environment.
	services.xserver.displayManager.gdm.enable = true;
	services.xserver.desktopManager.gnome.enable = true;

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

	# Configure keymap in X11
	services.xserver = {
		layout = "pl";
		xkbVariant = "";
	};

	# Configure console keymap
	console.keyMap = "pl2";

	# Enable CUPS to print documents.
	services.printing.enable = true;

	# Enable sound with pipewire.
	sound.enable = true;
	hardware.pulseaudio.enable = false;
	security.rtkit.enable = true;
	services.pipewire = {
		enable = true;
		alsa.enable = true;
		alsa.support32Bit = true;
		pulse.enable = true;
		# If you want to use JACK applications, uncomment this
		#jack.enable = true;

		# use the example session manager (no others are packaged yet so this is enabled by default,
		# no need to redefine it in your config for now)
		#media-session.enable = true;
	};

	services.xserver.libinput.mouse = {
		accelProfile = "flat";
		#		 accelSpeed = "-1";
		accelSpeed = "5";
		buttonMapping = "1 2 3 4 5 6 7 5 4 10 11 12";
		additionalOptions = "Option \"AccelerationScheme\" \"none\"\n";
	};


	# Enable touchpad support (enabled default in most desktopManager).
	# services.xserver.libinput.enable = true;

	# Define a user account. Don't forget to set a password with ‘passwd’.
	users.users.emil = {
		isNormalUser = true;
		description = "Emil";
		extraGroups = [ "networkmanager" "wheel" ];
	};

	# Allow unfree packages
	nixpkgs.config.allowUnfree = true;

	# List packages installed in system profile. To search, run:
	# $ nix search wget
	environment.systemPackages = with pkgs; [
		_7zz
		appimage-run
		btfs
		clementine
		cmark
		curlFull
		desktop-file-utils
		dig
		emacs
		emem
		espeak
		evolution
		ffmpeg_5-full
		firefox
		firejail
		freecad
		# freenet
		# gajim
		gamemode
		gallery-dl
		gcc
		ghostscript
		gimp
		gitFull
		gnome.dconf-editor
		gnome.gnome-disk-utility
		gnome.gnome-system-monitor
		gnome.gnome-tweaks
		gnome-podcasts
		gnumake
		gnuplot
		go
		godot
		gopls
		graphviz
		groff
		hashlink
		haxe
		hugo
		i2pd
		imagemagick
		inkscape
		ipfs
		jre8
		libreoffice
		luajit_2_1
		lutris
		mimic
		mono
		nix-index
		nodejs
		nomacs
		nwjs
		openjdk11
		openjfx11
		openssl
		patchelf
		pdftk
		pkg-config
		protontricks
		(python39Full.withPackages (p: with p; [ pip ]))
		qbittorrent
		R
		rclone
		steam-run
		streamlink
		sumneko-lua-language-server
		tageditor
		tetex
		tor-browser-bundle-bin
		unrar
		unzip
		veracrypt
		virt-manager
		vlc
		wget
		winetricks
		wineWowPackages.stagingFull
		xclip
		xdotool
		xorg.xhost
		xorg.xmodmap
		yt-dlp
		zlib
	];

	programs.firejail.enable = true;
	security.apparmor.enable = true;

	# DNS
	networking.nameservers = [ "127.0.0.2" ];

	# Don't set DNS with DHCP
	networking.dhcpcd.extraConfig = "nohook resolv.conf";
	networking.networkmanager.dns = "none";

	# pdnsd
	services.pdnsd = {
		enable = true;
		globalConfig = ''
			perm_cache=10000;
			server_ip=127.0.0.2;
			min_ttl=48h;
		'';
		serverConfig = ''
			label="DNS over tor";
			ip=127.0.0.1;
			proxy_only=on;
			timeout=3;
		'';
	};

	# Tor
	services.tor = {
		enable = true;
		client.enable = true;
		# DNS over tor
		settings.DNSPort = 53;
	};

	# I2P
	services.i2p.enable = true;

	# Invidious
	services.invidious = {
		enable = true;
		# nginx.enable = true;
		# domain = "127.0.0.1";
		settings.host_binding = "127.0.0.1";
	};

	# Nix flakes
	 nix = {
		 package = pkgs.nixVersions.stable;
		 extraOptions = ''
			 experimental-features = nix-command flakes
		 '';
	 };

	# VMs
	# - Virtual Box
	virtualisation.virtualbox.host.enable = true;
	users.extraGroups.vboxusers.members = [ "emil" ];
	# virtualisation.docker.enable = true;
	# virtualisation.docker.enableNvidia = true;
	# users.extraGroups.docker.members = [ "emil" ];

	# - KVM
	virtualisation.libvirtd.enable = true;
	programs.dconf.enable = true;
	users.extraGroups.libvirtd.members = [ "emil" ];

	# Firewall
	# networking.firewall.extraCommands = "iptables -A OUTPUT -d 192.168.1.1 --destination-port 53 -j REJECT";
	# Open ports in the firewall.
	networking.firewall.allowedTCPPorts = [
		8080 12312 9000
		3333 4444 50001 5567 #LBRY
		#8060 #Onion service
		20538 #I2PD
		14573 #I2P
		10764 #I2P
	];
	networking.firewall.allowedUDPPorts = [
		3333 4444 50001 5567 #LBRY
		6889 12598 #Freenet
		20538 #I2PD
		14573 #I2P
		10764 #I2P
	];
	# Or disable the firewall altogether.
	# networking.firewall.enable = false;

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "23.05"; # Did you read the comment?
}
