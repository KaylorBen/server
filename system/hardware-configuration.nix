{
  imports = [
    ./disko.nix
  ];

  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };

  fileSystems."/.persistent".neededForBoot = true;
}
