# Changelog

## [Unreleased]

## [3.0.1] - 2023-12-14
### Changed
- easy_patches are no longer deprecated - in core of ER we will use them because of order

## [3.0.0] - 2023-10-06
### Fixed
- uninstallation
### Added
- Zeitwerk compatibility
### Removed
- deprecations

## [2.0.4] - 2022-04-04
### Removed
- "assets" folder from rys generator

## [2.0.3] - 2021-09-22
### Fixed
- multi-tenant migrations

## [2.0.2] - 2021-09-10
### Added
- Use easy_style gem
- Ensure migrations (db & data) for all RYSy (= provide DSL)

## [2.0.1] - 2021-03-18
### Added
- Add supporting multiple db connections

## [2.0.0] - 2021-01-27
### Added
- Rails 6.1 compatibility
### Removed
- support for Rails 5 or lower

## [1.4.17] - 2020-07-10
- update .rubocop.yml

## [1.4.16] - 2020-07-09
### Fixed
- allow migration for systemic RYSy

## [1.4.15] - 2020-04-09
### Fixed
- Missing api directory in plugin templates
## [1.4.14] - 2020-04-09
### Added
- private methods can be controller via feature in patches
### Changed
- after_plugins migration are skipped if env NAME is given
- Generator - fix default repo url
### Fixed
- Plugin name with a dash
## [1.4.13] - 2020-02-28
### Added
- select Easy Redmine plugins that could be deactivated
## [1.4.12] - 2020-02-24
### Added
- check activation based on Easy Redmine plugins
## [1.4.10] - 2019-11-4
### Added
- apply_if_rysy to patcher
