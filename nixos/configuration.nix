{ config, pkgs, ... }:

let
  # This is for installing packages from the unstable channel
  # Remember to run the following beforehand:
  # $ nix-channel --add https://nixos.org/channels/nixos-unstable nixos-unstable
  # $ nix-channel --update
  unstable = import <nixos-unstable> {};

  # Wrapper for Obsidian to run with Wayland support
  obsidianWrapped = pkgs.symlinkJoin {
    name = "obsidian";
    paths = [ pkgs.obsidian ];
    buildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/obsidian \
        --add-flags "--enable-features=UseOzonePlatform --ozone-platform=wayland"
    '';
  };
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
  system.stateVersion = "25.05"; # NixOS release version

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
  # Enable fish shell, and use it as the default shell
  programs.fish.enable = true;
  programs.fish.shellAliases = {
    grep = "rg"; # Use ripgrep instead of grep
    gru = "git remote update --prune";
    gss = "git submodule status";
    gsu = "git submodule update --init --recursive";
    l = "exa -l --icons --group-directories-first";
    la = "exa -la --icons --group-directories-first";
    ll = "exa -l --icons --group-directories-first";
    ls = "exa --icons --group-directories-first";
  };
  users.defaultUserShell = pkgs.fish;
  # Add fish plugins
  programs.zoxide = {
    enable = true;
    enableFishIntegration = true;
  };

  # ----------------------------------------------------------------------------
  # Desktop Environment and Display Manager
  # ----------------------------------------------------------------------------

  # Enable SDDM with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # X11 configuration - Disable X11 server
  services.xserver.enable = false;

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

  # Start SSH agent
  programs.ssh.startAgent = true;
  # Disable OpenSSH server, to disable remote SSH login.
  # services.openssh.enable = true;

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
    starship
    systemd
    udev
    unzip
    usbutils
    wireguard-tools
    wl-clipboard
    yazi

    # Gnome packages
    evince
    gnome-calculator
    gnome-clocks
    gnome-font-viewer
    gparted
    nautilus
    simple-scan

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
    unzip
    waybar
    wofi
    xcur2png

    # Unstable packages
    unstable.ghostty
    unstable.neovim

    # rust - add toolchain path to $PATH
    rustup
  ];

  # Configure neovim aliases
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
  };

  # Set EDITOR to nvim
  environment.variables.EDITOR = "nvim";

  # Start chromium with Wayland support
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
      jujutsu
      lazygit
      wireshark
      # libreoffice-qt # Build is failing
      nodejs
      # Install Obsidian with Wayland support. Look at the top for wrapper definition.
      obsidianWrapped
      protobuf
      puppet-bolt
      # Terminal plugins
      tmux
      # Neovim plugins
      black
      codespell
      fzf
      gopls
      isort
      lua-language-server
      nodePackages.prettier
      protols
      ripgrep
      stylua
    ];
  };
}
