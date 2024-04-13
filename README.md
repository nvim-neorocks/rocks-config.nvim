<!-- markdownlint-disable -->
<br />
<div align="center">
  <a href="https://github.com/nvim-neorocks/rocks-config.nvim">
    <img src="./rocks-header.svg" alt="rocks-config.nvim">
  </a>
  <p align="center">
    <!-- <br /> -->
    <!-- <a href="./doc/rocks-config.txt"><strong>Explore the docs »</strong></a> -->
    <!-- <br /> -->
    <br />
    <a href="https://github.com/nvim-neorocks/rocks-config.nvim/issues/new?assignees=&labels=bug">Report Bug</a>
    ·
    <a href="https://github.com/nvim-neorocks/rocks-config.nvim/issues/new?assignees=&labels=enhancement">Request Feature</a>
    ·
    <a href="https://github.com/nvim-neorocks/rocks.nvim/discussions/new?category=q-a">Ask Question</a>
  </p>
  <p>
    <strong>
      Allow <a href="https://github.com/nvim-neorocks/rocks.nvim/">rocks.nvim</a> to help configure your plugins!
    </strong>
  </p>
</div>
<!-- markdownlint-restore -->

[![LuaRocks][luarocks-shield]][luarocks-url]

## :star2: Summary

`rocks-config.nvim` extends [`rocks.nvim`](https://github.com/nvim-neorocks/rocks-config.nvim)
with the ability to configure your plugins.

## :hammer: Installation

Simply run `:Rocks install rocks-config.nvim`,
and you are good to go!

## :books: Usage

With this extension, you can add a `[config]` table to your `rocks.toml`,
for example:

```toml
[plugins]
"neorg" = "7.0.0"
"sweetie.nvim" = "1.0.0"

[config]
plugins_dir = "plugins/"
auto_setup = false
```

### Options

#### `plugins_dir`

The subdirectory (relative to `nvim/lua`, default: `plugins`)
to search for plugin configs. You can add a `lua/plugins/` directory
to your `nvim` config, with a lua script for each plugin.

```sh
── nvim
  ├── lua
  │  └── plugins # Your plugin configs go here.
  │     └── neorg.lua
  │     └── sweetie.lua # or sweetie-nvim.lua
  ├── init.lua
```

Upon startup, for each plugin in the `rocks.toml`'s `[plugins]`
table, this module will search for a matching config module in
and load it if one is found.

> [!NOTE]
>
> Possible config file names are:
>
> - The plugin's name (as long as it is a valid module name).
> - The plugin's name with the `.[n]vim` suffix removed[^1].
> - The plugin's name with the `[n]vim-` prefix removed[^2].
> - The plugin's name with `"-"` substituted for `"."`[^3].

[^1]: For example, a config file for a plugin called `foo.nvim` could be named `foo.lua`.
[^2]: For example, a config file for a plugin called `nvim-foo` could be named `foo.lua`.
[^3]: For example, a config file for a plugin called `foo.bar` could be named `foo-bar.lua`.

If you uninstall a plugin, you can leave its config (e.g. in case
you would like to reinstall it later), and it will not cause any
problems.

#### `<plugin>.config` - Adding basic configurations to rocks.toml

Many Neovim plugins require a call to a `setup` function,
which typically takes a configuration table.
If none of the configuration options are lua functions,
you can add the config to your rocks.toml, and this plugin
will automatically call `setup` with the plugin's options.

For example, the following lua configuration:

```lua
-- lua/plugins/lualine.lua
require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
  },
}
```

...can also be configured via rocks.toml:

```toml
# rocks.toml
[plugins.lualine.config]
options = { icons_enabled = true, theme = "auto" }
```

#### `auto_setup`

Some plugins that don't work without a `setup` call,
even if you are happy with the default options.
`rocks-config.nvim` provides a hack to work around this
with the `auto_setup` option (disabled by default).
If enabled, and no config is found for an installed plugin,
this module will attempt to call `require('<plugin-name>').setup()`
for you.

> [!WARNING]
>
> Enabling `auto_setup` could lead to unexpected behaviour.
> For example, if a plugin that doesn't need a `setup` call
> has configuration/initialization logic in its main module,
> it will be invoked with the call to `require`,
> potentially resulting in more eager initialization than necessary.

### Initialization order

rocks.nvim makes use of Neovim's built-in [initialization sequence](https://neovim.io/doc/user/starting.html#initialization),
and provides a hook that rocks-config.nvim uses to load configs
*before* any plugin scripts are sourced[^4].

[^4]: All plugins' lua APIs are available as soon as the snippet
from the rocks.nvim installer has been executed.

If you need to source a plugin's scripts eagerly (for example,
to load colorschemes), you can set the plugin's `opt = true` in
rocks.toml, and then load it with `vim.cmd.Rocks({"packadd", "<rock-name>"})` [^5]
or `require("rocks").packadd("<rock-name")`[^6].

[^5]: See `:h rocks.commands`
[^6]: See `:h rocks.lua`

## :book: License

`rocks-config.nvim` is licensed under [GPLv3](./LICENSE).

[luarocks-shield]: https://img.shields.io/luarocks/v/neorocks/rocks-config.nvim?logo=lua&color=purple&style=for-the-badge
[luarocks-url]: https://luarocks.org/modules/neorocks/rocks-config.nvim
