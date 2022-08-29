# Nixos configuration

{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  nix = {
    # This will add each flake input as registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well.
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}") config.nix.registry;
  };

  nix = {
    settings = {
      # Enable flakes and new 'nix' command
      experimental.features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
    };
  };

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Set your hostname
  networking.hostName = "art";

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone
  time.timeZone = "Asia/Manila";

  # Select internationalisation properties
  i18n.defaultLocale = "en_PH.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  # Window manager
  services = {
    xserver = {
      enable = true;
      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce";
      };
      desktopManager.xfce.enable = true;
      windowManager.bspwm.enable = true;
    };
  };

  services.xserver.xkbOptions = "caps:escape";
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Configure your system-wide user settings (groups, etc).
  users.users = {
    hoaxdream = {
      initialPassword = "password";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
      # Add your SSH public key(s) here, if you plan on using SSH to connect
      ];
      # Be sure to add any other groups you need.
      extraGroups = [ "wheel" ];
    };
  };

  # Steam
  hardware.opengl.driSupport32Bit = true;
  hardware.opengl.driSupport = true;

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  services.xserver.screenSection = ''
    Option         "metamodes" "DP-2: 2560x1440_144 +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}, HDMI-0: 1920x1080_75 +2560+180 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  # System version
  system.stateVersion = "22.05";

}
