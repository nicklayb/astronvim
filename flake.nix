{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:

    let
      systems = nixpkgs.lib.systems.flakeExposed;
      pkgsFor =
        system:
        import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      packages = pkgs: [
        pkgs.nil
        pkgs.nodejs_24
        pkgs.ripgrep
        pkgs.fd
        pkgs.git
        pkgs.tree-sitter
        pkgs.claude-code
      ];
    in
    {
      packages = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          neovimDeps = pkgs.buildEnv {
            name = "neovim-deps";
            paths = packages pkgs;
          };
        }
      );

      devShells = nixpkgs.lib.genAttrs systems (
        system:
        let
          pkgs = pkgsFor system;
        in
        {
          default = pkgs.mkShell {
            buildInputs = packages pkgs;
          };
        }
      );

      homeManagerModules.default =
        {
          config,
          pkgs,
          lib,
          ...
        }:
        let
          deps = self.packages.${pkgs.system}.neovimDeps;
        in
        {
          programs.neovim = {
            enable = true;
            extraPackages = [deps];
          }

          xdg.configFile."nvim" = {
            source = lib.cleanSource self;
            recursive = true;
          };
        };
    };
}
