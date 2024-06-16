{
  description = "devShell for Neovim Lua plugins";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    rocks-nvim-input.url = "github:nvim-neorocks/rocks.nvim";
    flake-parts.url = "github:hercules-ci/flake-parts";
    neorocks.url = "github:nvim-neorocks/neorocks";
    gen-luarc.url = "github:mrcjkb/nix-gen-luarc-json";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    rocks-nvim-input,
    flake-parts,
    neorocks,
    gen-luarc,
    git-hooks,
    ...
  }: let
    test-overlay = import ./nix/test-overlay.nix {
      inherit self;
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      perSystem = {
        config,
        self',
        inputs',
        pkgs,
        system,
        ...
      }: let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            neorocks.overlays.default
            gen-luarc.overlays.default
            rocks-nvim-input.overlays.default
            test-overlay
          ];
        };
        luarc = pkgs.mk-luarc {
          nvim = pkgs.neovim-nightly;
          neodev-types = "nightly";
          plugins = with pkgs.lua51Packages; [
            rocks-nvim
            nvim-nio
          ];
        };
        mk-type-check = luarc:
          git-hooks.lib.${system}.run {
            src = self;
            hooks = {
              lua-ls = {
                enable = true;
                settings.configuration = luarc;
              };
            };
          };

        type-check-nightly = mk-type-check luarc;
        pre-commit-check = git-hooks.lib.${system}.run {
          src = self;
          hooks = {
            alejandra.enable = true;
            stylua.enable = true;
            luacheck.enable = true;
            editorconfig-checker.enable = true;
          };
        };
      in {
        devShells.default = pkgs.integration-nightly.overrideAttrs (oa: {
          name = "rocks-dev.nvim devShell";
          shellHook = ''
            ${pre-commit-check.shellHook}
            ln -fs ${pkgs.luarc-to-json luarc} .luarc.json
          '';
          buildInputs =
            self.checks.${system}.pre-commit-check.enabledPackages
            ++ (with pkgs; [
              busted-nightly
              lua-language-server
            ])
            ++ oa.buildInputs;
          doCheck = false;
        });

        checks = {
          inherit
            pre-commit-check
            type-check-nightly
            ;
          inherit
            (pkgs)
            integration-stable
            integration-nightly
            ;
        };
      };
    };
}
