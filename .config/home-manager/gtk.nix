{ pkgs, ... }: {
  home.packages = with pkgs; [ gtk-engine-murrine gnome-themes-extra ];
  gtk = {
    enable = true;
    theme = {
      name = "Rose-Pine-GTK";
      package = pkgs.rose-pine-gtk-theme;
    };
    iconTheme = {
      name = "rose-pine";
      package = pkgs.rose-pine-icon-theme;
    };
  };

  # Ensure GTK applications use the theme
  gtk.gtk3.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };

  gtk.gtk4.extraConfig = {
    gtk-application-prefer-dark-theme = 1;
  };
}
