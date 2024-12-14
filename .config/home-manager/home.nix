{ config, pkgs, ... }: {
  home.username = "stef";
  home.homeDirectory = "/home/stef";
  home.packages = with pkgs; [
    spotify-player
    julia
    wl-clipboard
    zsh
    oh-my-zsh
    zsh-completions
    zsh-syntax-highlighting
    nodejs_22
    zulu
    tmux
    stow
    zig
    go
    php
    luarocks
    lua
    eza
    fzf
    zoxide
    kitty
    ruby
    tree-sitter
    lua51Packages.tl
    lazygit
    fd
    ripgrep
    biber
    clang
    waybar
    texlivePackages.latexmk
    texlivePackages.bibtex

  ];
  imports = [
    ./zsh.nix
    ./tmux.nix
    ./git.nix
    ./gtk.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  # home.sessionVariables = {
  #   NIX_PATH = "$HOME/.nix-defexpr/channels:/nix/var/nix/profiles/per-user/root/channels${NIX_PATH:+:$NIX_PATH}";
  # };
}
