import AppKit

extension Breed {
    static let goldenRetriever = Breed(
        key: "golden-retriever", title: "Golden Retriever",
        anatomy: Anatomy(body: CGSize(width: 106, height: 50), leg: CGSize(width: 18, height: 25),
                         muzzle: CGSize(width: 30, height: 23)),
        coats: [
            .make("golden", "Golden", fur: 0xE0A94A, shade: 0xC48A2A, patch: 0xB87A22, dark: 0xA06A1C,
                  muzzle: 0xF0CC85),
            .make("light-golden", "Light Golden", fur: 0xF2DCA8, patch: 0xDDBE80, dark: 0xCBA96A, muzzle: 0xFAEBC8),
            .make("dark-golden", "Dark Golden", fur: 0xC47A2C, patch: 0xA2601E, dark: 0x8A5016, muzzle: 0xDDA060),
        ],
        grooms: [
            Groom(key: "natural", title: "Natural feathered coat", head: CGSize(width: 66, height: 56),
                  ears: CGSize(width: 24, height: 38), cheeks: CGSize(width: 22, height: 18),
                  crown: CGSize(width: 18, height: 8), bellyFluff: 1.2, tail: 1.4),
            Groom(key: "trimmed", title: "Summer trim", head: CGSize(width: 64, height: 54),
                  ears: CGSize(width: 22, height: 34), cheeks: CGSize(width: 16, height: 13),
                  crown: .zero, bellyFluff: 0.3, tail: 1.0),
            Groom(key: "puppy", title: "Fluffy puppy", head: CGSize(width: 68, height: 58),
                  ears: CGSize(width: 22, height: 30), cheeks: CGSize(width: 24, height: 20),
                  crown: CGSize(width: 20, height: 8), bellyFluff: 0.6, tail: 0.9),
        ])

    static let labrador = Breed(
        key: "labrador", title: "Labrador Retriever",
        anatomy: Anatomy(body: CGSize(width: 104, height: 50), leg: CGSize(width: 18, height: 25),
                         muzzle: CGSize(width: 30, height: 23), tail: .straight),
        coats: [
            .make("yellow", "Yellow", fur: 0xE9C77B, shade: 0xD3AC5C, patch: 0xD1A24F, dark: 0xBC8E3E,
                  muzzle: 0xF5E0A8),
            .make("black", "Black", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0x232226, dark: 0x1B1A1D, muzzle: 0x4A484E),
            .make("chocolate", "Chocolate", fur: 0x5E3A28, patch: 0x4A2C1D, dark: 0x3A2115, muzzle: 0x7D5440),
            .make("fox-red", "Fox Red", fur: 0xB8602A, patch: 0x974D1E, dark: 0x7E3E14, muzzle: 0xD08850),
            .make("silver", "Silver", fur: 0xBDB8B0, patch: 0xA19C95, dark: 0x8A857E, muzzle: 0xD6D2CB),
        ],
        grooms: [
            Groom(key: "classic", title: "Classic short coat", head: CGSize(width: 66, height: 56),
                  ears: CGSize(width: 22, height: 32), cheeks: CGSize(width: 18, height: 15),
                  crown: .zero, bellyFluff: 0),
            Groom(key: "chunky", title: "Chunky head", head: CGSize(width: 72, height: 60),
                  ears: CGSize(width: 24, height: 34), cheeks: CGSize(width: 24, height: 20),
                  crown: .zero, bellyFluff: 0),
            Groom(key: "puppy", title: "Puppy", head: CGSize(width: 68, height: 58),
                  ears: CGSize(width: 22, height: 28), cheeks: CGSize(width: 20, height: 16),
                  crown: .zero, bellyFluff: 0, tail: 0.9),
        ])
}
