{ pkgs, ... }: {
  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "tmux-256color";
    prefix = "C-s";
    baseIndex = 1;
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = catppuccin;
      }
    ];

    extraConfig = builtins.readFile ./tmux.conf;
  };
}
