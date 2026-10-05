import AppKit

extension Breed {
    static let germanShepherd = Breed(
        key: "german-shepherd", title: "German Shepherd",
        anatomy: Anatomy(body: CGSize(width: 106, height: 48), leg: CGSize(width: 17, height: 26),
                         muzzle: CGSize(width: 28, height: 25), ears: .erect, tail: .bushy),
        coats: [
            .make("black-tan", "Black & Tan", fur: 0xC8924F, shade: 0xAD7A3C, patch: 0x2B2A2E, dark: 0x2B2A2E,
                  markings: [.saddle, .mask]),
            .make("sable", "Sable", fur: 0xA8793F, shade: 0x8E6430, patch: 0x4A3320, dark: 0x3A2814,
                  markings: [.saddle, .mask]),
            .make("black", "Solid Black", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0x201F22, dark: 0x19181B,
                  muzzle: 0x4A484E, markings: [.eyebrows]),
            .make("white", "White", fur: 0xF4EFE6, shade: 0xDDD5C6, patch: 0xE9E1D2, dark: 0xD8CFBE),
        ],
        grooms: [
            Groom(key: "natural", title: "Natural coat", head: CGSize(width: 62, height: 54),
                  ears: CGSize(width: 24, height: 32), cheeks: CGSize(width: 18, height: 15),
                  crown: .zero, bellyFluff: 0.5, tail: 1.1),
            Groom(key: "long", title: "Long coat", head: CGSize(width: 62, height: 54),
                  ears: CGSize(width: 24, height: 32), cheeks: CGSize(width: 26, height: 20),
                  crown: CGSize(width: 18, height: 8), bellyFluff: 1.3, tail: 1.35),
            Groom(key: "puppy", title: "Puppy", head: CGSize(width: 60, height: 52),
                  ears: CGSize(width: 28, height: 34), cheeks: CGSize(width: 16, height: 13),
                  crown: .zero, bellyFluff: 0.3, tail: 0.9),
        ])

    static let husky = Breed(
        key: "husky", title: "Siberian Husky",
        anatomy: Anatomy(body: CGSize(width: 100, height: 48), leg: CGSize(width: 17, height: 24),
                         muzzle: CGSize(width: 26, height: 19), ears: .erect, tail: .curl,
                         eyeColor: NSColor(hex: 0x4AA3DF)),
        coats: [
            .make("grey-white", "Grey & White", fur: 0xFFFAF2, shade: 0xE6DFD3, patch: 0x7F848E, dark: 0x5F636C,
                  markings: [.saddle, .eyePatches, .blaze, .socks]),
            .make("black-white", "Black & White", fur: 0xFFFAF2, shade: 0xE6DFD3, patch: 0x2B2A2E, dark: 0x1E1D21,
                  markings: [.saddle, .eyePatches, .blaze, .socks]),
            .make("red-white", "Red & White", fur: 0xFFFAF2, shade: 0xE6DFD3, patch: 0xB5602E, dark: 0x974D1E,
                  markings: [.saddle, .eyePatches, .blaze, .socks]),
            .make("white", "Pure White", fur: 0xFFFFFF, shade: 0xE8E4DC, patch: 0xF0ECE4, dark: 0xE2DDD3),
        ],
        grooms: [
            Groom(key: "natural", title: "Natural coat", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 20, height: 28), cheeks: CGSize(width: 24, height: 20),
                  crown: .zero, bellyFluff: 0.8, tail: 1.3),
            Groom(key: "fluffy", title: "Extra fluffy", head: CGSize(width: 64, height: 54),
                  ears: CGSize(width: 20, height: 28), cheeks: CGSize(width: 30, height: 24),
                  crown: CGSize(width: 22, height: 8), bellyFluff: 1.4, tail: 1.5),
            Groom(key: "puppy", title: "Puppy", head: CGSize(width: 62, height: 54),
                  ears: CGSize(width: 22, height: 26), cheeks: CGSize(width: 20, height: 16),
                  crown: .zero, bellyFluff: 0.5, tail: 1.0),
        ])

    static let corgi = Breed(
        key: "corgi", title: "Pembroke Corgi",
        anatomy: Anatomy(body: CGSize(width: 112, height: 44), leg: CGSize(width: 17, height: 15),
                         muzzle: CGSize(width: 24, height: 19), ears: .erect, tail: .nub),
        coats: [
            .make("red-white", "Red & White", fur: 0xE0954A, shade: 0xC47A32, patch: 0xC47A32, dark: 0xA8631F,
                  muzzle: 0xFFF6EA, accent: 0xFFF6EA, markings: [.blaze, .bib, .socks]),
            .make("fawn", "Fawn & White", fur: 0xE8C58A, shade: 0xD0A868, patch: 0xD4AE72, dark: 0xBE9558,
                  muzzle: 0xFFF6EA, accent: 0xFFF6EA, markings: [.blaze, .bib, .socks]),
            .make("sable", "Sable", fur: 0xB87333, shade: 0x9A5C22, patch: 0x8A4F1C, dark: 0x6E3C10,
                  muzzle: 0xFFF6EA, accent: 0xFFF6EA, markings: [.blaze, .bib, .socks]),
            .make("tricolor", "Tricolor", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0xC47A32, ear: 0x2B2A2E,
                  muzzle: 0xFFF6EA, accent: 0xFFF6EA, markings: [.eyebrows, .blaze, .bib, .socks]),
        ],
        grooms: [
            Groom(key: "natural", title: "Natural coat", head: CGSize(width: 64, height: 52),
                  ears: CGSize(width: 24, height: 34), cheeks: CGSize(width: 22, height: 18),
                  crown: .zero, bellyFluff: 0.7),
            Groom(key: "fluffy", title: "Fluffy coat", head: CGSize(width: 66, height: 54),
                  ears: CGSize(width: 24, height: 34), cheeks: CGSize(width: 28, height: 22),
                  crown: CGSize(width: 18, height: 8), bellyFluff: 1.3),
        ])

    static let borderCollie = Breed(
        key: "border-collie", title: "Border Collie",
        anatomy: Anatomy(body: CGSize(width: 100, height: 46), leg: CGSize(width: 17, height: 24),
                         muzzle: CGSize(width: 26, height: 20), ears: .folded, tail: .bushy),
        coats: [
            .make("black-white", "Black & White", fur: 0x2B2A2E, shade: 0x1E1D21, muzzle: 0x4A484E,
                  accent: 0xFFFAF2, markings: [.blaze, .bib, .socks]),
            .make("red-white", "Red & White", fur: 0x9E4A22, shade: 0x84391A, muzzle: 0xC07A50,
                  accent: 0xFFFAF2, markings: [.blaze, .bib, .socks]),
            .make("tricolor", "Tricolor", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0xC47A32, muzzle: 0x4A484E,
                  accent: 0xFFFAF2, markings: [.eyebrows, .blaze, .bib, .socks]),
            .make("blue-merle", "Blue Merle", fur: 0xA9AEB8, patch: 0x3A3A44, dark: 0x2F2F38,
                  accent: 0xFFFAF2, markings: [.spots, .blaze, .bib, .socks]),
        ],
        grooms: [
            Groom(key: "smooth", title: "Smooth coat", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 20, height: 28), cheeks: CGSize(width: 20, height: 16),
                  crown: .zero, bellyFluff: 0.6, tail: 1.1),
            Groom(key: "rough", title: "Rough coat", head: CGSize(width: 64, height: 54),
                  ears: CGSize(width: 20, height: 28), cheeks: CGSize(width: 26, height: 20),
                  crown: CGSize(width: 18, height: 10), bellyFluff: 1.3, tail: 1.4),
        ])
}
