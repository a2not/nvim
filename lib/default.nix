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
        rm -rf $out/justfile
        rm -rf $out/lib
      '';
      src = ../.;
    };

  mkNeovimPlugins = {system}: let
    a2not-nvim = mkVimPlugin {inherit system;};
  in [
    a2not-nvim
  ];

  initLua = ''
    lua << EOF
    ${builtins.readFile ../init.lua}
    EOF
  '';

  mkNeovim = {system}: let
    inherit (pkgs) neovim;
    pkgs = legacyPackages.${system};
    start = mkNeovimPlugins {inherit system;};
  in
    neovim.override {
      configure = {
        customRC = initLua;
        packages.main = {inherit start;};
      };
    };

  mkHomeManager = {system}: let
    extraConfig = initLua;
    plugins = mkNeovimPlugins {inherit system;};
  in {
    inherit extraConfig plugins;
    enable = true;
  };
}