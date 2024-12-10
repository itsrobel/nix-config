{ pkgs, ... }: {
  home.packages = with pkgs; [ git git-credential-manager ];
  programs.git = {
    enable = true;
    userEmail = "itsrobel.schwarz@gmail.com";
    userName = "itsrobel";
    extraConfig.credential.helper = "manager";
    extraConfig.credential."https://github.com".username = "itsrobel";
    extraConfig.credential.credentialStore = "cache";
  };

}
