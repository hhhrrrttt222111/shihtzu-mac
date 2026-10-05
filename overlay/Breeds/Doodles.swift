import AppKit

extension Breed {
    static let poodle = Breed(
        key: "poodle", title: "Poodle",
        anatomy: Anatomy(body: CGSize(width: 90, height: 44), leg: CGSize(width: 15, height: 26),
                         muzzle: CGSize(width: 22, height: 20), tail: .pom, curly: true),
        coats: [
            .make("white", "White", fur: 0xFBF8F3, shade: 0xE6DFD3, patch: 0xEDE5D8, dark: 0xE0D6C6),
            .make("black", "Black", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0x232226, dark: 0x1B1A1D, muzzle: 0x4A484E),
            .make("apricot", "Apricot", fur: 0xE8A872, patch: 0xD58F55, dark: 0xC27A42),
            .make("cream", "Cream", fur: 0xF2DDB0, patch: 0xE2C890, dark: 0xCFB478),
            .make("red", "Red", fur: 0xB5532B, patch: 0x9A4220, dark: 0x823516),
            .make("silver", "Silver", fur: 0xB8BBC4, patch: 0x9EA2AD, dark: 0x868A96),
            .make("chocolate", "Chocolate", fur: 0x6B4430, patch: 0x56351F, dark: 0x452A18, muzzle: 0x8A6048),
            .make("parti", "Black & White Parti", fur: 0xFBF8F3, shade: 0xE6DFD3, patch: 0x2B2A2E, dark: 0x2B2A2E,
                  markings: [.saddle]),
        ],
        grooms: [
            Groom(key: "puppy", title: "Fluffy puppy cut", head: CGSize(width: 66, height: 56),
                  ears: CGSize(width: 22, height: 30), cheeks: CGSize(width: 28, height: 22),
                  crown: CGSize(width: 36, height: 22), bellyFluff: 0.8),
            Groom(key: "pompom", title: "Top-puff", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 22, height: 32), cheeks: CGSize(width: 24, height: 20),
                  crown: CGSize(width: 40, height: 34), bellyFluff: 0.6),
            Groom(key: "teddy", title: "Teddy-bear cut", head: CGSize(width: 72, height: 60),
                  ears: CGSize(width: 24, height: 28), cheeks: CGSize(width: 32, height: 26),
                  crown: CGSize(width: 40, height: 16), bellyFluff: 1.2),
            Groom(key: "show", title: "Show cut with mane", head: CGSize(width: 62, height: 52),
                  ears: CGSize(width: 22, height: 32), cheeks: CGSize(width: 22, height: 18),
                  crown: CGSize(width: 40, height: 36), mane: true, bellyFluff: 1.3, tail: 1.3),
        ])

    static let bernedoodle = Breed(
        key: "bernedoodle", title: "Bernedoodle",
        anatomy: Anatomy(body: CGSize(width: 104, height: 52), leg: CGSize(width: 18, height: 24),
                         muzzle: CGSize(width: 26, height: 19), curly: true),
        coats: [
            .make("tricolor", "Tricolor", fur: 0x2B2A2E, shade: 0x1E1D21, patch: 0xB5651D, ear: 0x2B2A2E,
                  muzzle: 0x4A484E, accent: 0xFFFAF2, markings: [.eyebrows, .blaze, .bib]),
            .make("chocolate-tricolor", "Chocolate Tricolor", fur: 0x5A3A28, patch: 0xC98B52, ear: 0x5A3A28,
                  muzzle: 0x7A5440, accent: 0xFFFAF2, markings: [.eyebrows, .blaze, .bib]),
            .make("parti", "Black & White Parti", fur: 0x2B2A2E, shade: 0x1E1D21, ear: 0x2B2A2E, muzzle: 0x4A484E,
                  accent: 0xFFFAF2, markings: [.blaze, .bib, .socks]),
            .make("sable", "Sable", fur: 0xB8864F, patch: 0x5A3A28, dark: 0x3A2A1E, ear: 0x6B4A2C,
                  accent: 0xFFFAF2, markings: [.mask, .bib]),
            .make("merle", "Merle", fur: 0xA9AEB8, patch: 0x3A3A44, dark: 0x2F2F38, accent: 0xFFFAF2,
                  markings: [.spots, .blaze, .bib]),
        ],
        grooms: [
            Groom(key: "natural", title: "Fluffy natural", head: CGSize(width: 66, height: 54),
                  ears: CGSize(width: 22, height: 34), cheeks: CGSize(width: 24, height: 20),
                  crown: CGSize(width: 30, height: 14), bellyFluff: 1.3, tail: 1.2),
            Groom(key: "teddy", title: "Teddy-bear cut", head: CGSize(width: 72, height: 58),
                  ears: CGSize(width: 24, height: 32), cheeks: CGSize(width: 30, height: 24),
                  crown: CGSize(width: 36, height: 16), bellyFluff: 0.9),
            Groom(key: "puppy", title: "Short puppy cut", head: CGSize(width: 64, height: 52),
                  ears: CGSize(width: 22, height: 30), cheeks: CGSize(width: 20, height: 16),
                  crown: CGSize(width: 24, height: 10), bellyFluff: 0.5, tail: 0.9),
            Groom(key: "shaggy", title: "Long shaggy coat", head: CGSize(width: 66, height: 54),
                  ears: CGSize(width: 24, height: 44), cheeks: CGSize(width: 26, height: 22),
                  crown: CGSize(width: 32, height: 18), bellyFluff: 1.8, tail: 1.3),
        ])
}
