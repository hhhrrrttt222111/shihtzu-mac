import AppKit

extension NSColor {
    convenience init(hex: UInt32) {
        self.init(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }
}

/// Fur colours and markings. `patch` / `patchDark` colour the ears, eye patches and saddle
/// (left/front and right/rear respectively).
struct Coat: Variant {
    struct Markings: OptionSet {
        let rawValue: Int
        static let saddle = Markings(rawValue: 1 << 0)
        static let eyePatches = Markings(rawValue: 1 << 1)
        static let stripes = Markings(rawValue: 1 << 2)
    }

    let key: String
    let title: String
    let fur: NSColor
    let furShade: NSColor
    let patch: NSColor
    let patchDark: NSColor
    var markings: Markings = []
    var muzzle: NSColor?

    var muzzleColor: NSColor { muzzle ?? fur.blended(withFraction: 0.12, of: furShade) ?? fur }
}

// MARK: - Catalog

extension Coat {
    private static let white = NSColor(hex: 0xFFFAF2)
    private static let whiteShade = NSColor(hex: 0xEBDECC)
    private static let black = NSColor(hex: 0x2B2A2E)
    private static let blackShade = NSColor(hex: 0x1E1D21)
    private static let blackMuzzle = NSColor(hex: 0x4A484E)

    /// White coat with coloured markings.
    private static func parti(_ key: String, _ title: String, patch: UInt32, dark: UInt32,
                              markings: Markings = [.saddle, .eyePatches]) -> Coat {
        Coat(key: key, title: title, fur: white, furShade: whiteShade,
             patch: NSColor(hex: patch), patchDark: NSColor(hex: dark), markings: markings)
    }

    /// Single-colour coat; ears are a deeper shade of the body.
    private static func solid(_ key: String, _ title: String, fur: UInt32, shade: UInt32,
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
             markings: .eyePatches, muzzle: blackMuzzle),
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
              markings: .eyePatches),
        parti("white-chocolate-ears", "White with Chocolate Ears", patch: 0x6B4430, dark: 0x4A2C1D, markings: []),
    ]

    static var fallback: Coat { all[0] }
}
