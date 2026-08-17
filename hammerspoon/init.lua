-- Hammerspoon config — Omarchy-style keybindings overlay
-- Reload after edits: `hs -c 'hs.reload()'` from terminal, or use the menu icon.

-- Enable the `hs` CLI so we can reload/test from the terminal
require("hs.ipc")

----------------------------------------------------------------------
-- Keybindings shown in the popup (display only — actual bindings live
-- in ~/.aerospace.toml). cmd = SUPER in our setup.
----------------------------------------------------------------------
local bindings = {
  -- Launching
  { "SUPER + SPACE",            "Raycast" },
  { "ALT + RETURN",             "Ghostty (terminal)" },
  { "ALT + CMD + RETURN",       "Ghostty + tmux" },
  { "SUPER + SHIFT + RETURN",   "Brave" },
  { "SUPER + SHIFT + ALT + B",  "Brave (incognito)" },
  { "SUPER + ALT + C",          "Chrome" },
  { "SUPER + SHIFT + F",        "Finder" },
  { "SUPER + SHIFT + N",        "Ghostty + nvim" },
  { "SUPER + SHIFT + D",        "Ghostty + lazydocker" },
  { "SUPER + SHIFT + M",        "Spotify" },
  { "SUPER + SHIFT + A",        "Claude" },
  { "SUPER + SHIFT + O",        "Obsidian" },
  { "SUPER + SHIFT + W",        "Typora" },
  { "SUPER + SHIFT + G",        "Signal" },
  { "SUPER + SHIFT + ALT + G",  "WhatsApp" },
  { "SUPER + SHIFT + /",        "1Password" },
  { "SUPER + SHIFT + C",        "HEY Calendar" },
  { "SUPER + SHIFT + E",        "HEY Mail" },

  -- Window / layout
  { "ALT + W",                  "Quit app (sends ⌘Q)" },
  { "CTRL + ALT + BACKSPACE",   "Close all windows but current" },
  { "ALT + T",                  "Toggle floating / tiling" },
  { "ALT + J",                  "Toggle tiles horizontal / vertical" },
  { "ALT + F",                  "Fullscreen (tile)" },
  { "SUPER + CTRL + F",         "macOS native fullscreen" },

  -- Focus
  { "SUPER + LEFT / DOWN / UP / RIGHT",  "Focus window in direction" },
  { "SUPER + `",                "Cycle next window in workspace" },
  { "SUPER + SHIFT + `",        "Cycle prev window in workspace" },
  { "CTRL + ALT + TAB",         "Focus next monitor" },
  { "CTRL + ALT + SHIFT + TAB", "Focus prev monitor" },

  -- Move / swap
  { "SUPER + SHIFT + ←/↓/↑/→",  "Swap window in direction" },

  -- Workspaces
  { "ALT + 1..5",               "Switch to workspace N" },
  { "SUPER + SHIFT + 1..5",     "Move window to workspace N and follow" },
  { "SUPER + SHIFT + ALT + 1..5", "Move window to workspace N (stay)" },
  { "ALT + TAB",                "Back-and-forth between workspaces" },
  { "SUPER + SHIFT + ALT + ←/→/↑/↓", "Move workspace to prev/next monitor" },
  { "SUPER + CTRL + SHIFT + ←/↓/↑/→", "Move focused window across monitors" },

  -- Resize
  { "ALT + =",                  "Grow focused window" },
  { "ALT + -",                  "Shrink focused window" },

  -- System
  { "SUPER + CTRL + A",         "Sound settings" },
  { "SUPER + CTRL + B",         "Bluetooth settings" },
  { "SUPER + CTRL + W",         "Wi-Fi settings" },
  { "SUPER + CTRL + S",         "Sharing settings" },
  { "SUPER + CTRL + T",         "Activity (Ghostty + btop)" },
  { "ALT + SHIFT + T",          "Activity (Ghostty + btop)" },
  { "SUPER + CTRL + H",         "System Information" },
  { "SUPER + CTRL + .",         "HandBrake (transcoding)" },
  { "SUPER + CTRL + L",         "Lock screen" },
  { "SUPER + CTRL + I",         "Toggle caffeinate" },
  { "SUPER + CTRL + ,",         "Toggle Do Not Disturb" },
  { "SUPER + CTRL + C",         "Screenshot picker" },
  { "SUPER + CTRL + V",         "Raycast clipboard history" },
  { "SUPER + CTRL + P",         "Cycle wallpaper (~/Pictures/Wallpapers)" },
  { "SUPER + CTRL + G",         "Gaming mode (quit all Dock apps, launch Steam)" },
  { "SUPER + CTRL + ALT + T",   "Date & time toast" },
  { "SUPER + CTRL + ALT + W",   "Weather toast" },
  { "SUPER + CTRL + ALT + B",   "Battery toast" },
  { "SUPER + ESC",              "System menu (Lock/Sleep/Restart/…)" },

  -- Style
  { "SUPER + ALT + SPACE",      "Omarchy control menu" },
  { "SUPER + SHIFT + SPACE",    "Apps launcher (curated)" },
  { "SUPER + CTRL + SHIFT + SPACE", "Theme chooser" },
  { "OPT + T (Raycast)",        "Random theme (matches system light/dark)" },

  -- Service mode
  { "SUPER + SHIFT + ;",        "Enter service mode (R=flatten, F=float, esc=exit)" },

  -- Help
  { "ALT + K",                  "Show this keybindings overlay" },
}

----------------------------------------------------------------------
-- Tokyo Night palette
----------------------------------------------------------------------
local function hex(s)
  return { hex = s }
end

local COLORS = {
  bg       = hex("#1a1b26"),
  fg       = hex("#c0caf5"),
  blue     = hex("#7aa2f7"),
  magenta  = hex("#bb9af7"),
  comment  = hex("#565f89"),
}

----------------------------------------------------------------------
-- Build chooser
----------------------------------------------------------------------
local function showKeybindings()
  local choices = {}
  for _, b in ipairs(bindings) do
    table.insert(choices, {
      text    = b[1],
      subText = b[2],
    })
  end

  local chooser = hs.chooser.new(function(_) end)
  chooser:choices(choices)
  chooser:searchSubText(true)
  chooser:width(35)
  chooser:rows(12)
  chooser:bgDark(true)
  chooser:fgColor(COLORS.blue)
  chooser:subTextColor(COLORS.fg)
  chooser:placeholderText("Filter keybindings…")
  chooser:show()
end

----------------------------------------------------------------------
-- Hotkeys
----------------------------------------------------------------------
hs.hotkey.bind({"alt"}, "k", showKeybindings)

-- Run a shell script that prints "TITLE|||BODY" and show as notification
local function notifyFromScript(script)
  hs.task.new("/bin/bash", function(_, stdOut, _)
    local title, body = stdOut:match("^(.-)|||(.-)\n?$")
    if title then
      hs.notify.new({ title = title, informativeText = body, withdrawAfter = 5 }):send()
    end
  end, { "-lc", script }):start()
end

hs.hotkey.bind({"cmd", "ctrl", "alt"}, "t", function() notifyFromScript("~/.local/bin/omarchy-notice time")    end)
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "w", function() notifyFromScript("~/.local/bin/omarchy-notice weather") end)
hs.hotkey.bind({"cmd", "ctrl", "alt"}, "b", function() notifyFromScript("~/.local/bin/omarchy-notice battery") end)
hs.hotkey.bind({"cmd", "ctrl"},        "p", function() notifyFromScript("~/.local/bin/omarchy-cycle-wallpaper") end)
hs.hotkey.bind({"cmd", "ctrl"},        "g", function() notifyFromScript("~/.local/bin/gaming-mode") end)

----------------------------------------------------------------------
-- Forward declarations so mutually-referenced choosers can find each other
----------------------------------------------------------------------
local showAppsMenu, showThemeChooser, showOmarchyMenu

----------------------------------------------------------------------
-- Omarchy control menu (SUPER+ALT+SPACE)
----------------------------------------------------------------------
showOmarchyMenu = function()
  local items = {
    { text = "Apps",    subText = "Curated app launcher",
      action = function() showAppsMenu() end },
    { text = "Learn",   subText = "Open the Omarchy manual",
      action = function() hs.execute("open https://learn.omacom.io/2/the-omarchy-manual") end },
    { text = "Trigger", subText = "Show keybindings overlay",
      action = function() showKeybindings() end },
    { text = "Style",   subText = "Theme switcher",
      action = function() showThemeChooser() end },
    { text = "Setup",   subText = "Open System Settings",
      action = function() hs.application.launchOrFocus("System Settings") end },
    { text = "Install", subText = "Homebrew install guide (brew.sh)",
      action = function() hs.execute("open https://brew.sh") end },
    { text = "Remove",  subText = "Run `brew uninstall <pkg>` in your terminal",
      action = function() hs.alert.show("Use: brew uninstall <pkg>") end },
    { text = "Update",  subText = "Run brew update && brew upgrade in Ghostty",
      action = function() hs.execute([[open -na Ghostty --args -e bash -c "brew update && brew upgrade; echo; read -p 'Press enter to close'"]]) end },
    { text = "About",   subText = "Open System Information",
      action = function() hs.application.launchOrFocus("System Information") end },
    { text = "System",  subText = "Lock / Sleep / Restart / Shut Down / Log Out",
      action = function() hs.execute("~/.local/bin/omarchy-system-menu") end },
  }

  local choices = {}
  for i, item in ipairs(items) do
    table.insert(choices, { text = item.text, subText = item.subText, idx = i })
  end

  local chooser = hs.chooser.new(function(choice)
    if choice and items[choice.idx] then items[choice.idx].action() end
  end)
  chooser:choices(choices)
  chooser:width(25)
  chooser:rows(10)
  chooser:bgDark(true)
  chooser:fgColor(COLORS.blue)
  chooser:subTextColor(COLORS.fg)
  chooser:placeholderText("Go…")
  chooser:show()
end

hs.hotkey.bind({"cmd", "alt"}, "space", showOmarchyMenu)

----------------------------------------------------------------------
-- Theme chooser (SUPER+CTRL+SHIFT+SPACE)
----------------------------------------------------------------------
showThemeChooser = function()
  local cache = os.getenv("HOME") .. "/.config/theme-switcher/cache"
  local themes = {}
  local handle = io.popen("ls -1 " .. cache .. " 2>/dev/null | sort")
  if handle then
    for line in handle:lines() do table.insert(themes, line) end
    handle:close()
  end
  if #themes == 0 then
    hs.notify.new({title="Theme", informativeText="No themes cached. Run: theme --sync", withdrawAfter=5}):send()
    return
  end

  local current = ""
  local f = io.open(os.getenv("HOME") .. "/.config/theme-switcher/current", "r")
  if f then current = f:read("*line") or ""; f:close() end

  local choices = {}
  for _, name in ipairs(themes) do
    table.insert(choices, {
      text = name,
      subText = (name == current) and "● current" or "",
      themeName = name,
    })
  end

  local chooser = hs.chooser.new(function(choice)
    if choice then
      hs.task.new("/bin/bash", function()
        hs.notify.new({title="Theme", informativeText="Switched to " .. choice.themeName, withdrawAfter=3}):send()
      end, { "-lc", "~/.local/bin/theme " .. choice.themeName }):start()
    end
  end)
  chooser:choices(choices)
  chooser:width(20)
  chooser:rows(10)
  chooser:bgDark(true)
  chooser:fgColor(COLORS.blue)
  chooser:subTextColor(COLORS.fg)
  chooser:placeholderText("Pick a theme…")
  chooser:show()
end

hs.hotkey.bind({"cmd", "ctrl", "shift"}, "space", showThemeChooser)
hs.hotkey.bind({"cmd", "shift"}, "space", function() showAppsMenu() end)

----------------------------------------------------------------------
-- Apps chooser — curated launcher (called from Omarchy menu's "Apps")
----------------------------------------------------------------------
local apps = {
  { name = "1Password",        sub = "Passwords",         action = function() hs.application.launchOrFocus("1Password") end },
  { name = "Basecamp",         sub = "Web",               action = function() hs.execute("open https://3.basecamp.com") end },
  { name = "Bluetooth",        sub = "Settings",          action = function() hs.execute([[open "x-apple.systempreferences:com.apple.BluetoothSettings"]]) end },
  { name = "Brave",            sub = "Browser",           action = function() hs.application.launchOrFocus("Brave Browser") end },
  { name = "Calculator",       sub = "Math",              action = function() hs.application.launchOrFocus("Calculator") end },
  { name = "Chrome",           sub = "Browser",           action = function() hs.application.launchOrFocus("Google Chrome") end },
  { name = "Claude",           sub = "AI",                action = function() hs.application.launchOrFocus("Claude") end },
  { name = "Discord",          sub = "Comms",             action = function() hs.application.launchOrFocus("Discord") end },
  { name = "Docker",           sub = "Containers",        action = function() hs.application.launchOrFocus("Docker") end },
  { name = "Figma",            sub = "Web · figma.com",   action = function() hs.execute("open https://figma.com") end },
  { name = "Finder",           sub = "Files",             action = function() hs.application.launchOrFocus("Finder") end },
  { name = "Ghostty",          sub = "Terminal",          action = function() hs.execute("open -na Ghostty") end },
  { name = "Ghostty + nvim",   sub = "Editor",            action = function() hs.execute("open -na Ghostty --args -e nvim") end },
  { name = "GitHub",           sub = "Web · github.com",  action = function() hs.execute("open https://github.com") end },
  { name = "Google Contacts",  sub = "Web",               action = function() hs.execute("open https://contacts.google.com") end },
  { name = "Google Messages",  sub = "Brave web app",     action = function() hs.application.launchOrFocusByBundleID("com.brave.Browser.app.hpfldicfbfomlpcikngkocigghgafkph") end },
  { name = "Google Photos",    sub = "Web",               action = function() hs.execute("open https://photos.google.com") end },
  { name = "HEY (mail)",       sub = "Web",               action = function() hs.execute("open https://app.hey.com") end },
  { name = "HEY Calendar",     sub = "Web",               action = function() hs.execute("open https://app.hey.com/calendar") end },
  { name = "Lazygit",          sub = "Ghostty + lazygit", action = function() hs.execute("open -na Ghostty --args -e lazygit") end },
  { name = "LocalSend",        sub = "Cross-device file share", action = function() hs.application.launchOrFocus("LocalSend") end },
  { name = "mpv",              sub = "Media player",      action = function() hs.application.launchOrFocus("mpv") end },
  { name = "OBS Studio",       sub = "brew install --cask obs", action = function() hs.application.launchOrFocus("OBS") end },
  { name = "Obsidian",         sub = "Notes",             action = function() hs.application.launchOrFocus("Obsidian") end },
  { name = "Pinta",            sub = "Image editor",      action = function() hs.application.launchOrFocus("Pinta") end },
  { name = "Signal",           sub = "Comms",             action = function() hs.application.launchOrFocus("Signal") end },
  { name = "Slack",            sub = "Comms",             action = function() hs.application.launchOrFocus("Slack") end },
  { name = "Spotify",          sub = "Music",             action = function() hs.application.launchOrFocus("Spotify") end },
  { name = "System Settings",  sub = "macOS preferences", action = function() hs.application.launchOrFocus("System Settings") end },
  { name = "Typora",           sub = "Markdown",          action = function() hs.application.launchOrFocus("Typora") end },
  { name = "WhatsApp",         sub = "Comms",             action = function() hs.application.launchOrFocus("WhatsApp") end },
  { name = "X (Twitter)",      sub = "Brave web app",     action = function() hs.application.launchOrFocusByBundleID("com.brave.Browser.app.lodlkdfmihgonocnmddehnfgiljnadcf") end },
  { name = "YouTube",          sub = "Brave web app",     action = function() hs.application.launchOrFocusByBundleID("com.brave.Browser.app.agimnkijcaahngcdmfeangaknmldooml") end },
}

showAppsMenu = function()
  local choices = {}
  for i, app in ipairs(apps) do
    table.insert(choices, { text = app.name, subText = app.sub, idx = i })
  end
  local chooser = hs.chooser.new(function(choice)
    if choice and apps[choice.idx] then apps[choice.idx].action() end
  end)
  chooser:choices(choices)
  chooser:width(25)
  chooser:rows(12)
  chooser:bgDark(true)
  chooser:fgColor(COLORS.blue)
  chooser:subTextColor(COLORS.fg)
  chooser:placeholderText("Launch…")
  chooser:show()
end

-- Tell us the config reloaded
hs.alert.show("Hammerspoon: keybindings ready (⌥K)")
