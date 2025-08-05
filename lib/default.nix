{inputs}: let
  inherit (inputs.nixpkgs) legacyPackages;
in rec {
  mkVimPlugin = {system}: let
    inherit (pkgs) vimUtils;
    inherit (vimUtils) buildVimPlugin;
    pkgs = legacyPackages.${system};
  in
    buildVimPlugin {
      buildInputs = with pkgs; [doppler nodejs];
      name = "a2not";
      src = ../.;

      nvimSkipModules = [
        "init"
      ];

      postInstall = ''
        rm -rf $out/.gitignore
        rm -rf $out/Justfile
        rm -rf $out/LICENSE
        rm -rf $out/README.md
        rm -rf $out/flake.lock
        rm -rf $out/flake.nix
        rm -rf $out/lib
      '';
    };

  mkNeovimPlugins = {system}: let
    pkgs = legacyPackages.${system};
    inherit (pkgs) vimPlugins;
    a2not-nvim = mkVimPlugin {inherit system;};
  in [
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
    pkgs.unzip
    pkgs.wget

    pkgs.go
    pkgs.cargo
    pkgs.alejandra
    nodePackages."npm"
    pkgs.gcc
    pkgs.zig
    pkgs.python3
  ];

  initLua = ''
    lua << EOF
    -- same as ../init.lua
    require('config.options')
    require('config.keymaps')
    require('config.autocmds')
    require('config.lazy')
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
      };
      extraMakeWrapperArgs = ''--suffix PATH : "${lib.makeBinPath extraPackages}"'';
      withNodeJs = true;
      withPython3 = true;
      withRuby = true;
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
