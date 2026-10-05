import CoreGraphics

struct Particle {
    enum Kind { case heart, zzz, drop, spark }
    var kind: Kind
    var x, y, vx, vy, life, maxLife: CGFloat
}
