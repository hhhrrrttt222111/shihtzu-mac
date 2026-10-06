import CoreGraphics

struct Particle {
    enum Kind { case heart, zzz, drop, spark, crumb, poop, puddle }
    var kind: Kind
    var x, y, vx, vy, life, maxLife: CGFloat
}
