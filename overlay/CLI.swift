import Foundation

/// One-shot commands that print or render something and exit without starting the overlay.
///
///     --list breed|coat|groom|accessory|size   key<TAB>title for every choice (coat/groom: current breed)
///     --show                                   the currently configured choices
///     --snapshot out.png                       every mood (optional: --breed K --coat K --groom K --accessory K --size K)
///     --gallery out.png                        every coat, groom and accessory of the breed
///     --breeds out.png                         every breed in its default look
enum CLI {
    private static let args = CommandLine.arguments

    private static func value(of flag: String) -> String? {
        guard let i = args.firstIndex(of: flag), i + 1 < args.count else { return nil }
        return args[i + 1]
    }

    /// The saved appearance with any `--breed/--coat/--groom/--accessory/--size` overrides applied.
    private static func appearance() -> Appearance {
        var a = Appearance.load()
        if let k = value(of: "--breed"), let v = Breed.all.named(k) { a.setBreed(v) }
        if let k = value(of: "--coat"), let v = a.breed.coats.named(k) { a.coat = v }
        if let k = value(of: "--groom"), let v = a.breed.grooms.named(k) { a.groom = v }
        if let k = value(of: "--accessory"), let v = Accessory.allCases.named(k) { a.accessory = v }
        if let k = value(of: "--size"), let v = Size.allCases.named(k) { a.size = v }
        return a
    }

    private static func printChoices<S: Sequence>(_ choices: S) where S.Element: Variant {
        for v in choices { print("\(v.key)\t\(v.title)") }
    }

    /// Runs the requested one-shot command and exits; returns if there is none.
    static func runIfRequested() {
        if let kind = value(of: "--list") {
            let a = appearance()
            switch kind {
            case "breed": printChoices(Breed.all)
            case "coat": printChoices(a.breed.coats)
            case "groom": printChoices(a.breed.grooms)
            case "accessory": printChoices(Accessory.allCases)
            case "size": printChoices(Size.allCases)
            default: exit(1)
            }
            exit(0)
        }
        if args.contains("--show") {
            let a = Appearance.load()
            print("breed=\(a.breed.key)\ncoat=\(a.coat.key)\ngroom=\(a.groom.key)\naccessory=\(a.accessory.key)\nsize=\(a.size.key)")
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
        if let path = value(of: "--breeds") {
            Snapshot.breeds(to: path, base: appearance())
            exit(0)
        }
    }
}
