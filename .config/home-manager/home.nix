{ config, pkgs, ... }: {
  home.username = "stef";
  home.homeDirectory = "/home/stef";
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./kitty.nix
    ./git.nix
    ./gtk.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
