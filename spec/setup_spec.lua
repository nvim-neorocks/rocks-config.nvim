local rocks_config = require("rocks-config.internal")

local tempdir = vim.fn.tempname()
vim.system({ "rm", "-r", tempdir }):wait()
vim.system({ "mkdir", "-p", tempdir .. "/lua/plugins" }):wait()
vim.g.rocks_nvim = {
    rocks_path = tempdir,
    config_path = vim.fs.joinpath(tempdir, "rocks.toml"),
}

describe("setup", function()
    it("Loads configs", function()
        local config_content = [[
[plugins]
"foo.nvim" = "1.0.0"
"bar.nvim" = "1.0.0"
]]
        local config = require("rocks.config.internal")
        local fh = assert(io.open(config.config_path, "w"), "Could not open rocks.toml for writing")
        fh:write(config_content)
        fh:close()
        local foo_config_content = [[
vim.g.foo_nvim_loaded = true
]]
        fh = assert(
            io.open(vim.fs.joinpath(tempdir, "lua", "plugins", "foo.lua"), "w"),
            "Could not open config file for writing"
        )
        fh:write(foo_config_content)
        fh:close()
        local bar_config_content = [[
vim.g.bar_nvim_loaded = true
]]
        fh = assert(
            io.open(vim.fs.joinpath(tempdir, "lua", "plugins", "bar-nvim.lua"), "w"),
            "Could not open config file for writing"
        )
        fh:write(bar_config_content)
        fh:close()
        vim.opt.runtimepath:append(tempdir)
        rocks_config.setup()
        assert.True(vim.g.foo_nvim_loaded)
        assert.True(vim.g.bar_nvim_loaded)
    end)
end)
