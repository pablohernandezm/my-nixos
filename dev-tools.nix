{ pkgs, inputs, ... }:
{
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
    defaultEditor = true;
  };

  environment.systemPackages = with pkgs; [
    # Libs
    ripgrep
    fzf
    tree-sitter
    zig
    nodejs
    bun
    cargo
    rustc
    viu
    chafa
    ueberzugpp
    typst
    vscode-extensions.vadimcn.vscode-lldb.adapter

    # Lsp and formatters
    lua-language-server
    stylua
    nil
    alejandra
    tinymist
    typstyle
    rust-analyzer
    rustfmt
    docker-language-server
  ];

  # Takes care of both installation and setting up the sourcing of the shell
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    settings = {
      global = {
        hide_env_diff = true;
      };
    };
  };

}
