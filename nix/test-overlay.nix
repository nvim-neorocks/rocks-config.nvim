{self}: final: prev: let
  mkNeorocksTest = name: nvim:
    with final;
      neorocksTest {
        inherit name;
        pname = "rocks-config.nvim";
        src = self;
        neovim = nvim;
        luaPackages = ps:
          with ps; [
            rocks-nvim
          ];

        extraPackages = [
          wget
          git
          cacert
        ];

        preCheck = ''
          # Neovim expects to be able to create log files, etc.
          export HOME=$(realpath .)
        '';
      };
in {
  integration-stable = mkNeorocksTest "integration-stable" final.neovim;
  integration-nightly = mkNeorocksTest "integration-nightly" final.neovim-nightly;
}
