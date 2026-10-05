import AppKit

final class DogView: NSView {
    let dog = Dog()
    override var isOpaque: Bool { false }
    override func draw(_ dirtyRect: NSRect) {
        guard let c = NSGraphicsContext.current?.cgContext else { return }
        c.clear(bounds)
        dog.draw(c)
        dog.drawParticles()
    }
}

/// A transparent, click-through window along the bottom of the screen. The zsh plugin drives it
/// by appending lines to the events file (`cmd <exit-code>`, `hide`, `show`, `reload`, `quit`).
final class App: NSObject, NSApplicationDelegate {
    var window: NSWindow!
    var view: DogView!
    var timer: Timer?
    var statusItem: NSStatusItem!
    var hideItem: NSMenuItem!
    var lastTick = CACurrentMediaTime()
    var frame = 0
    var offset: UInt64 = 0
    var hidden = false

    func applicationDidFinishLaunching(_ n: Notification) {
        window = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        window.isOpaque = false
        window.backgroundColor = .clear
        window.hasShadow = false
        window.ignoresMouseEvents = true
        window.level = .statusBar
        window.isReleasedWhenClosed = false
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .fullScreenAuxiliary, .ignoresCycle]
        view = DogView(frame: .zero)
        view.dog.appearance = .load()
        window.contentView = view
        layoutWindow()
        window.orderFrontRegardless()
        view.dog.x = window.frame.width * 0.5
        view.dog.pickNext(w: window.frame.width)

        NotificationCenter.default.addObserver(self, selector: #selector(layoutWindow),
                                               name: NSApplication.didChangeScreenParametersNotification, object: nil)

        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        statusItem.button?.title = "🐾"
        let menu = NSMenu()
        hideItem = NSMenuItem(title: "Hide dog", action: #selector(toggleHidden), keyEquivalent: "")
        hideItem.target = self
        menu.addItem(hideItem)
        let quit = NSMenuItem(title: "Quit Terminal Animals", action: #selector(quitApp), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        statusItem.menu = menu

        offset = (try? FileManager.default.attributesOfItem(atPath: Paths.events)[.size] as? UInt64 ?? 0) ?? 0

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30, repeats: true) { [weak self] _ in self?.tick() }
        RunLoop.main.add(timer!, forMode: .common)
    }

    @objc func layoutWindow() {
        guard let s = NSScreen.screens.first else { return }
        let vf = s.visibleFrame
        window.setFrame(NSRect(x: vf.minX, y: vf.minY, width: vf.width, height: 190), display: true)
        view.frame = NSRect(origin: .zero, size: window.frame.size)
    }

    @objc func toggleHidden() { setHidden(!hidden) }

    func setHidden(_ h: Bool) {
        hidden = h
        hideItem.title = h ? "Show dog" : "Hide dog"
        if h { window.orderOut(nil) } else { window.orderFrontRegardless() }
    }

    @objc func quitApp() {
        try? FileManager.default.removeItem(atPath: Paths.pid)
        NSApp.terminate(nil)
    }

    func tick() {
        let now = CACurrentMediaTime()
        let dt = CGFloat(min(0.1, now - lastTick))
        lastTick = now
        frame += 1
        if frame % 8 == 0 { pollEvents() }
        guard !hidden else { return }
        view.dog.update(dt, w: window.frame.width)
        // Sleeping dog only needs a gentle refresh rate.
        if view.dog.mood == .sleep && view.dog.parts.isEmpty && frame % 3 != 0 { return }
        view.needsDisplay = true
    }

    func pollEvents() {
        guard let fh = FileHandle(forReadingAtPath: Paths.events) else { return }
        defer { try? fh.close() }
        let size = (try? FileManager.default.attributesOfItem(atPath: Paths.events)[.size] as? UInt64 ?? 0) ?? 0
        if size < offset { offset = 0 }
        guard size > offset else { return }
        try? fh.seek(toOffset: offset)
        let data = fh.readDataToEndOfFile()
        offset = size
        guard let text = String(data: data, encoding: .utf8) else { return }
        for line in text.split(separator: "\n") { handle(String(line)) }
        if size > 65_536 { try? Data().write(to: URL(fileURLWithPath: Paths.events)); offset = 0 }
    }

    func handle(_ line: String) {
        let parts = line.split(separator: " ")
        switch parts.first {
        case "cmd": if !hidden { view.dog.react(ok: parts.count < 2 || parts[1] == "0") }
        case "reload":
            view.dog.appearance = .load()
            view.needsDisplay = true
        case "hide": setHidden(true)
        case "show": setHidden(false)
        case "quit": quitApp()
        default: break
        }
    }
}
