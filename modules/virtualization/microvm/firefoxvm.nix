# Copyright 2022-2023 TII (SSRC) and the Ghaf contributors
# SPDX-License-Identifier: Apache-2.0
{
  lib,
  microvm,
  system,
}:
lib.nixosSystem {
  inherit system;
  specialArgs = {inherit lib;};
  modules =
    [
      {
        ghaf = {
          users.accounts.enable = true;
          development = {
            ssh.daemon.enable = true;
            debug.tools.enable = true;
          };
        };
      }

      microvm.nixosModules.microvm

      ({lib, pkgs, ...}: {
        networking.hostName = "appvm-firefox";
        # TODO: Maybe inherit state version
        system.stateVersion = lib.trivial.release;
        microvm.hypervisor = "crosvm";

        networking = {
          enableIPv6 = false;
          firewall.allowedTCPPorts = [22];
          firewall.allowedUDPPorts = [67];
          useNetworkd = true;
        };

        microvm.interfaces = [
          {
            type = "tap";
            id = "vm-appvm-ffox";
            mac = "02:00:00:02:03:04";
          }
        ];

        microvm.qemu.bios.enable = false;
        microvm.storeDiskType = "squashfs";

        environment.systemPackages = with pkgs; [
          firefox
        ];
      })
    ]
    ++ (import ../../module-list.nix);
}
