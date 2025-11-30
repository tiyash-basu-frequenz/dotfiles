{ config, pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Imports
  # ----------------------------------------------------------------------------
  imports =
  [
    "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; }}/dell/xps/15-9520"
    ./hardware-configuration.nix
    ./system.nix
    ./wireguard.nix
  ];

  # ----------------------------------------------------------------------------
  # Additional Hardware Configuration
  # ----------------------------------------------------------------------------
  hardware.graphics.enable = true; # Enable OpenGL

  # ----------------------------------------------------------------------------
  # Bluetooth Configuration
  # ----------------------------------------------------------------------------
  hardware.bluetooth.enable = true; # Enable bluetooth
  services.blueman.enable = true; # Enable blueman applet

  # ----------------------------------------------------------------------------
  # Bootloader Configuration
  # ----------------------------------------------------------------------------
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
