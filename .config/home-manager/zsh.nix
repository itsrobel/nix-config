{ config, pkgs, ... }: {
  home.packages = [ pkgs.thefuck ];
  programs.zoxide = {
    enable = true;
    enableZshIntegration = true;
  };
  programs.zsh = {
    enable = true;
    enableCompletion = true;

    # initExtra = ''
    #   . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
    # '';
    # enableAutosuggestions = true;
    autosuggestion = {
      enable = true;
      strategy = [ "history" "completion" ];

    };
    # autosuggestions = {
    #   enable = true;
    # };
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
