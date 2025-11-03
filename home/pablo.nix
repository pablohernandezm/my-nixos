{pkgs, ...}: {
  home.packages = with pkgs; [
    bruno # API testing
    jujutsu # Git-compatible DVCS
    tmux # Terminal multiplexer
    bacon # Background rust code checker
    sqlx-cli # Command-line utility for managing databases
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
