{
  pkgs,
  inputs,
  ...
}: {
  home.packages = with pkgs; [
    bruno # API testing
    jujutsu # Git-compatible DVCS
    tmux # Terminal multiplexer
    bacon # Background rust code checker
    sqlx-cli # Command-line utility for managing databases
    youtube-music # Music player
    ffmpeg # Record, convert and stream audio and video.
    inputs.nixohess.packages.${pkgs.stdenv.hostPlatform.system}.stremio-linux-shell
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "25.11";
}
