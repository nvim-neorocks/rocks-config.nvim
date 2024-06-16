{self}: final: prev: let
  luaPackage-override = luaself: luaprev: {
    rocks-config-nvim = luaself.callPackage ({
      luaOlder,
      buildLuarocksPackage,
      lua,
      rocks-nvim,
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
  lua5_1 = prev.lua5_1.override {
    packageOverrides = luaPackage-override;
  };
  lua51Packages = final.lua5_1.pkgs;
in {
  inherit
    lua5_1
    lua51Packages
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
