# Bauti Tobal's dotfiles

In this repo you'll see my personal dotfiles! Feel free to PR or to Fork if you consider you could modify and improve something, It'll always be welcome!

## Dependencies

The commands below are historical setup notes, not a complete installer for the
current Hyprland, Niri and Plasma configuration. Dependencies, machine-specific
settings and deployment limitations still need to be resolved for a fresh install.

```bash
# Arch btw, needed dependencies
sudo pacman -S hyprland xdg-desktop-portal-hyprland xdg-desktop-portal-gtk \
waybar rofi-wayland kitty neovim brave grim slurp hyprshot wl-clipboard mako \
libnotify pipewire wireplumber pipewire-pulse playerctl brightnessctl \
ttf-jetbrains-mono-nerd ttf-font-awesome hyprlock hypridle wlogout cliphist \
stow jq
```
```bash
# could also be yay
paru -S hyprshot brave-bin
```

## Install this repo

1. Clone this repo
```bash
git clone https://github.com/bautitobal/dotfiles
```
2. Make a backup of your dots

```bash
cp -a ~/.config ~/.config.bak
```

Use a backup destination that does not already exist. This preserves symlinks;
it does not copy the contents of their external targets.

3. Make the symlinks

The examples below do not reproduce the complete current desktop. In particular,
files in `config/kde/` and `config/gtk2/` need individual links directly in
`~/.config/`, not a `kde/` or `gtk2/` subdirectory. Assets and `local/bin/` also
need separate deployment. `link-dotfiles.sh` currently skips top-level config
files such as `mimeapps.list` and replaces existing destination symlinks without
backing up those links. Review destinations before using any of these methods.

With stow

```bash
cd dotfiles/

stow -t ~/.config config

stow -t ~ home
```

Without stow (manual)

```bash
cd dotfiles/

ln -s ~/dotfiles/config/* ~/.config/

ln -s ~/dotfiles/home/.* ~/
```
4. Enjoy!

## Wallpapers
[Here.](https://github.com/bautitobal/wallpapers)

```bash
cp -r wallpapers ~/Pictures/
```

- Disclaimer: I DO NOT OWN ANY WALLPAPER, IT IS JUST A COLLECTION OF MY FAVORITES WALLPAPERS

## Credits
- [Waybar](https://github.com/Prateek7071/dotfiles) - Used as a startup point for my Waybar config.
- [Pomodoro module (from the Waybar to work)](https://github.com/Andeskjerf/waybar-module-pomodoro)
