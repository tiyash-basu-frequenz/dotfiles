# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/wireguard.nix
{ pkgs, ... }: {
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
     wg_legacy = {
      ips = [
        "fd00:0:0:ffff::11/64"
      ];
      privateKeyFile = "/home/tiyash/Dev/fqz/wireguard/wg_legacy_private.key";
      peers = [
        {
          name = "tiyash";
          presharedKeyFile = "/home/tiyash/Dev/fqz/wireguard/wg_legacy_preshared.key";
          publicKey = "7L7C1SMHyZm7a8/RyCZ16zNurLSbk3qgbwfAUeF9wDA=";
          allowedIPs = [
            "10.0.10.0/24"
            "fd00::/48"
          ];
          endpoint = "iot.frequenz.com:51820";
          persistentKeepalive = 60;
        }
      ];
    };
    wg_vpn_eu = {
      ips = [
        "fd00:1:0:ffff::23/64"
      ];
      privateKeyFile = "/home/tiyash/Dev/fqz/wireguard/wg_vpn_eu_private.key";
      peers = [
        {
          name = "tiyash";
          presharedKeyFile = "/home/tiyash/Dev/fqz/wireguard/wg_vpn_eu_preshared.key";
          publicKey = "vc6nWRrmIu6Kfw0Zsg5OdATBz/jHx7xDSH3ewjTmrC0=";
          allowedIPs = [
            "fd00:1::/48"
          ];
          endpoint = "vpn.eu.frequenz.io:51820";
          persistentKeepalive = 60;
        }
      ];
    };
  };
}
