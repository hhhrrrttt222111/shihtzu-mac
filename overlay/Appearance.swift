import Foundation

/// The dog's chosen look. Persisted as `key=value` lines in `Paths.config`.
struct Appearance {
    var coat = Coat.fallback
    var groom = Groom.fallback
    var accessory = Accessory.fallback

    /// Reads the config file; missing files, keys or unknown names fall back to the defaults.
    static func load(from path: String = Paths.config) -> Appearance {
        var appearance = Appearance()
        guard let text = try? String(contentsOfFile: path, encoding: .utf8) else { return appearance }
        for line in text.split(separator: "\n") {
            let pair = line.split(separator: "=", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
            guard pair.count == 2 else { continue }
            switch pair[0] {
            case "coat": appearance.coat = Coat.named(pair[1]) ?? appearance.coat
            case "groom": appearance.groom = Groom.named(pair[1]) ?? appearance.groom
            case "accessory": appearance.accessory = Accessory.named(pair[1]) ?? appearance.accessory
            default: break
            }
        }
        return appearance
    }
}
