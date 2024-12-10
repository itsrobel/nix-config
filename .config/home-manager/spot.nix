{ config, pkgs, ... }: {
  home.packages = with pkgs; [ spotify-player ];
  programs.spotify-player = {
    enable = true;
    themes = [
      {
        name = "Catppuccin-macchiato";
        palette = {
          black = "#24273a";
          red = "#ed8796";
          green = "#a6da95";
          yellow = "#eed49f";
          blue = "#8aadf4";
          magenta = "#f5bde6";
          cyan = "#8bd5ca";
          white = "#cad3f5";
          bright_black = "#494d64";
          bright_red = "#ed8796";
          bright_green = "#a6da95";
          bright_yellow = "#eed49f";
          bright_blue = "#8aadf4";
          bright_magenta = "#f5bde6";
          bright_cyan = "#8bd5ca";
          bright_white = "#cad3f5";
        };
      }
    ];
  };

  systemd.user.services.spotify-player = {
    description = "Spotify Player Daemon";
    after = [ "network-online.target" "sound.target" ];
    wants = [ "network-online.target" "sound.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      ExecStart = "${pkgs.spotify-player}/bin/spotify_player --daemon-only";
      Restart = "always";
      RestartSec = 12;
    };
  };
  home.file.".config/spotify-player/app.toml".text = ''
    notify_streaming_only = true
    enable_streaming = "DaemonOnly"
    enable_media_control = true
  '';

}
