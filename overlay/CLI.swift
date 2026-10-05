import Foundation

/// One-shot commands that print or render something and exit without starting the overlay.
///
///     --list coat|groom|accessory   key<TAB>title for every choice
///     --show                        the currently configured coat/groom/accessory
///     --snapshot out.png            every mood      (optional: --coat K --groom K --accessory K)
///     --gallery out.png             every coat, groom and accessory
enum CLI {
    private static let args = CommandLine.arguments

    private static func value(of flag: String) -> String? {
        guard let i = args.firstIndex(of: flag), i + 1 < args.count else { return nil }
        return args[i + 1]
    }

    /// The saved appearance with any `--coat/--groom/--accessory` overrides applied.
    private static func appearance() -> Appearance {
        var a = Appearance.load()
        if let k = value(of: "--coat"), let v = Coat.named(k) { a.coat = v }
        if let k = value(of: "--groom"), let v = Groom.named(k) { a.groom = v }
        if let k = value(of: "--accessory"), let v = Accessory.named(k) { a.accessory = v }
        return a
    }

    private static func printChoices<V: Variant>(_ type: V.Type) {
        for v in type.all { print("\(v.key)\t\(v.title)") }
    }

    /// Runs the requested one-shot command and exits; returns if there is none.
    static func runIfRequested() {
        if let kind = value(of: "--list") {
            switch kind {
            case "coat": printChoices(Coat.self)
            case "groom": printChoices(Groom.self)
            case "accessory": printChoices(Accessory.self)
            default: exit(1)
            }
            exit(0)
        }
        if args.contains("--show") {
            let a = Appearance.load()
            print("coat=\(a.coat.key)\ngroom=\(a.groom.key)\naccessory=\(a.accessory.key)")
            exit(0)
        }
        if let path = value(of: "--snapshot") {
            Snapshot.moods(to: path, appearance: appearance())
            exit(0)
        }
        if let path = value(of: "--gallery") {
            Snapshot.gallery(to: path, base: appearance())
            exit(0)
        }
    }
}
