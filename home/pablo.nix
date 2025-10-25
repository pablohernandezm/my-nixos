{ pkgs, ... }:
{
  home.packages = with pkgs; [
    yaak # API client
    jujutsu # Git-compatible DVCS
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
