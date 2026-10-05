import AppKit

/// Accessories are positioned relative to the top of the head (`topY`), so they follow any groom.
extension Dog {
    func drawScarf(_ c: CGContext) {
        blob(c, 0, -29, 46, 16, Ink.scarf)
        blob(c, 15, -39, 10, 18, Ink.scarf, rot: -0.3)
        blob(c, 4, -32, 7, 7, NSColor.white.withAlphaComponent(0.7), lw: 0)
        blob(c, -12, -31, 7, 7, NSColor.white.withAlphaComponent(0.7), lw: 0)
    }

    func drawGlasses(_ c: CGContext) {
        for ex in [CGFloat(-13), CGFloat(13)] {
            blob(c, ex, 3, 21, 19, NSColor.white.withAlphaComponent(0.22), lw: 2.6)
        }
        stroke(c, 2.4) { $0.move(to: CGPoint(x: -3, y: 4)); $0.addLine(to: CGPoint(x: 3, y: 4)) }
    }

    func drawFlowers(_ c: CGContext, topY: CGFloat) {
        drawFlower(c, at: CGPoint(x: -21, y: topY * 0.8), petal: Ink.petals[0])
        drawFlower(c, at: CGPoint(x: 21, y: topY * 0.8), petal: Ink.petals[1])
    }

    func drawCap(_ c: CGContext, topY: CGFloat) {
        blob(c, 0, topY, 40, 28, Ink.cap)
        blob(c, 13, topY - 12, 28, 8, Ink.capBrim, lw: 2)
        blob(c, 0, topY + 14, 6, 6, Ink.capBrim, lw: 1.6)
    }

    func drawCrown(_ c: CGContext, topY: CGFloat) {
        let y = topY - 2
        polygon(c, [
            CGPoint(x: -15, y: y), CGPoint(x: -17, y: y + 17), CGPoint(x: -7, y: y + 9),
            CGPoint(x: 0, y: y + 20), CGPoint(x: 7, y: y + 9), CGPoint(x: 17, y: y + 17),
            CGPoint(x: 15, y: y),
        ], Ink.gold)
        blob(c, 0, y + 6, 6, 6, Ink.gem, lw: 1.4)
    }

    private func drawFlower(_ c: CGContext, at p: CGPoint, petal: NSColor) {
        for k in 0..<5 {
            let a = CGFloat(k) / 5 * 2 * .pi + .pi / 2
            blob(c, p.x + cos(a) * 4.6, p.y + sin(a) * 4.6, 7.5, 7.5, petal, lw: 1.4)
        }
        blob(c, p.x, p.y, 5, 5, Ink.gold, lw: 1.2)
    }
}
