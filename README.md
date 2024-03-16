# nvim conf

Just cloning this under `$XDG_CONFIG_HOME` works fine.

Can be used with nix or imported to other flakes.

## With Nix

Make sure `git` installed.

### Run in shell

With nix shell

```bash
nix shell github:a2not/nvim#neovim
nvim
```

### Import to flake

Add to `flake.nix` as an input

```nix
inputs = {
  nvim.url = "github:a2not/nvim";
};
```

- With system config: Add to environment.systemPackages configuration

```nix
environment.systemPackages = [
  inputs.nvim.packages.${pkgs.system}.neovim
];
```

- And/Or with home-manager:
```nix
programs.neovim = inputs.nvim.lib.mkHomeManager {
  system = pkgs.system;
};
```

## Reference

Wanted to config neovim in lua, and stumbled upon ALT-F4-LLC's flake.

Nix flake code is mostly the same, shout-out for his great work.

- https://github.com/ALT-F4-LLC/thealtf4stream.nvim/

### Memo

Maybe use `nixpkgs.vimUtils.buildVimPlugin` is just enough.

```nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    flake-parts,
    self,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      system = [
        "aarch64-linux"
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];

      perSystem = {pkgs, ...}: {
        packages = {
          nvim = pkgs.vimUtils.buildVimPlugin {
            name = "nvim";
            src = "./";
          };
        };
      };

      # ...
    };
}
```

- reference: https://www.youtube.com/watch?v=i68c6vZkSXc
