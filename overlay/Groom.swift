import CoreGraphics

/// Haircut: proportions of the head, ears and coat. Defaults describe the classic topknot.
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

    static var fallback: Groom { all[0] }
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

    static var all: [Accessory] { allCases }
    static var fallback: Accessory { .none }
}
