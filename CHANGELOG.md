# Changelog

All notable changes to this module are documented here. The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/) and versions follow [Semantic Versioning](https://semver.org/).

## [v0.2.2] - 2026-09-05

### Added

- terraform-docs-generated interface documentation in README (Requirements/Providers/Inputs/Outputs) with a CI drift check

## [v0.2.1] - 2026-09-05

### Added

- CHANGELOG.md

## [v0.2.0] - 2026-09-04

### Added

- CI and release workflows
- `.tflint.hcl` configuration
- MIT LICENSE
- README badges
- Example terraform block
- Committed lock files

### Changed

- AWS provider constraint: `>= 5.0, < 7.0`
- Default Lambda runtime: `nodejs20.x` -> `nodejs22.x`

> Historical releases are documented in [GitHub Releases](https://github.com/pomo-studio/terraform-aws-ssr-lambda/releases).
