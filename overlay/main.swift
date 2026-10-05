// Terminal Animals overlay — a shih tzu that lives along the bottom edge of the screen.
// A transparent, click-through window; the zsh plugin talks to it through an events file.
import AppKit

CLI.runIfRequested()

// Single instance: bail out if a live overlay already owns the pid file.
try? FileManager.default.createDirectory(atPath: Paths.runDir, withIntermediateDirectories: true)
if let s = try? String(contentsOfFile: Paths.pid, encoding: .utf8),
   let p = pid_t(s.trimmingCharacters(in: .whitespacesAndNewlines)),
   p != getpid(), kill(p, 0) == 0 {
    exit(0)
}

// Detach from the launching terminal so closing it doesn't kill the dog.
signal(SIGHUP, SIG_IGN)
_ = setsid()
try? String(getpid()).write(toFile: Paths.pid, atomically: true, encoding: .utf8)
if !FileManager.default.fileExists(atPath: Paths.events) {
    FileManager.default.createFile(atPath: Paths.events, contents: nil)
}

let app = NSApplication.shared
app.setActivationPolicy(.accessory)
let delegate = App()
app.delegate = delegate
app.run()
