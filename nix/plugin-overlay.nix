{
  self,
  inputs,
}: final: prev: let
  rocks-nvim = inputs.rocks-nvim-input.packages.${final.system}.rocks-nvim;
  luaPackage-override = luaself: luaprev: {
    rocks-config-nvim = luaself.callPackage ({
      luaOlder,
      buildLuarocksPackage,
      lua,
    }:
      buildLuarocksPackage {
        pname = "rocks-config.nvim";
        version = "scm-1";
        knownRockspec = "${self}/rocks-config.nvim-scm-1.rockspec";
        src = self;
        disabled = luaOlder "5.1";
        propagatedBuildInputs = [
          rocks-nvim
        ];
      }) {};
  };
  luajit = prev.luajit.override {
    packageOverrides = luaPackage-override;
  };
  luajitPackages = final.luajit.pkgs;
in {
  inherit
    luajit
    luajitPackages
    ;

  vimPlugins =
    prev.vimPlugins
    // {
      rocks-config-nvim = final.neovimUtils.buildNeovimPlugin {
        pname = "rocks-config.nvim";
        version = "dev";
        src = self;
      };
    };
}
