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
    ];

  # ----------------------------------------------------------------------------
  # Additional Hardware Configuration
  # ----------------------------------------------------------------------------
  hardware.opengl.enable = true; # Enable OpenGL

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
  system.stateVersion = "24.05"; # NixOS release version

  # ----------------------------------------------------------------------------
  # Locale Settings
  # ----------------------------------------------------------------------------
  time.timeZone = "Europe/Berlin"; # Set your time zone.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "en_IE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "en_IE.UTF-8";
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

  # Enable SDDM with Wayland
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Enable Plasma Desktop Environment
  services.desktopManager.plasma6.enable = true;
  environment.plasma6.excludePackages = with pkgs.libsForQt5; [
    elisa
    kate
    konsole
    oxygen
    plasma-browser-integration
  ];

  # Enable Hyprland
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ----------------------------------------------------------------------------
  # Sound Management Configuration with Pipewire
  # ----------------------------------------------------------------------------
  hardware.pulseaudio.enable = false;
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
        text = builtins.readFile /home/tiyash/etc_hosts;
      })
    ];
  };

  # Enable SSH
  services.openssh.enable = true;

  # ----------------------------------------------------------------------------
  # Printing Services
  # ----------------------------------------------------------------------------
  services.printing.enable = true;

  # ----------------------------------------------------------------------------
  # System Packages
  # ----------------------------------------------------------------------------
  environment.systemPackages = with pkgs; [
    alacritty
    chromium
    fira-code-nerdfont
    firefox
    font-awesome
    gcc
    gdb
    gitFull
    gnumake
    gnupg
    kitty
    libgcc
    nano
    nix-index
    podman-tui
    python3Full
    unzip
    usbutils
    wl-clipboard
    # Hyprland packages
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
  ];

  # Install neovim
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
  };

  nixpkgs.config.chromium = {
    commandLineArgs = "--enable-features=UseOzonePlatform --ozone-platform=wayland";
  };

  # Add any packages you need from the unstable channel here if necessary.
  # E.g., to install a package from the unstable channel:
  # environment.systemPackages = with pkgs; [
  #   unstable.packageName
  # ];

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
      grpcurl
      jq
      nodejs
      protobuf
      puppet-bolt
      rustup
      # Terminal plugins
      starship
      tmux
      zsh-autosuggestions
      zsh-syntax-highlighting
      zsh-history-substring-search
      # Neovim plugins
      black
      fzf
      lua-language-server
      nodePackages.prettier
      ripgrep
      stylua
    ];
  };

}
