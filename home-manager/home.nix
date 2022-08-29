# Home-manager configuration

{ inputs, lib, config, pkgs, ... }: {
  imports = [
  ];

  # Allow unfree
  nixpkgs.config.allowUnfree = true;

  # Set username
  home = {
    username = "hoaxdream";
    homeDirectory = "/home/hoaxdream";
  };

  # Add stuff for your user as you see fit.
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    htop
    alacritty
  ];

  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "22.05";
}
