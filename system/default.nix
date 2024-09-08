{ pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      trusted-users = [ "root" "@wheel" ];
    };
    gc = {
      automatic = true;
      options = "--delete-older-than 30d";
    };
  };

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    binfmt.emulatedSystems = [
      "aarch64-linux"
      "x86_64-windows"
    ];
    supportedFilesystems = [ "ntfs" ];
    initrd = {
      systemd.enable = true;
    };
  };

  time.timeZone = "America/Denver";
  services.timesyncd.enable = true;
  services.automatic-timezoned.enable = true;

  networking = {
    hostName = "gamersUnited";
    hostId = "bade417f";

    networkmanager.enable = true;

    firewall = {
      allowedUDPPorts = [ 25565 ];
      allowedTCPPorts = [ 25565 ];

      logReversePathDrops = true;
      extraCommands = ''
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN
        ip46tables -t mangle -I nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN
      '';
      extraStopCommands = ''
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --sport 49860 -j RETURN || true
        ip46tables -t mangle -D nixos-fw-rpfilter -p udp -m udp --dport 49860 -j RETURN || true
      '';
    };
  };

  i18n.defaultLocale = "en_US.UTF-8";

  users = {
    mutableUsers = false;

    users = {
      root = {
       initialPassword = "password";
      };

      greg = {
        isNormalUser = true;
        initialPassword = "gregtech";
      };

      ben = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [];
      };

      alark = {
        isNormalUser = true;
        initialPassword = "password";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        packages = with pkgs; [];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    vim
    tmux
    tldr

    curl

    xz
    unzip
    zip
    p7zip

    btop

    sl
  ];

  services = {
    openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        # PasswordAuthentication = false;
      };
      openFirewall = true;
    };
  };

  programs.git.enable = true;

  system.stateVersion = "24.11";
}
