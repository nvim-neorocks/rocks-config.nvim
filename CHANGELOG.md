# Changelog

## [2.1.3](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v2.1.2...v2.1.3) (2024-07-05)


### Bug Fixes

* allow extensions like rocks-lazy to hook into loading ([#56](https://github.com/nvim-neorocks/rocks-config.nvim/issues/56)) ([778c6a7](https://github.com/nvim-neorocks/rocks-config.nvim/commit/778c6a7b64492ca9905066bfa1aba420d70980da))

## [2.1.2](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v2.1.1...v2.1.2) (2024-07-02)


### Bug Fixes

* **deps:** bump rocks.nvim minimum version constraint ([#54](https://github.com/nvim-neorocks/rocks-config.nvim/issues/54)) ([16f5283](https://github.com/nvim-neorocks/rocks-config.nvim/commit/16f52838bdf0e43a37ae73eae2be573c954ff925))

## [2.1.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v2.1.0...v2.1.1) (2024-06-25)


### Bug Fixes

* attempt to index `nil` if `[rocks]` is not set. ([#50](https://github.com/nvim-neorocks/rocks-config.nvim/issues/50)) ([c4527e0](https://github.com/nvim-neorocks/rocks-config.nvim/commit/c4527e021a9b95ae2fed7b93bed36bb5c8e6b81c)), closes [#49](https://github.com/nvim-neorocks/rocks-config.nvim/issues/49)

## [2.1.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v2.0.1...v2.1.0) (2024-06-25)


### Features

* support new rocks.nvim preload hook API ([#44](https://github.com/nvim-neorocks/rocks-config.nvim/issues/44)) ([5bc99e9](https://github.com/nvim-neorocks/rocks-config.nvim/commit/5bc99e924ecf41c1054e3661f29216d27642e471))

## [2.0.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v2.0.0...v2.0.1) (2024-06-25)


### Bug Fixes

* **health:** broken health check ([#46](https://github.com/nvim-neorocks/rocks-config.nvim/issues/46)) ([95135fa](https://github.com/nvim-neorocks/rocks-config.nvim/commit/95135faa11e47718e4423b73424cf6afaff77c40))

## [2.0.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.6.0...v2.0.0) (2024-06-19)


### ⚠ BREAKING CHANGES

* support lazy-loading plugin configs

### Features

* support lazy-loading plugin configs ([e872069](https://github.com/nvim-neorocks/rocks-config.nvim/commit/e872069d5af89a25ec4dc44a185c4dcc6b16c17d))

## [1.6.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.5.0...v1.6.0) (2024-05-18)


### Features

* add plugin bundles ([5a35dd2](https://github.com/nvim-neorocks/rocks-config.nvim/commit/5a35dd20a261a1fae0879cfcc624bf2122ec3335))


### Bug Fixes

* put bundles under separate namespace, allow `config` to also take a string, make bundles nested tables instead of a list ([1ec13ab](https://github.com/nvim-neorocks/rocks-config.nvim/commit/1ec13ab2831343993387f9b1d0a224d0b508b5f0))
* show error when a bundle has an invalid plugin ([ec975bf](https://github.com/nvim-neorocks/rocks-config.nvim/commit/ec975bf19499830cdb1bf0a7a826dfe5788acd45))

## [1.5.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.4.0...v1.5.0) (2024-04-19)


### Features

* allow `config = false` in `rocks.toml` ([7a3f813](https://github.com/nvim-neorocks/rocks-config.nvim/commit/7a3f813da7913b0aa92615e5ec221c5faec9306b))
* avoid crashing and log errors ([#34](https://github.com/nvim-neorocks/rocks-config.nvim/issues/34)) ([0f1183a](https://github.com/nvim-neorocks/rocks-config.nvim/commit/0f1183a510a255f64ed2c519476bf44c300d5bd1))
* detect duplicate configs and warn user ([#33](https://github.com/nvim-neorocks/rocks-config.nvim/issues/33)) ([d66b808](https://github.com/nvim-neorocks/rocks-config.nvim/commit/d66b8080e356ede8af98affde8899d88ac8dda1f))

## [1.4.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.3.1...v1.4.0) (2024-04-09)


### Features

* add `options` table ([51dfc03](https://github.com/nvim-neorocks/rocks-config.nvim/commit/51dfc03b80e8f246c9d9c295cd7f74f7ec26de30))


### Bug Fixes

* avoid loading configs twice ([#30](https://github.com/nvim-neorocks/rocks-config.nvim/issues/30)) ([d787b88](https://github.com/nvim-neorocks/rocks-config.nvim/commit/d787b88facf1cbabb4b274319da386946dd795ac))
* set options before setting plugin configurations ([024ad6b](https://github.com/nvim-neorocks/rocks-config.nvim/commit/024ad6bdaba3edc795c5bfbfc38233ea33015be6))

## [1.3.1](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.3.0...v1.3.1) (2024-04-06)


### Bug Fixes

* use all `package.loaders` to search for configs ([#24](https://github.com/nvim-neorocks/rocks-config.nvim/issues/24)) ([bd0adcd](https://github.com/nvim-neorocks/rocks-config.nvim/commit/bd0adcd550b7ccc194bba5a31b4c72601226492c))

## [1.3.0](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.2.3...v1.3.0) (2024-04-06)


### Features

* add `-` as a substitution for `.` to plugin heuristics ([91845e1](https://github.com/nvim-neorocks/rocks-config.nvim/commit/91845e1ca4ead1bff02bb1e6c4ba56d94909aefd))
* add `colorscheme` option ([88f2626](https://github.com/nvim-neorocks/rocks-config.nvim/commit/88f2626cb21ce5a25cf044c4f849172de001631b))


### Performance Improvements

* only search `package.preloaded` and `package.path` for configs ([110ffdd](https://github.com/nvim-neorocks/rocks-config.nvim/commit/110ffddecad84c63c90500d06c0fb854ea1e8e89))

## [1.2.3](https://github.com/nvim-neorocks/rocks-config.nvim/compare/v1.2.2...v1.2.3) (2024-03-20)


### Bug Fixes

* use new `rocks.hooks.preload` API to load configs ([#19](https://github.com/nvim-neorocks/rocks-config.nvim/issues/19)) ([5c45b74](https://github.com/nvim-neorocks/rocks-config.nvim/commit/5c45b743daaa3d719eaf641795692ced3d6c3cc0))

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
