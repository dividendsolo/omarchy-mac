// theme-appearance-listener — resident helper for com.omarchy-mac.theme-appearance.
// Subscribes to macOS's AppleInterfaceThemeChangedNotification and runs
// theme-appearance-watch the instant light/dark mode flips (no polling).
// Build: swiftc -O theme-appearance-listener.swift -o ~/.local/bin/theme-appearance-listener
import Foundation

let watcher = NSHomeDirectory() + "/.local/bin/theme-appearance-watch"

func runWatcher() {
    let p = Process()
    p.executableURL = URL(fileURLWithPath: "/bin/bash")
    p.arguments = [watcher]
    try? p.run()
}

// seed the stored mode on startup so the first real flip is detected
runWatcher()

DistributedNotificationCenter.default().addObserver(
    forName: NSNotification.Name("AppleInterfaceThemeChangedNotification"),
    object: nil, queue: nil
) { _ in runWatcher() }

// A flip that happens while the machine is asleep posts no notification we can
// catch, so the theme would sit on the wrong appearance until the next manual
// flip. The watcher compares theme-vs-system, so re-running it on wake repairs
// exactly that case and is a no-op otherwise.
DistributedNotificationCenter.default().addObserver(
    forName: NSNotification.Name("com.apple.screenIsUnlocked"),
    object: nil, queue: nil
) { _ in runWatcher() }

RunLoop.main.run()
