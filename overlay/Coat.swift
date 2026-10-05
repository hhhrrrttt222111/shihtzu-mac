import AppKit

extension NSColor {
    convenience init(hex: UInt32) {
        self.init(srgbRed: CGFloat((hex >> 16) & 0xFF) / 255,
                  green: CGFloat((hex >> 8) & 0xFF) / 255,
                  blue: CGFloat(hex & 0xFF) / 255,
                  alpha: 1)
    }

    func darkened(_ fraction: CGFloat) -> NSColor { blended(withFraction: fraction, of: .black) ?? self }

    var isDark: Bool { (usingColorSpace(.sRGB)?.brightnessComponent ?? 1) < 0.35 }
}

/// Fur colours and markings. `patch` / `patchDark` colour the ears, eye patches, saddle and spots
/// (left/front and right/rear respectively), unless `ear` overrides the ears.
struct Coat: Variant {
    struct Markings: OptionSet {
        let rawValue: Int
        static let saddle = Markings(rawValue: 1 << 0)
        static let eyePatches = Markings(rawValue: 1 << 1)
        static let stripes = Markings(rawValue: 1 << 2)
        static let blaze = Markings(rawValue: 1 << 3)     // stripe down the face, in the accent colour
        static let mask = Markings(rawValue: 1 << 4)      // dark muzzle
        static let spots = Markings(rawValue: 1 << 5)
        static let bib = Markings(rawValue: 1 << 6)       // chest, in the accent colour
        static let socks = Markings(rawValue: 1 << 7)     // legs, in the accent colour
        static let eyebrows = Markings(rawValue: 1 << 8)
    }

    let key: String
    let title: String
    let fur: NSColor
    let furShade: NSColor
    let patch: NSColor
    let patchDark: NSColor
    var markings: Markings = []
    var muzzle: NSColor?
    /// Colour of blaze, bib and socks; defaults to the fur.
    var accent: NSColor?
    var ear: NSColor?

    var accentColor: NSColor { accent ?? fur }
    var leftEar: NSColor { ear ?? patch }
    var rightEar: NSColor { ear ?? patchDark }

    var muzzleColor: NSColor {
        muzzle ?? (markings.contains(.mask) ? patchDark : (fur.blended(withFraction: 0.12, of: furShade) ?? fur))
    }
}

extension Coat {
    /// Builds a coat from hex colours. Omitted shades are derived by darkening the fur.
    static func make(_ key: String, _ title: String, fur: UInt32, shade: UInt32? = nil, patch: UInt32? = nil,
                     dark: UInt32? = nil, ear: UInt32? = nil, muzzle: UInt32? = nil, accent: UInt32? = nil,
                     markings: Markings = []) -> Coat {
        let base = NSColor(hex: fur)
        let patchColor = patch.map(NSColor.init(hex:)) ?? base.darkened(0.22)
        return Coat(key: key, title: title, fur: base,
                    furShade: shade.map(NSColor.init(hex:)) ?? base.darkened(0.12),
                    patch: patchColor,
                    patchDark: dark.map(NSColor.init(hex:)) ?? patchColor.darkened(0.2),
                    markings: markings,
                    muzzle: muzzle.map(NSColor.init(hex:)),
                    accent: accent.map(NSColor.init(hex:)),
                    ear: ear.map(NSColor.init(hex:)))
    }
}
