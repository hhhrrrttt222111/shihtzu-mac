import CoreGraphics

/// How large the dog is drawn. The range is deliberately narrow (0.85x–1.45x of the base art)
/// so it stays readable when small and never outgrows the overlay window when large.
enum Size: String, CaseIterable, Variant {
    case xsmall, small, medium, large, xlarge

    var key: String { rawValue }

    var title: String {
        switch self {
        case .xsmall: return "Extra small (0.85x)"
        case .small: return "Small (1.0x)"
        case .medium: return "Medium (1.15x)"
        case .large: return "Large (1.3x)"
        case .xlarge: return "Extra large (1.45x)"
        }
    }

    var scale: CGFloat {
        switch self {
        case .xsmall: return 0.85
        case .small: return 1.0
        case .medium: return 1.15
        case .large: return 1.3
        case .xlarge: return 1.45
        }
    }

    static let fallback = Size.medium
}
