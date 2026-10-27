![GitHub Release](https://img.shields.io/github/v/release/gaofengnan/neovim-debian)
![GitHub Release Date](https://img.shields.io/github/release-date/gaofengnan/neovim-debian)

# Neovim for Debian

This repository contains build scripts that produce **unofficial** Debian
packages (`.deb`) of the latest [Neovim](https://github.com/neovim/neovim)
release, hosted at [deb.gaofn.xyz](https://deb.gaofn.xyz).
This is a fork of [dariogriffo/neovim-debian](https://github.com/dariogriffo/neovim-debian) (MIT); the original packaging is by Dario Griffo.

The packages repackage the **official upstream prebuilt binary**
(`nvim-linux-x86_64.tar.gz`) — nothing is rebuilt from source — so Debian
**stable** users can get the newest Neovim the day it ships upstream, instead of
waiting for the next Debian release.

Currently served at deb.gaofn.xyz: Debian **Trixie** (amd64). The package itself is a
prebuilt upstream binary, so it is not tied to one suite, but only Trixie is published there.

## Packages

| Package | Arch | Contents |
| --- | --- | --- |
| `neovim` | amd64 | The stripped `nvim` binary and the tree-sitter parsers. Provides `/usr/bin/nvim` and the `editor` alternative. |
| `neovim-runtime` | all | The architecture-independent runtime (syntax, indent, colourschemes, standard plugins, docs, man page, desktop entry). |
| `neovim-unstripped` | amd64 | Optional: the same `nvim` binary with upstream debug symbols kept, for backtraces/debugging. |

These use the same names as Debian's own Neovim packages, so apt simply picks
whichever version is newer — normally the one from this repository, since it
tracks upstream releases directly. To make that explicit, pin the repo:

```sh
sudo tee /etc/apt/preferences.d/deb.gaofn.xyz-neovim > /dev/null << 'EOF'
Package: neovim neovim-runtime neovim-unstripped
Pin: origin deb.gaofn.xyz
Pin-Priority: 1001
EOF
```

### Coming from `neovim-latest`

These packages were previously published as `neovim-latest`,
`neovim-latest-runtime` and `neovim-latest-unstripped`. The new packages
`Provides`/`Conflicts`/`Replaces` the old names, so `apt update && apt install
neovim` transitions cleanly and removes the old ones. Nothing else changes —
the command is still `nvim` and your configuration is untouched.

## Install / Update

### The Debian way (apt)

```sh
sudo install -d -m 0755 /etc/apt/keyrings
sudo curl -fsSL https://deb.gaofn.xyz/deb.gaofn.xyz.gpg -o /etc/apt/keyrings/deb.gaofn.xyz.gpg
sudo curl -fsSL https://deb.gaofn.xyz/deb.gaofn.xyz.sources -o /etc/apt/sources.list.d/deb.gaofn.xyz.sources
sudo apt update
sudo apt install neovim
```

Optionally install the debug-symbol variant alongside and switch between them:

```sh
sudo apt install neovim-unstripped
sudo update-alternatives --config nvim
```

### Manual installation

1. Download the `.deb` files for your Debian suite from the
   [Releases](https://github.com/gaofengnan/neovim-debian/releases) page
   (`neovim-runtime` + `neovim`).
2. Install them:

```sh
sudo dpkg -i neovim-runtime_*.deb neovim_*.deb
```

## Updating

Just re-run any install method above; the package will be upgraded in place.
There is no need to uninstall the previous version.

## Building locally

Requires Docker (for the binary packages) and `dpkg-dev`/`devscripts` (for the
source packages):

```sh
./build_neovim_debian.sh 0.12.4 1   # -> ./out/*.deb
./build_src.sh           0.12.4 1   # -> *.dsc / *.orig.tar.gz / *.debian.tar.xz
```

## How releases work

A scheduled workflow (`check-upstream.yml`) compares the latest upstream Neovim
release against the latest release published here and, when they differ,
dispatches `release.yml`, which validates the upstream licence, builds all
packages for every suite, and publishes a GitHub Release.

## Disclaimer

- This is an unofficial community packaging project. For Neovim itself, see
  [neovim/neovim](https://github.com/neovim/neovim).
- This repo is not for Neovim bug reports — only for the Debian packaging.
- Inspired by the packaging approach of
  [bun-debian](https://github.com/dariogriffo/bun-debian).
