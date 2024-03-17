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
    a2not-nvim = mkVimPlugin {inherit system;};
  in [
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
    pkgs.go
    pkgs.cargo
    pkgs.alejandra
    nodePackages."npm"
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
