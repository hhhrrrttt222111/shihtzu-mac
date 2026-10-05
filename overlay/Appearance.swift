import Foundation

/// The dog's chosen look. Persisted as `key=value` lines in `Paths.config`.
/// Coat and groom belong to the breed, so an unknown or missing choice falls back to that breed's first.
struct Appearance {
    private(set) var breed: Breed
    var coat: Coat
    var groom: Groom
    var accessory = Accessory.fallback
    var size = Size.fallback

    init(breed: Breed = .fallback) {
        self.breed = breed
        coat = breed.coats[0]
        groom = breed.grooms[0]
    }

    /// Switches breed, resetting coat and groom to that breed's defaults.
    mutating func setBreed(_ newBreed: Breed) {
        breed = newBreed
        coat = newBreed.coats[0]
        groom = newBreed.grooms[0]
    }

    /// Reads the config file; missing files, keys or unknown names fall back to the defaults.
    static func load(from path: String = Paths.config) -> Appearance {
        var values: [String: String] = [:]
        if let text = try? String(contentsOfFile: path, encoding: .utf8) {
            for line in text.split(separator: "\n") {
                let pair = line.split(separator: "=", maxSplits: 1).map { $0.trimmingCharacters(in: .whitespaces) }
                if pair.count == 2 { values[pair[0]] = pair[1] }
            }
        }
        var appearance = Appearance(breed: Breed.all.named(values["breed"] ?? "") ?? .fallback)
        let breed = appearance.breed
        appearance.coat = breed.coats.named(values["coat"] ?? "") ?? breed.coats[0]
        appearance.groom = breed.grooms.named(values["groom"] ?? "") ?? breed.grooms[0]
        appearance.accessory = Accessory.allCases.named(values["accessory"] ?? "") ?? .fallback
        appearance.size = Size.allCases.named(values["size"] ?? "") ?? .fallback
        return appearance
    }
}
