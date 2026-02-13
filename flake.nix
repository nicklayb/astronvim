{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:

    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };
      in
      {
        packages.default = pkgs.buildEnv {
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

        homeManagerModules.default = { config, pkgs, lib, ... }:
          let
            deps = self.packages.${pkgs.system}.default;
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
      }
    );
}
