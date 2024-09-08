{ pkgs, ... }:
let dir = directory: user: group: mode: { inherit directory user group mode; };
    persistentDirectory = "/.persistent";
in {
  users.users.root.hashedPasswordFile = persistentDirectory + "/passwords/root";
  users.users.alark.hashedPasswordFile = persistentDirectory + "/passwords/alark";
  users.users.ben.hashedPasswordFile = persistentDirectory + "/passwords/ben";
  users.users.greg.hashedPasswordFile = persistentDirectory + "/passwords/greg";
  # Handles rollbacks for ZFS, disabled to ensure paths are fully set
  boot.initrd.systemd.services.impermanence = {
    description = "Resets root to a clean state (Requires ZFS)";
    wantedBy = [ "initrd.target" ];
    after = [ "zfs-import-zroot.service" ];
    before = [ "sysroot.mount" ];
    path = with pkgs; [ zfs ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      zfs rollback -r zroot/NixOS/root@blank
    '';
  };
  fileSystems.${persistentDirectory}.neededForBoot = true;
  environment.persistence.${persistentDirectory} = {
    hideMounts = true;
    directories = [
      (dir "/var/log" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/var/lib/bluetooth" "root" "root" "u=rwx,g=,o=")
      (dir "/var/lib/nixos" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/var/lib/systemd/coredump" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/etc/NetworkManager/system-connections" "root" "root" "u=rwx,g=,o=")
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/pipewire"
      (dir "/var/lib/alsa" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/var/db/sudo" "root" "root" "u=rwx,g=,o=")
      (dir "/etc/secureboot" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/etc/fwupd" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/etc/ssh/authorized_keys.d" "root" "root" "u=rwx,g=rx,o=rx")
      (dir "/var/lib/colord" "colord" "colord" "u=rwx,g=rx,o=rx")
      (dir "/etc/nix" "root" "root" "u=rwx,g=rx,o=rx")
    ];
    files = [
      "/etc/machine-id"
      "/etc/adjtime"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
    ];
  };
}
