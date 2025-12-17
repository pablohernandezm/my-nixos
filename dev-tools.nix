{
  pkgs,
  inputs,
  system,
  ...
}: {
  programs.neovim = {
    enable = true;
    package = inputs.neovim-nightly-overlay.packages.${system}.default;
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
    gcc
    viu
    chafa
    ueberzugpp
    typst
    vscode-extensions.vadimcn.vscode-lldb.adapter
    gradle_9
    inotify-tools # better for neovim's file watching (lsp)
    openssl # SSL and TLS protocols

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
    postgres-language-server
    sqruff
    jdt-language-server
    google-java-format
    taplo
    yamlfmt
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

  programs.java = {
    enable = true;
    package = pkgs.javaPackages.compiler.temurin-bin.jdk-25;
  };

  environment.variables = {
    # Support for Neovim LSP Java configuration.
    # These two extensions provide JDTLS with debugging and testing capabilities.
    VSCODE_JAVA_DEBUG_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-debug}/share/vscode/extensions/vscjava.vscode-java-debug/";
    VSCODE_JAVA_TEST_PATH = "${pkgs.vscode-extensions.vscjava.vscode-java-test}/share/vscode/extensions/vscjava.vscode-java-test/";
  };
}
