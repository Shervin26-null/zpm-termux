# zpm 0.0.4-alpha

## Added

New Debian package commands:

- `zpm list`
  - List installed packages

- `zpm outdated`
  - Show available upgrades

- `zpm autoremove`
  - Remove unused dependencies

- `zpm purge <pkg>`
  - Remove packages and configuration

- `zpm show <pkg>`
  - Show package information

- `zpm files <pkg>`
  - List package files

- `zpm which <file>`
  - Find which package owns a file

- `zpm depends <pkg>`
  - Show package dependencies

- `zpm rdepends <pkg>`
  - Show reverse dependencies

- `zpm hold <pkg>`
  - Hold package updates

- `zpm unhold <pkg>`
  - Allow package updates again

- `zpm manual <pkg>`
  - Mark package as manually installed

- `zpm auto <pkg>`
  - Mark package as automatically installed

- `zpm policy <pkg>`
  - Show package versions and repository priority

- `zpm check`
  - Check package database state

- `zpm source <pkg>`
  - Download package source

- `zpm cache-clean`
  - Clean apt cache

## Improved

- Improved Debian apt command integration
- Improved package transaction output
- Cleaner install/remove/upgrade UX

## Fixed

- Fixed command execution handling
- Fixed package operation flow
- Improved error reporting

