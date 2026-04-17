# Nordic Cursors Scalable

> Cursors theme based on KDE Breeze Cursors using [Nord color palette](https://github.com/nordtheme/nord).
> Adapted from Nordic Cursors theme by [Eliver Lara](https://github.com/EliverLara/Nordic).

<p align="center">
  <img src="src/preview.png">
</p>

## Installing

### KDE Store

Install via _"Get new…"_ dialog in _System Settings_ > _Colors & Themes_ > _Cursors_
and search for _"Nordic Cursors Scalable"_.

### Manual

Download `nordic_cursors_scalable.tar.xz` from the 
[latest Release](https://github.com/Flachz/Nordic-Cursors-Scalable/releases/latest)
(or build it yourself with the instructions below).

Install via _"Install from file…"_ dialog in _System Settings_ > _Colors & Themes_ > _Cursors_.

Or manually extract the archive into `~/.local/share/icons/` or `~/.icons/`, for
example by running:

```sh
tar xf ~/Downloads/nordic_cursors_scalable.tar.xz -C ~/.local/share/icons
```

## Building

To build the theme `xcursorgen`, `inkscape` and `svgcleaner` packages are required. The
build script expects a GNU based system.

Run `build.sh` inside the project root directory. You may also set
`THREADS` env var to manually limit rendering threads, if not set
all available CPU threads will be used.
