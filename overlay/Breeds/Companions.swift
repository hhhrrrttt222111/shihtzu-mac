import AppKit

extension Breed {
    static let dachshund = Breed(
        key: "dachshund", title: "Dachshund",
        anatomy: Anatomy(body: CGSize(width: 120, height: 38), leg: CGSize(width: 15, height: 12),
                         muzzle: CGSize(width: 30, height: 21), tail: .straight),
        coats: [
            .make("red", "Red", fur: 0xB5602E, shade: 0x9A4C20, patch: 0x8F3F18, dark: 0x7A3410, muzzle: 0xD08850),
            .make("black-tan", "Black & Tan", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0xC47A32, ear: 0x2B2A2E,
                  muzzle: 0xC47A32, markings: [.eyebrows]),
            .make("chocolate-tan", "Chocolate & Tan", fur: 0x5E3A28, patch: 0xC98B52, ear: 0x5E3A28,
                  muzzle: 0xC98B52, markings: [.eyebrows]),
            .make("cream", "Cream", fur: 0xE8C58A, patch: 0xD0A868, dark: 0xBE9558, muzzle: 0xF2DDB0),
            .make("dapple", "Dapple", fur: 0x8B5A3C, patch: 0xE5C9A0, dark: 0xD0B088, markings: [.spots]),
        ],
        grooms: [
            Groom(key: "smooth", title: "Smooth coat", head: CGSize(width: 58, height: 48),
                  ears: CGSize(width: 22, height: 40), cheeks: CGSize(width: 16, height: 12),
                  crown: .zero, bellyFluff: 0),
            Groom(key: "longhair", title: "Longhaired", head: CGSize(width: 60, height: 50),
                  ears: CGSize(width: 26, height: 46), cheeks: CGSize(width: 22, height: 18),
                  crown: CGSize(width: 16, height: 8), bellyFluff: 1.5, tail: 1.4),
        ])

    static let beagle = Breed(
        key: "beagle", title: "Beagle",
        anatomy: Anatomy(body: CGSize(width: 100, height: 46), leg: CGSize(width: 17, height: 22),
                         muzzle: CGSize(width: 28, height: 21), tail: .straight),
        coats: [
            .make("tricolor", "Tricolor", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0xC47A32, dark: 0x2B2A2E,
                  ear: 0x8B5A3C, markings: [.saddle, .blaze]),
            .make("lemon", "Lemon & White", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0xE8C58A, dark: 0xD4AE72,
                  ear: 0xE0B880, markings: [.saddle, .blaze]),
            .make("red-white", "Red & White", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0xC4713A, dark: 0xA85A28,
                  ear: 0xA0501F, markings: [.saddle, .blaze]),
        ],
        grooms: [
            Groom(key: "natural", title: "Natural coat", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 24, height: 40), cheeks: CGSize(width: 18, height: 15),
                  crown: .zero, bellyFluff: 0),
            Groom(key: "puppy", title: "Puppy", head: CGSize(width: 64, height: 54),
                  ears: CGSize(width: 22, height: 34), cheeks: CGSize(width: 20, height: 16),
                  crown: .zero, bellyFluff: 0, tail: 0.9),
        ])

    static let pug = Breed(
        key: "pug", title: "Pug",
        anatomy: Anatomy(body: CGSize(width: 88, height: 50), leg: CGSize(width: 18, height: 20),
                         muzzle: CGSize(width: 26, height: 18), tail: .curl),
        coats: [
            .make("fawn", "Fawn", fur: 0xE9C48F, shade: 0xD3A86C, patch: 0x2B2A2E, dark: 0x2B2A2E,
                  markings: [.mask]),
            .make("black", "Black", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0x201F22, dark: 0x19181B,
                  muzzle: 0x4A484E),
            .make("apricot", "Apricot", fur: 0xE8A872, shade: 0xD08C54, patch: 0x3A2A22, dark: 0x3A2A22,
                  markings: [.mask]),
            .make("silver", "Silver", fur: 0xCFC9C0, shade: 0xB4AEA4, patch: 0x2B2A2E, dark: 0x2B2A2E,
                  markings: [.mask]),
        ],
        grooms: [
            Groom(key: "classic", title: "Classic", head: CGSize(width: 72, height: 60),
                  ears: CGSize(width: 18, height: 22), cheeks: CGSize(width: 26, height: 20),
                  crown: .zero, bellyFluff: 0),
        ])

    static let pomeranian = Breed(
        key: "pomeranian", title: "Pomeranian",
        anatomy: Anatomy(body: CGSize(width: 82, height: 44), leg: CGSize(width: 15, height: 20),
                         muzzle: CGSize(width: 20, height: 15), ears: .rounded, tail: .pom),
        coats: [
            .make("orange", "Orange", fur: 0xE8913A, shade: 0xC9762A, patch: 0xC9762A, dark: 0xA85F1C,
                  muzzle: 0xF2C890),
            .make("cream", "Cream", fur: 0xF4DDB0, patch: 0xE2C890, dark: 0xCFB478),
            .make("black", "Black", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0x232226, dark: 0x1B1A1D,
                  muzzle: 0x4A484E),
            .make("white", "White", fur: 0xFBF8F3, shade: 0xE6DFD3, patch: 0xEDE5D8, dark: 0xE0D6C6),
            .make("sable", "Sable", fur: 0xC98B52, shade: 0xAC723C, patch: 0x5A3A28, dark: 0x3A2A1E,
                  muzzle: 0xE0B888),
            .make("parti", "Orange & White", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0xE8913A, dark: 0xC9762A,
                  markings: [.saddle, .eyePatches, .blaze]),
        ],
        grooms: [
            Groom(key: "fluffy", title: "Fluffy ball", head: CGSize(width: 64, height: 54),
                  ears: CGSize(width: 15, height: 17), cheeks: CGSize(width: 30, height: 24),
                  crown: CGSize(width: 34, height: 16), bellyFluff: 1.6, tail: 1.2),
            Groom(key: "teddy", title: "Teddy-bear cut", head: CGSize(width: 66, height: 58),
                  ears: CGSize(width: 15, height: 17), cheeks: CGSize(width: 30, height: 26),
                  crown: CGSize(width: 28, height: 12), bellyFluff: 0.8, tail: 1.0),
            Groom(key: "lion", title: "Lion cut", head: CGSize(width: 58, height: 50),
                  ears: CGSize(width: 14, height: 16), cheeks: CGSize(width: 16, height: 13),
                  crown: .zero, mane: true, bellyFluff: 0, tail: 1.2),
        ])

    static let dalmatian = Breed(
        key: "dalmatian", title: "Dalmatian",
        anatomy: Anatomy(body: CGSize(width: 102, height: 46), leg: CGSize(width: 17, height: 25),
                         muzzle: CGSize(width: 26, height: 20), tail: .straight),
        coats: [
            .make("black-spots", "Black Spots", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0x2B2A2E, dark: 0x2B2A2E,
                  markings: [.spots]),
            .make("liver-spots", "Liver Spots", fur: 0xFFFAF2, shade: 0xEBDECC, patch: 0x6B3A2A, dark: 0x5A2E20,
                  markings: [.spots]),
        ],
        grooms: [
            Groom(key: "classic", title: "Classic", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 20, height: 30), cheeks: CGSize(width: 18, height: 15),
                  crown: .zero, bellyFluff: 0),
        ])
}
