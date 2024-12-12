{ config, pkgs, ... }: {
  home.username = "stef";
  home.homeDirectory = "/home/stef";
  home.packages = with pkgs; [
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
    ./kitty.nix
    ./git.nix
    ./gtk.nix
    ./nvim.nix
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "24.11";
}
