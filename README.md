# zpm

## Lightweight package manager wrapper

zpm is a fast and simple package manager wrapper written in Lua.

It provides a clean CLI experience while using the system package manager underneath.

Current version: 0.0.3-alpha

License: GNU General Public License v3.0

---

## Features

- Multi-package installation
- Simple command interface
- Fast package operations
- Lua/LuaJIT based
- Native compiled binary support
- Debian support
- Termux support
- Dependency checks
- Verbose output mode
- JSON output mode

---

# Supported Platforms

## Debian

Debian support is now available.

zpm works with Debian-based systems using APT.

## Termux

Termux support is available.

---

# Installation

## Debian / Ubuntu

Install dependencies:

    sudo apt update

    sudo apt install \
    lua5.1 \
    luajit \
    libluajit-5.1-dev \
    luarocks \
    clang \
    make \
    git

Install luastatic:

    sudo luarocks install luastatic

Clone:

    git clone https://github.com/Shervin26-null/zpm-debian.git
    cd zpm-debian

Build:

    make

Install:

    sudo make install

---

# Usage

Install packages:

    zpm add nano git curl

Install multiple packages:

    zpm add nano git curl -y

Remove packages:

    zpm remove nano

Upgrade:

    zpm upgrade

Search:

    zpm search package

Information:

    zpm info package

---

# Building

Build:

    make

Clean:

    make clean

Install current build:

    sudo make install

---

# Status

zpm 0.0.3-alpha includes working Debian support.

The project is still alpha software and may change.

---

# License

GNU General Public License v3.0
