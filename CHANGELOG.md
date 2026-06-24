# zpm 0.0.2-alpha

## Description

zpm is a lightweight package manager wrapper focused on simplicity, speed, and a clean CLI experience.

## Changes

### Added
- Improved command handling
- Cleaner CLI output
- More stable package operations

### Changed
- Removed the lock mechanism temporarily
  - The old lock system caused stale lock issues after interrupted processes
  - It will be redesigned and reintroduced properly in a future update

### Fixed
- Fixed build/runtime issues caused by lock handling
- Improved reliability during package operations

### Debian version

The Debian version of zpm is very close to completion.
It is being adapted separately for normal Debian-based systems with proper paths and packaging behavior.

## Notes

This is still an alpha release. Expect changes while the project stabilizes.
