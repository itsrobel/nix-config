{ config, pkgs, ... }: {
  home.packages = [ pkgs.thefuck ];
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "thefuck" "docker" "zoxide" ];
      theme = "robbyrussell";
    };

    shellAliases = {
      ll = "ls -l";
      update = "sudo nixos-rebuild switch";
    };

    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
}
