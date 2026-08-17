# omarchy-mac

An [Omarchy](https://github.com/basecamp/omarchy) port for macOS — for those of
us who want the Omarchy experience but can't (or won't) leave the Mac.

Omarchy is DHH's opinionated Arch + Hyprland setup. This repo recreates the
parts that matter on macOS with native tools:

| Omarchy piece | macOS stand-in | Config here |
|---|---|---|
| Hyprland (tiling WM) | [AeroSpace](https://github.com/nikitabobko/AeroSpace) | `aerospace/` |
| Waybar | [SketchyBar](https://github.com/FelixKratz/SketchyBar) | `sketchybar/` |
| Window borders | [JankyBorders](https://github.com/FelixKratz/JankyBorders) | `borders/` |
| Keybindings / menus | [Hammerspoon](https://www.hammerspoon.org) | `hammerspoon/` |
| Omarchy themes | `theme` script (syncs from basecamp/omarchy) | `bin/theme` |
| Prompt | [Starship](https://starship.rs) | `starship/` |

The `theme` script is the centerpiece: `theme --sync` pulls every theme
straight from the Omarchy repo and converts it for Ghostty, Neovim (LazyVim),
and btop. `theme random` respects macOS light/dark appearance, and a launchd
listener re-themes everything the instant the system flips appearance.

## Prerequisites

```sh
brew install --cask aerospace ghostty hammerspoon
brew install sketchybar borders starship btop neovim
```

Neovim theming assumes [LazyVim](https://www.lazyvim.org) (themes are written
to `~/.config/nvim/lua/plugins/theme.lua`).

## Install

Clone, then symlink what you want:

```sh
git clone https://github.com/dividendsolo/omarchy-mac.git ~/code/omarchy-mac
D=~/code/omarchy-mac

# Window manager / bar / borders
ln -s "$D/aerospace/aerospace.toml" ~/.aerospace.toml
ln -s "$D/sketchybar" ~/.config/sketchybar
ln -s "$D/borders" ~/.config/borders

# Prompt
ln -s "$D/starship/starship.toml" ~/.config/starship.toml

# Hammerspoon (keybindings overlay, Omarchy menu, theme chooser)
mkdir -p ~/.hammerspoon
ln -s "$D/hammerspoon/init.lua" ~/.hammerspoon/init.lua

# Scripts
mkdir -p ~/.local/bin
for f in theme omarchy-system-menu omarchy-cycle-wallpaper omarchy-notice theme-appearance-watch; do
  ln -s "$D/bin/$f" ~/.local/bin/$f
done

# Pull the Omarchy themes
theme --sync
theme tokyo-night
```

Then start the services:

```sh
brew services start sketchybar
brew services start borders
open -a Hammerspoon    # grant Accessibility when asked
```

### Auto-theming on light/dark flip (optional)

A tiny resident Swift listener reacts to `AppleInterfaceThemeChangedNotification`
and switches to a random theme matching the new appearance:

```sh
swiftc -O -o ~/.local/bin/theme-appearance-listener bin/theme-appearance-listener.swift
sed "s|/Users/YOU|$HOME|g" launchd/com.omarchy-mac.theme-appearance.plist \
  > ~/Library/LaunchAgents/com.omarchy-mac.theme-appearance.plist
launchctl load ~/Library/LaunchAgents/com.omarchy-mac.theme-appearance.plist
```

### AeroSpace crash watchdog (optional, recommended on macOS 26)

AeroSpace can self-terminate on macOS Tahoe. This launchd agent starts it at
login and relaunches it only on a crash (a clean quit is respected):

```sh
sed "s|/Users/YOU|$HOME|g" launchd/com.omarchy-mac.aerospace-keepalive.plist \
  > ~/Library/LaunchAgents/com.omarchy-mac.aerospace-keepalive.plist
launchctl load ~/Library/LaunchAgents/com.omarchy-mac.aerospace-keepalive.plist
```

Disable AeroSpace's own "start at login" if you use this.

## Wallpapers

`omarchy-cycle-wallpaper` (⌘⌃P) cycles images in `~/Pictures/Wallpapers`.
Name files `<theme>_*.jpg` to scope them to a theme (e.g. `tokyo-night_1.jpg`);
unprefixed files act as a shared pool. Wallpapers are not bundled — bring your
own or grab Omarchy's from the [omarchy repo](https://github.com/basecamp/omarchy).

## Keybindings

Press **⌥K** for the searchable overlay. Highlights:

- **⌘⌥Space** — Omarchy system menu
- **⌘⌃⇧Space** — theme chooser
- **⌘⌃P** — cycle wallpaper
- **⌘⌃⌥ T/W/B** — time / weather / battery notice

## How close is this to real Omarchy?

Honest answer, measured against **Omarchy v4.0.0** (2026-08-14): about **15%**
of the full project, or roughly **40%** of the day-to-day desktop feel.

Omarchy v4 ships 425 `omarchy-*` commands. A big share of them are an OS
installer, updater, and hardware layer that has no macOS equivalent and never
will here. This port goes after the part you live in — the look, the tiling,
the themes, the menus:

| Area | Status |
|---|---|
| Tiling WM + workspaces | ✅ AeroSpace stands in for Hyprland |
| Top bar | ✅ SketchyBar stands in for Waybar |
| Window borders | ✅ JankyBorders |
| Themes (terminal, editor, btop) | ✅ Synced live from the Omarchy repo, all of them |
| Auto light/dark theme switching | ✅ Instant, via a native listener (not in Omarchy itself) |
| Wallpaper cycling per theme | ✅ |
| System menu / keybinding overlay | ✅ Hammerspoon versions of omarchy-menu and the keybinding list |
| Weather / battery / time notices | ✅ |
| App launcher | ⚠️ Use Raycast or Spotlight; no walker port |
| Screenshots / screen recording / OCR capture | ❌ macOS has its own (⌘⇧5) |
| Webapps, voice typing (voxtype), agent tooling | ❌ |
| Installer, updates, migrations, hardware, Plymouth | ❌ Not applicable on macOS |

If a gap bothers you, open an issue — the daily-feel column is the roadmap.

## Credits

- [basecamp/omarchy](https://github.com/basecamp/omarchy) — the original, and
  the live source of every theme this port uses.
- AeroSpace, SketchyBar, JankyBorders, Hammerspoon, Starship — the projects
  doing the actual work.

## License

MIT
