// Shihtzu overlay — a shih tzu that lives along the bottom edge of the screen.
// A transparent, click-through window; the zsh plugin talks to it through an events file.
import AppKit

CLI.runIfRequested()

SingleInstance.claimOrExit()

// Detach from the launching terminal so closing it doesn't kill the dog.
signal(SIGHUP, SIG_IGN)
_ = setsid()
// The plugin uses the pid file to tell whether the overlay is running.
try? String(getpid()).write(toFile: Paths.pid, atomically: true, encoding: .utf8)
if !FileManager.default.fileExists(atPath: Paths.events) {
    FileManager.default.createFile(atPath: Paths.events, contents: nil)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = App()
app.delegate = delegate
app.run()
