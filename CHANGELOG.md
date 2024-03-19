# Changelog

## [1.2.3](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.2.2...v1.2.3) (2024-03-19)


### Performance Improvements

* only search `package.preloaded` and `package.path` for configs ([30a37f0](https://github.com/nvim-neorocks/rocks-config.nvim/commit/30a37f0edce9cd0b139716cc86b00145630e3865))

## [1.2.2](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.2.1...v1.2.2) (2024-02-29)


### Bug Fixes

* run plugin configurations after the whole configuration has executed ([f9c46aa](https://github.com/nvim-neorocks/rocks-config.nvim/commit/f9c46aa27d7b2d43ab74fbc67d6c631200150b26))

## [1.2.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.2.0...v1.2.1) (2024-02-05)


### Bug Fixes

* **plugin:** prevent sourcing more than once ([cca36f3](https://github.com/nvim-neorocks/rocks-config.nvim/commit/cca36f3408e3e26ffaf2bf8ea966c65612b10a8f))

## [1.2.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.1.2...v1.2.0) (2023-12-18)


### Features

* add `config = { ... }` and `config = true` support for individual plugins ([f484247](https://github.com/nvim-neorocks/rocks-config.nvim/commit/f48424757aa1dd0f7bd01a5e085e905b86ab51a4))

## [1.1.2](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.1.1...v1.1.2) (2023-12-18)


### Bug Fixes

* don't run setup() function if it is invoked without correct parameters ([abb374c](https://github.com/nvim-neorocks/rocks-config.nvim/commit/abb374c76d0a91c4a22ed1222d97c70243ba10a0))
* ensure `user_configuration` is a table ([ec026f7](https://github.com/nvim-neorocks/rocks-config.nvim/commit/ec026f74ee563641b77a2e07d935ac080deb9e09))

## [1.1.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.1.0...v1.1.1) (2023-12-18)


### Bug Fixes

* setup() not found error ([a92809b](https://github.com/nvim-neorocks/rocks-config.nvim/commit/a92809bec557b2f9957a7a99a61af9f3f9bba954))

## [1.1.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.0.1...v1.1.0) (2023-12-18)


### Features

* add auto_setup option ([c298f1d](https://github.com/nvim-neorocks/rocks-config.nvim/commit/c298f1d9a625543ca44416e836e4a04277f53c6e))

## [1.0.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.0.0...v1.0.1) (2023-12-14)


### Bug Fixes

* proper heuristics match loop conditioning ([#2](https://github.com/nvim-neorocks/rocks-config.nvim/issues/2)) ([d21dcbb](https://github.com/nvim-neorocks/rocks-config.nvim/commit/d21dcbba098b70b38f415e9308198098af96db48))

## 1.0.0 (2023-12-12)


### Features

* initial commit ([5d6e75c](https://github.com/nvim-neorocks/rocks-config.nvim/commit/5d6e75ca913e99b28dcb059038e7412b7af4ee8f))
