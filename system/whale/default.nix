{
  lib,
  pkgs,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  boot = {
    initrd.availableKernelModules = ["virtio_scsi" "virtio_pci" "sr_mod" "sd_mod" "ata_piix" "uhci_hcd" "virtio_blk"];
  };

  services.jellyfin = {
    enable = true;
  };

  services.jellyseer = {
    enable = true;
  };

  services.sonarr = {
    enable = true;
  };

  services.radarr = {
    enable = true;
  };

  services.syncthing = {
    enable = true;
    overrideDevices = false;
    overrideFolders = false;
  };

  system.fsPackages = [pkgs.mergerfs];

  fileSystems = {
    "/srv/disks/eighteen-storage" = {
      device = "/dev/disk/by-label/storage-1";
      fsType = "ext4";
    };

    "/srv/disks/eighteen-backup" = {
      device = "/dev/disk/by-label/backup-1";
      fsType = "ext4";
    };

    "/srv/disks/twelve-storage" = {
      device = "/dev/disk/by-label/storage-2";
      fsType = "ext4";
    };

    "/srv/disks/twelve-backup" = {
      device = "/dev/disk/by-label/backup-2";
      fsType = "ext4";
    };

    "/srv/disks/eight-roms-1" = {
      device = "/dev/disk/by-label/roms-1";
      fsType = "ext4";
    };

    "/srv/disks/eight-roms-2" = {
      device = "/dev/disk/by-label/roms-2";
      fsType = "ext4";
    };

    "/srv/game" = {
      device = "/dev/disk/by-label/game";
      fsType = "ext4";
    };

    "/srv/storage" = {
      device = "/srv/disks/eighteen-storage:/srv/disks/twelve-storage";
      fsType = "fuse.mergerfs";
      options = ["allow_other" "moveonenospc=true" "category.create=mfs" "use_ino" "dropcacheonclose=true" "posix_acl=true"];
    };

    "/srv/backup" = {
      device = "/srv/disks/eighteen-backup:/srv/disks/twelve-backup";
      fsType = "fuse.mergerfs";
      options = ["allow_other" "moveonenospc=true" "category.create=mfs" "use_ino" "dropcacheonclose=true" "posix_acl=true"];
    };

    "/srv/roms" = {
      device = "/srv/disks/eight-roms-1:/srv/disks/eight-roms-2";
      fsType = "fuse.mergerfs";
      options = ["allow_other" "moveonenospc=true" "category.create=mfs" "use_ino" "dropcacheonclose=true" "posix_acl=true"];
    };
  };
}
