{inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = {system}: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {
      name = "a2not";
      postInstall = ''
        rm -rf $out/.gitignore
        rm -rf $out/LICENSE
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/lib
      '';
      src = ../.;
    };

  mkNeovimPlugins = {system}: let
    inherit (pkgs) vimPlugins;
    pkgs = legacyPackages.${system};
    a2not-nvim = mkVimPlugin {inherit system;};
  in [
    vimPlugins.nvim-lspconfig
    vimPlugins.nvim-treesitter.withAllGrammars

    a2not-nvim
  ];

  mkExtraPackages = {system}: let
    inherit (pkgs) nodePackages;

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in [
    nodePackages."eslint"
    nodePackages."typescript"
    nodePackages."typescript-language-server"
    nodePackages."yaml-language-server"
    pkgs.gopls
    pkgs.lua-language-server
    pkgs.nil
    pkgs.rust-analyzer

    # formatters
    pkgs.alejandra
    pkgs.gofmt
    pkgs.rustfmt
  ];

  initLua = ''
    lua << EOF
    ${builtins.readFile ../init.lua}
    EOF
  '';

  mkNeovim = {system}: let
    inherit (pkgs) lib neovim;
    extraPackages = mkExtraPackages {inherit system;};
    pkgs = legacyPackages.${system};
    start = mkNeovimPlugins {inherit system;};
  in
    neovim.override {
      configure = {
        customRC = initLua;
        packages.main = {inherit start;};
        extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
        withNodeJs = true;
        withPython3 = true;
        withRuby = true;
      };
    };

  mkHomeManager = {system}: let
    extraConfig = initLua;
    extraPackages = mkExtraPackages {inherit system;};
    plugins = mkNeovimPlugins {inherit system;};
  in {
    inherit extraConfig extraPackages plugins;
    enable = true;
    withNodeJs = true;
    withPython3 = true;
    withRuby = true;
  };
}
