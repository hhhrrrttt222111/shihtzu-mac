import AppKit

extension Breed {
    static let shihTzu = Breed(key: "shihtzu", title: "Shih Tzu", coats: ShihTzuCoats.all, grooms: ShihTzuGrooms.all)
}

private enum ShihTzuCoats {
    static let white = NSColor(hex: 0xFFFAF2)
    static let whiteShade = NSColor(hex: 0xEBDECC)
    static let black = NSColor(hex: 0x2B2A2E)
    static let blackShade = NSColor(hex: 0x1E1D21)
    static let blackMuzzle = NSColor(hex: 0x4A484E)

    /// White coat with coloured markings.
    static func parti(_ key: String, _ title: String, patch: UInt32, dark: UInt32,
                      markings: Coat.Markings = [.saddle, .eyePatches, .blaze]) -> Coat {
        Coat(key: key, title: title, fur: white, furShade: whiteShade,
             patch: NSColor(hex: patch), patchDark: NSColor(hex: dark), markings: markings)
    }

    /// Single-colour coat; ears are a deeper shade of the body.
    static func solid(_ key: String, _ title: String, fur: UInt32, shade: UInt32,
                      ear: UInt32, earDark: UInt32, muzzle: UInt32? = nil) -> Coat {
        Coat(key: key, title: title, fur: NSColor(hex: fur), furShade: NSColor(hex: shade),
             patch: NSColor(hex: ear), patchDark: NSColor(hex: earDark), muzzle: muzzle.map(NSColor.init(hex:)))
    }

    static let all: [Coat] = [
        parti("classic", "White & Brown", patch: 0xD49457, dark: 0xA86E3D),
        parti("white-black", "White & Black", patch: 0x3A3A40, dark: 0x232328),
        parti("golden-white", "Golden & White", patch: 0xE8B84A, dark: 0xC4922A),
        solid("cream", "Cream", fur: 0xF6E6BF, shade: 0xE2CE9C, ear: 0xE0C48A, earDark: 0xC9A86A),
        solid("gold", "Solid Gold", fur: 0xE0A93C, shade: 0xC48A22, ear: 0xB87A1E, earDark: 0x9A6214),
        solid("chocolate", "Chocolate Brown", fur: 0x6B4430, shade: 0x553423, ear: 0x4A2C1D, earDark: 0x3A2115,
              muzzle: 0x8A6048),
        parti("liver-white", "Liver & White", patch: 0x7A3E34, dark: 0x5E2C26),
        Coat(key: "black", title: "Black", fur: black, furShade: blackShade,
             patch: NSColor(hex: 0x1B1A1D), patchDark: NSColor(hex: 0x121114), muzzle: blackMuzzle),
        Coat(key: "black-gold", title: "Black & Gold", fur: black, furShade: blackShade,
             patch: NSColor(hex: 0xD9A441), patchDark: NSColor(hex: 0xB8832B),
             markings: [.eyePatches, .blaze], muzzle: blackMuzzle),
        parti("silver-white", "Silver & White", patch: 0xB9BEC8, dark: 0x969CA8),
        parti("grey-white", "Grey & White", patch: 0x8A8F99, dark: 0x686D77),
        Coat(key: "brindle", title: "Brindle", fur: NSColor(hex: 0xB98A4E), furShade: NSColor(hex: 0x9C703A),
             patch: NSColor(hex: 0x6B4A28), patchDark: NSColor(hex: 0x4F3419),
             markings: .stripes, muzzle: NSColor(hex: 0xD8B88A)),
        parti("red-white", "Red & White", patch: 0xC4592E, dark: 0x9E4220),
        parti("apricot-white", "Apricot & White", patch: 0xF0A86A, dark: 0xD58A4C),
        parti("tricolor", "Black, White & Gold", patch: 0xD9A441, dark: 0x2B2A2E),
        parti("brown-white-black", "Brown, White & Black", patch: 0x8B5A3C, dark: 0x2B2A2E),
        parti("white-brown-ears", "White with Brown Ears", patch: 0xB07A4A, dark: 0x8F5E33, markings: []),
        parti("white-black-ears", "White with Black Ears", patch: 0x34343A, dark: 0x232328, markings: []),
        parti("white-golden-face", "White with Golden Face", patch: 0xE8B84A, dark: 0xC4922A,
              markings: [.eyePatches, .blaze]),
        parti("white-chocolate-ears", "White with Chocolate Ears", patch: 0x6B4430, dark: 0x4A2C1D, markings: []),
    ]
}

private enum ShihTzuGrooms {
    static let all: [Groom] = [
        Groom(key: "topknot", title: "Top-knot with bow", bow: true),
        Groom(key: "puppy", title: "Short puppy cut",
              ears: CGSize(width: 18, height: 28), cheeks: CGSize(width: 15, height: 12),
              crown: CGSize(width: 16, height: 8), bellyFluff: 0.75, tail: 0.8),
        Groom(key: "teddy", title: "Fluffy teddy-bear cut",
              head: CGSize(width: 70, height: 56), ears: CGSize(width: 24, height: 30),
              cheeks: CGSize(width: 28, height: 22), crown: CGSize(width: 34, height: 16),
              bellyFluff: 1.3, tail: 1.15),
        Groom(key: "long", title: "Long flowing coat",
              ears: CGSize(width: 22, height: 56), cheeks: CGSize(width: 22, height: 20),
              crown: CGSize(width: 26, height: 12), bellyFluff: 1.9),
        Groom(key: "round", title: "Round teddy-face cut",
              head: CGSize(width: 70, height: 62), ears: CGSize(width: 18, height: 24),
              cheeks: CGSize(width: 30, height: 26), crown: CGSize(width: 28, height: 12), bellyFluff: 0.8),
        Groom(key: "lion", title: "Lion cut",
              ears: CGSize(width: 16, height: 22), cheeks: CGSize(width: 18, height: 15),
              crown: .zero, mane: true, bellyFluff: 0, tail: 1.4),
        Groom(key: "ponytails", title: "Two small ponytails",
              crown: CGSize(width: 26, height: 8), ponytails: true),
    ]
}
