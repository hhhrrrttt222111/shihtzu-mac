import AppKit

/// Everything about a breed's build that coats and grooms don't cover. The defaults describe the shih tzu.
struct Anatomy {
    enum EarStyle {
        case floppy   // hang beside the head
        case erect    // pointed, upright
        case rounded  // small and round on top of the head
        case folded   // upright with a flopped tip
    }

    enum TailStyle {
        case plume    // feathery, curving up over the back
        case pom      // pom-pom on a short tail
        case curl     // curled tightly over the back
        case straight // thin and tapering (otter tail)
        case bushy    // thick and hanging
        case nub      // barely there
    }

    var body = CGSize(width: 98, height: 48)
    var leg = CGSize(width: 17, height: 23)
    /// Muzzle size; height beyond 17 lengthens the snout.
    var muzzle = CGSize(width: 24, height: 17)
    var ears = EarStyle.floppy
    var tail = TailStyle.plume
    /// Scalloped curls along the back (poodles and doodles).
    var curly = false
    /// Iris colour; `nil` is the usual dark eye.
    var eyeColor: NSColor?
}
