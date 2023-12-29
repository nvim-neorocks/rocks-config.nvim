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
for example

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

If you uninstall a plugin, you can leave its config (e.g. in case
you would like to reinstall it later), and it will not cause any
problems.

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

## :book: License

`rocks-config.nvim` is licensed under [GPLv3](./LICENSE).

[luarocks-shield]: https://img.shields.io/luarocks/v/neorocks/rocks-config.nvim?logo=lua&color=purple&style=for-the-badge
[luarocks-url]: https://luarocks.org/modules/neorocks/rocks-config.nvim
