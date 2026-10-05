import CoreGraphics

/// Haircut: proportions of the head, ears and coat. Defaults describe the classic shih tzu topknot.
struct Groom: Variant {
    let key: String
    let title: String
    var head = CGSize(width: 64, height: 52)
    var ears = CGSize(width: 20, height: 38)
    var cheeks = CGSize(width: 20, height: 17)
    /// Tuft of fur on top of the head; `.zero` for none.
    var crown = CGSize(width: 16, height: 20)
    var bow = false
    var ponytails = false
    var mane = false
    /// Scales the hair hanging from the belly; 0 is a fully trimmed body.
    var bellyFluff: CGFloat = 1
    /// Scales the tail plume.
    var tail: CGFloat = 1
}

/// Optional extra worn on top of any coat and groom.
enum Accessory: String, CaseIterable, Variant {
    case none, flowers, cap, scarf, glasses, crown

    var key: String { rawValue }

    var title: String {
        switch self {
        case .none: return "No accessory"
        case .flowers: return "Flower hair clips"
        case .cap: return "Tiny cap"
        case .scarf: return "Scarf"
        case .glasses: return "Cute glasses"
        case .crown: return "Royal crown"
        }
    }

    static let fallback = Accessory.none
}
