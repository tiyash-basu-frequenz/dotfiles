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
  # Basic NixOS Configuration
  # ----------------------------------------------------------------------------
  nixpkgs.config.allowUnfree = true; # Allow unfree packages
  system.stateVersion = "25.11"; # NixOS release version

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
  # GUI auth agent
  # ----------------------------------------------------------------------------
  security.polkit.enable = true;

  # Start polkit-kde-agent in user session
  systemd.user.services.polkit-kde-authentication-agent-1 = {
    description = "polkit-kde-authentication-agent-1";
    wantedBy = [ "graphical-session.target" ];
    wants = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # ----------------------------------------------------------------------------
  # Sound Management Configuration with Pipewire
  # ----------------------------------------------------------------------------
  services.pulseaudio = {
    enable = false;
    package = pkgs.pulseaudioFull;
  };
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  services.pulseaudio.configFile = pkgs.writeText "default.pa" ''
    load-module module-bluetooth-policy
    load-module module-bluetooth-discover
    ## module fails to load with
    ##   module-bluez5-device.c: Failed to get device path from module arguments
    ##   module.c: Failed to load module "module-bluez5-device" (argument: ""): initialization failed.
    # load-module module-bluez5-device
    # load-module module-bluez5-discover
  '';

  # ----------------------------------------------------------------------------
  # Networking Configuration
  # ----------------------------------------------------------------------------
  networking = {
    hostName = "nixos";
    networkmanager.enable = true;
    hostFiles = [
      (pkgs.writeTextFile {
        name = "etc_hosts";
        text = builtins.readFile /home/tiyash/Dev/system/etc_hosts;
      })
    ];
  };

  # Start SSH agent
  programs.ssh.startAgent = true;
  # Enable OpenSSH server for remote login
  services.openssh.enable = true;

  # ----------------------------------------------------------------------------
  # Printing and Scanning
  # ----------------------------------------------------------------------------
  # Enable CUPS printing service
  services.printing.enable = true;

  # Enable auto-discovery of network printers
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  # Optional: Add specific printer drivers if needed
  services.printing.drivers = with pkgs; [
    gutenprint        # Wide range of printer support
    hplip             # HP printers
    brlaser           # Brother laser printers
    cnijfilter2       # Canon printers
    # Add others as needed
  ];

  # Enable scanner support
  hardware.sane = {
    enable = true;
    extraBackends = with pkgs; [
      hplipWithPlugin  # HP scanners
      sane-airscan     # Network scanners (AirScan/eSCL)
    ];
  };

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
    chromium
    dmidecode
    gcc
    gdb
    gitFull
    gnumake
    gnupg
    hwinfo
    kdePackages.polkit-kde-agent-1
    libgcc
    lshw
    nano
    nvtopPackages.full # Uncomment if you are installing nixos natively in a system with NVIDIA GPU.
    podman-tui
    python3
    pkg-config
    starship
    systemd
    tldr
    udev
    unzip
    usbutils
    wireguard-tools
    wl-clipboard
    yazi

    # Virtualization packages
    swtpm
    virtiofsd

    # Gnome packages for utilities
    evince
    gnome-calculator
    gnome-clocks
    gnome-font-viewer
    gparted
    nautilus
    simple-scan

    # Hyprland packages
    brightnessctl
    hyprcursor
    hypridle
    hyprlock
    hyprpaper
    hyprshot
    libnotify
    pavucontrol
    pulseaudio # for pactl
    swaynotificationcenter
    unzip
    waybar
    wofi
    xcur2png

    # Unstable packages
    unstable.ghostty
    unstable.neovim

    # rust - remember to add toolchain path to $PATH
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

  # Enable power-profiles-daemon for power management
  services.power-profiles-daemon.enable = true;

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

  # Virtualization with KVM/QEMU
  virtualisation.libvirtd.enable = true;
  programs.virt-manager.enable = true;

  # Enable UEFI support for VMs
  virtualisation.libvirtd.qemu = {
    package = pkgs.qemu_kvm;
    swtpm.enable = true;
  };

  # ----------------------------------------------------------------------------
  # User Configuration
  # ----------------------------------------------------------------------------
  users.users.tiyash = {
    isNormalUser = true;
    description = "Tiyash Basu";
    extraGroups = [ "libvirtd" "lp" "networkmanager" "scanners" "wheel" ];
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
