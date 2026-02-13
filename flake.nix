{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    let
      systems = flake-utils.lib.systems.flakeExposed;
      pkgsFor = system: import nixpkgs { inherit system; };
    in
    {
      packages = flake-utils.lib.genAttrs systems (system:
        let pkgs = pkgsFor system; in
        {
          neovimDeps = pkgs.buildEnv {
            name = "neovim-deps";
            paths = with pkgs; [
              nil
              nodejs
              ripgrep
              fd
              git
              tree-sitter
            ];
          };
        }
      );

      homeManagerModules.default = { config, pkgs, lib, ... }:
        let
          deps = self.packages.${pkgs.system}.neovimDeps;
        in
        {
          home.packages = [
            deps
          ];

          xdg.configFile."nvim" = {
            source = lib.cleanSource self;
            recursive = true;
          };
        };
    };
}
