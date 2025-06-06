{ config, pkgs, ... }:

let
  # This is for installing packages from the unstable channel
  # Remember to run the following beforehand:
  # $ nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # $ nix-channel --update
  unstable = import <nixos-unstable> {};
in
{
  # ----------------------------------------------------------------------------
  # Imports
  # ----------------------------------------------------------------------------
  imports =
  [
    ./hardware-configuration.nix
    ./wireguard.nix
  ];

  # ----------------------------------------------------------------------------
  # Additional Hardware Configuration
  # ----------------------------------------------------------------------------
  hardware.graphics.enable = true; # Enable OpenGL

  # ----------------------------------------------------------------------------
  # Bootloader Configuration
  # ----------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # ----------------------------------------------------------------------------
  # Basic NixOS Configuration
  # ----------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true; # Allow unfree packages
  system.stateVersion = "24.11"; # NixOS release version

  # ----------------------------------------------------------------------------
  # Locale Settings
  # ----------------------------------------------------------------------------
  time.timeZone = "Europe/Berlin"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "en_IE.UTF-8";
    LC_MEASUREMENT = "en_IE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "en_IE.UTF-8";
    LC_NUMERIC = "en_IE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
  };

  # ----------------------------------------------------------------------------
  # Time Synchronization
  # ----------------------------------------------------------------------------
  # Enable Chrony for time synchronization
  services.chrony = {
    enable = true;
    servers = [ "0.pool.ntp.org" "1.pool.ntp.org" "2.pool.ntp.org" ];
    extraConfig = ''
      makestep 1.0 3
    '';
  };

  # ----------------------------------------------------------------------------
  # Shell Configuration
  # ----------------------------------------------------------------------------
  programs.zsh.enable = true; # Enable Zsh shell
  users.defaultUserShell = pkgs.zsh; # Set Zsh as the default shell

  # ----------------------------------------------------------------------------
  # Desktop Environment and Display Manager
  # ----------------------------------------------------------------------------
  # X11 configuration - Disable X11 server
  services.xserver.enable = false;

  # Enable gdm with Wayland
  # Note that GDM _needs_ X11 to work, so you can't disable X11 and use GDM.
  # services.xserver.displayManager.gdm = {
  #   enable = true;
  #   wayland = true;
  # };

  # Enable Gnome Desktop Environment
  services.xserver.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    baobab # GNOME Disk Usage Analyzer
    cheese # GNOME Webcam
    epiphany # GNOME Web
    geary # GNOME Mail
    gnome-calendar
    gnome-characters
    gnome-contacts
    gnome-control-center
    gnome-logs
    gnome-maps
    gnome-music
    gnome-system-monitor
    gnome-terminal
    gnome-weather
    pkgs.gedit # GNOME Text Editor
    pkgs.gnome-tour
    pkgs.gnome-connections
    seahorse # GNOME Passwords and Keys
    totem # GNOME Videos
    yelp # GNOME help
  ];

  # Enable SDDM with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable Plasma Desktop Environment
  # services.desktopManager.plasma6.enable = true;
  # environment.plasma6.excludePackages = with pkgs.libsForQt5; [
  #   elisa
  #   kate
  #   konsole
  #   oxygen
  #   plasma-browser-integration
  # ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ----------------------------------------------------------------------------
  # Sound Management Configuration with Pipewire
  # ----------------------------------------------------------------------------
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ----------------------------------------------------------------------------
  # Networking Configuration
  # ----------------------------------------------------------------------------
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    hostFiles = [
      (pkgs.writeTextFile {
        name = "etc_hosts";
        text = builtins.readFile /home/tiyash/Dev/fqz/system/etc_hosts;
      })
    ];
  };

  # Enable SSH
  programs.ssh.startAgent = true;
  services.openssh.enable = true;

  # ----------------------------------------------------------------------------
  # Printing Services
  # ----------------------------------------------------------------------------
  services.printing.enable = true;

  # ----------------------------------------------------------------------------
  # GPG Configuration
  # ----------------------------------------------------------------------------
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true; # Enable SSH support
  };

  # ----------------------------------------------------------------------------
  # System Packages
  # ----------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    alacritty
    chromium
    dmidecode
    gcc
    gdb
    gitFull
    gnumake
    gnupg
    hwinfo
    libgcc
    lshw
    nano
    nix-index
    # nvtopPackages.full # Uncomment if you are installing nixos natively in a system with NVIDIA GPU.
    podman-tui
    python3Full
    pkg-config
    systemd
    unzip
    usbutils
    wireguard-tools
    wl-clipboard
    zsh

    # # Gnome packages
    # evince
    # gnome-calculator
    # gnome-clocks
    # gnome-font-viewer
    # gparted
    # nautilus
    # simple-scan

    # Hyprland packages
    # brightnessctl # Uncomment if you are installing nixos natively.
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    libnotify
    pavucontrol
    swaynotificationcenter
    waybar
    wofi
    xcur2png

    # Unstable packages
    unstable.ghostty
    unstable.neovim
  ];

  # Configure neovim aliases
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.chromium = {
    commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  };

  # ----------------------------------------------------------------------------
  # Font Configuration
  # ----------------------------------------------------------------------------

  fonts.packages = with pkgs; [
    font-awesome
    nerd-fonts.fira-code
    noto-fonts
    open-sans
  ];

  fonts.fontconfig = {
    enable = true;

    defaultFonts = {
      monospace = ["FiraCode Nerd Font"];
      sansSerif = ["Noto Sans"];
      serif = ["Noto Serif"];
    };

    hinting = {
      enable = true;
      style = "slight";
    };

    subpixel = {
      lcdfilter = "none";
      rgba = "rgb";
    };
  };

  # ----------------------------------------------------------------------------
  # Podman Configuration
  # ----------------------------------------------------------------------------
  virtualisation.containers.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerCompat = true; # Create a `docker` alias for Podman
    defaultNetwork.settings.dns_enabled = true;
  };


  # ----------------------------------------------------------------------------
  # User Configuration
  # ----------------------------------------------------------------------------
  users.users.tiyash = {
    isNormalUser = true;
    description = "Tiyash Basu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      btop
      eza
      fastfetch
      gh
      go
      grpcurl
      jq
      lazygit
      # libreoffice-qt # Build is failing
      nodejs
      protobuf
      puppet-bolt
      # rust
      rustc
      cargo
      rust-analyzer
      rustfmt
      # Terminal plugins
      starship
      tmux
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-history-substring-search
      zsh-z
      # Neovim plugins
      black
      fzf
      gopls
      isort
      lua-language-server
      nodePackages.prettier
      ripgrep
      stylua
    ];
  };
}
