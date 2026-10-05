import AppKit

/// Colours that don't vary with the coat.
enum Ink {
    static let line = NSColor(red: 0.30, green: 0.19, blue: 0.14, alpha: 1)
    static let eye = NSColor(red: 0.13, green: 0.09, blue: 0.09, alpha: 1)
    static let pink = NSColor(red: 1.0, green: 0.55, blue: 0.62, alpha: 1)
    static let bow = NSColor(red: 0.96, green: 0.30, blue: 0.42, alpha: 1)
    static let scarf = NSColor(hex: 0xE5484D)
    static let cap = NSColor(hex: 0x3B82C4)
    static let capBrim = NSColor(hex: 0x2F6AA3)
    static let gold = NSColor(hex: 0xFFC93C)
    static let gem = NSColor(hex: 0xE5484D)
    static let petals = [NSColor(hex: 0xFF7FA8), NSColor(hex: 0xFFD25E)]
}

/// The cartoon outline style shared by every part of the dog.
extension Dog {
    func blob(_ c: CGContext, _ cx: CGFloat, _ cy: CGFloat, _ w: CGFloat, _ h: CGFloat,
              _ fill: NSColor, rot: CGFloat = 0, lw: CGFloat = 2.4) {
        c.saveGState()
        c.translateBy(x: cx, y: cy)
        c.rotate(by: rot)
        let r = CGRect(x: -w / 2, y: -h / 2, width: w, height: h)
        c.setFillColor(fill.cgColor)
        c.fillEllipse(in: r)
        if lw > 0 {
            c.setStrokeColor(Ink.line.cgColor)
            c.setLineWidth(lw)
            c.strokeEllipse(in: r)
        }
        c.restoreGState()
    }

    func stroke(_ c: CGContext, _ lw: CGFloat = 2.2, color: NSColor = Ink.line, _ path: (CGContext) -> Void) {
        c.saveGState()
        c.setStrokeColor(color.cgColor)
        c.setLineWidth(lw)
        c.setLineCap(.round)
        c.beginPath()
        path(c)
        c.strokePath()
        c.restoreGState()
    }

    func polygon(_ c: CGContext, _ points: [CGPoint], _ fill: NSColor) {
        c.saveGState()
        c.beginPath()
        c.addLines(between: points)
        c.closePath()
        c.setFillColor(fill.cgColor)
        c.setStrokeColor(Ink.line.cgColor)
        c.setLineWidth(2)
        c.setLineJoin(.round)
        c.drawPath(using: .fillStroke)
        c.restoreGState()
    }
}
