# https://github.com/NixOS/nixpkgs/blob/nixos-24.11/nixos/modules/services/networking/wireguard.nix
{ pkgs, ... }: {
  networking.wireguard.enable = true;
  networking.wireguard.interfaces = {
     wg_legacy = {
      ips = [
        "fd00:0:0:ffff::11/64"
      ];
      listenPort = 51820;
      privateKeyFile = "/home/tiyash/wireguard/wg_legacy_private.key";
      peers = [
        {
          name = "peer1";
          presharedKeyFile = "/home/tiyash/wireguard/wg_legacy_preshared.key";
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
  };
}
