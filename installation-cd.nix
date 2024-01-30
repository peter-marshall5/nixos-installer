{ config, lib, pkgs, modulesPath, ... }:

let

  efiArch = pkgs.stdenv.hostPlatform.efiArch;
  kernelPath = "/EFI/Linux/kernel.efi";

in

{

  imports = [
    (modulesPath + "/installer/cd-dvd/iso-image.nix")
    (modulesPath + "/profiles/minimal.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  isoImage.makeEfiBootable = true;
  isoImage.makeUsbBootable = true;

  boot.kernelParams = [
    "console=ttyS0"
    "loglevel=2"
    "nomodeset"
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users.mutableUsers = false;
  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" ];
    initialHashedPassword = "";
  };
  users.users.root.initialHashedPassword = "";
  services.getty.autologinUser = "nixos";

  security.sudo.wheelNeedsPassword = false;

  fileSystems = config.lib.isoFileSystems;

  networking.useNetworkd = true;

  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    e2fsprogs
    btrfs-progs
    cryptsetup
  ];

  system.stateVersion = lib.trivial.release;

}
