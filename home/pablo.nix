{pkgs, ...}: {
  home.packages = with pkgs; [
    bruno # API testing
    jujutsu # Git-compatible DVCS
    tmux # Terminal multiplexer
    bacon # Background rust code checker
    sqlx-cli # Command-line utility for managing databases
    pear-desktop # YT music wrapper
    spotify # Music player
    ffmpeg # Record, convert and stream audio and video.
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";

  programs.ashell = {
    enable = true;
    settings = {
      modules = {
        center = ["WindowTitle"];
        right = ["Tray" "Clock" "SystemInfo" ["Privacy" "Settings"]];
        left = ["Workspaces"];
      };
      settings = {
        remove_airplane_btn = true;
      };
      window_title = {
        mode = "Title";
        truncate_title_after_length = 75;
      };
    };
  };
}
