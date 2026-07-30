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
        pkgs.gnumake
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
        {
          options.astronvim.features = lib.mkOption {
            type = lib.types.attrsOf lib.types.bool;
            default = { };
            example = {
              copilot = false;
            };
            description = ''
              Enable or disable optional AstroNvim plugins/features.
              Keys correspond to feature names checked in Lua via
              `require("utils.features").enabled("<name>")` (e.g. the
              `copilot` plugin). Features not listed here default to enabled,
              so this only needs to list the ones you want to turn off.
            '';
          };

          config =
            let
              deps = self.packages.${pkgs.system}.neovimDeps;

              featureEnv = lib.mapAttrs' (
                name: enabled: lib.nameValuePair "NVIM_FEATURE_${lib.toUpper name}" (if enabled then "1" else "0")
              ) config.astronvim.features;

              wrapFlags = [
                "--set NODEJS_24 ${pkgs.nodejs_24}"
              ]
              ++ (lib.mapAttrsToList (name: value: "--set ${name} ${lib.escapeShellArg value}") featureEnv);

              wrappedNeovim = pkgs.symlinkJoin {
                name = "nvim";
                paths = [ pkgs.neovim ];

                buildInputs = [ pkgs.makeWrapper ];

                postBuild = ''
                  wrapProgram $out/bin/nvim ${lib.concatStringsSep " " wrapFlags}
                '';
              };
            in
            {
              home.packages = [
                wrappedNeovim
                deps
              ];

              xdg.configFile."nvim" = {
                source = lib.cleanSource self;
                recursive = true;
              };
            };
        };
    };
}
