import AppKit

/// Colours that don't vary with the coat.
private enum Ink {
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

extension Dog {
    // MARK: Primitives

    private func blob(_ c: CGContext, _ cx: CGFloat, _ cy: CGFloat, _ w: CGFloat, _ h: CGFloat,
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

    private func stroke(_ c: CGContext, _ lw: CGFloat = 2.2, color: NSColor = Ink.line,
                        _ path: (CGContext) -> Void) {
        c.saveGState()
        c.setStrokeColor(color.cgColor)
        c.setLineWidth(lw)
        c.setLineCap(.round)
        c.beginPath()
        path(c)
        c.strokePath()
        c.restoreGState()
    }

    private func polygon(_ c: CGContext, _ points: [CGPoint], _ fill: NSColor) {
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

    // MARK: Body

    func draw(_ c: CGContext) {
        let coat = appearance.coat, groom = appearance.groom
        let sitting = mood == .sit || mood == .sad
        let asleep = mood == .sleep
        let moving = mood == .walk || mood == .run
        let excited = mood == .run || mood == .happy

        c.saveGState()
        c.translateBy(x: x, y: groundY + hop)
        c.scaleBy(x: dir * scale, y: scale)

        // Shadow
        let sh = max(0.55, 1 - hop / 60)
        c.setFillColor(NSColor(white: 0, alpha: 0.16).cgColor)
        c.fillEllipse(in: CGRect(x: -52 * sh, y: -hop / scale - 5, width: 104 * sh, height: 10))

        // Pose
        var bodyY: CGFloat = 42, bodyH: CGFloat = 48, bodyRot: CGFloat = 0
        var head = CGPoint(x: 44, y: 68)
        var headRot: CGFloat = 0
        if sitting { bodyY = 36; bodyRot = 0.38; head = CGPoint(x: 40, y: 82) }
        if mood == .sad { head = CGPoint(x: 42, y: 74); headRot = -0.14 }
        if mood == .sniff {
            head = CGPoint(x: 52 + sin(t * 9) * 2, y: 46 + sin(t * 14) * 1.5)
            headRot = -0.25
        }
        if asleep {
            let br = sin(t * 2.2) * 1.2
            bodyY = 24; bodyH = 38 + br; head = CGPoint(x: 50, y: 24 + br * 0.5); headRot = -0.1
        }
        if mood == .wake { head = CGPoint(x: 46, y: 66); headRot = sin(mt * 10) * 0.08 }
        if moving { head.y += sin(phase * 2) * 1.5; headRot = sin(phase) * 0.05 }
        if sitting && mood == .sit { headRot = sin(t * 1.3) * 0.07 }
        if mood == .happy { headRot = sin(mt * 9) * 0.1 }

        // Tail
        let wagSpeed: CGFloat = excited ? 24 : (mood == .walk ? 10 : ((sitting && mood == .sit) ? 7 : (asleep || mood == .sad ? 0 : 5)))
        let wag = sin(t * wagSpeed) * (wagSpeed > 0 ? 5 : 0)
        let tailBaseY = asleep ? 30.0 : (sitting ? 22.0 : 64.0)
        let plume = groom.tail
        blob(c, -46 + wag * 0.4, tailBaseY + 10, 20 * plume, 22 * plume, coat.furShade, rot: 0.3 + wag * 0.03)
        blob(c, -44 + wag, tailBaseY + 20, 24 * plume, 24 * plume, coat.fur, rot: 0.2)
        blob(c, -40 + wag, tailBaseY + 24, 12 * plume, 12 * plume, coat.patch, lw: 0)

        // Legs (far side first)
        let gait = phase
        func leg(_ lx: CGFloat, _ p: CGFloat, _ color: NSColor) {
            let m: CGFloat = moving ? 1 : 0
            let px = lx + sin(p) * 9 * m
            let py = 12 + max(0, cos(p)) * 6 * m
            blob(c, px, py, 17, 23, color)
        }
        if asleep {
            // legs tucked
        } else if sitting {
            blob(c, 28, 11, 17, 22, coat.furShade)
        } else {
            leg(-26, gait + .pi, coat.furShade)
            leg(26, gait, coat.furShade)
        }

        // Belly fluff
        if !asleep && groom.bellyFluff > 0 {
            let f = groom.bellyFluff
            for fx in stride(from: CGFloat(-30), through: 30, by: 15) {
                blob(c, fx, bodyY - bodyH * 0.42 - (f - 1) * 6, 18 * f, 14 * f, coat.fur)
            }
        }

        // Body
        c.saveGState()
        c.translateBy(x: 0, y: bodyY)
        c.rotate(by: bodyRot)
        let bodyW: CGFloat = asleep ? 104 : 98
        blob(c, 0, 0, bodyW, bodyH, coat.fur)
        if coat.markings.contains(.saddle) {
            blob(c, -12, bodyH * 0.22, 54, bodyH * 0.46, coat.patch, lw: 0)
            blob(c, -26, bodyH * 0.1, 30, bodyH * 0.4, coat.patchDark, lw: 0)
        }
        if coat.markings.contains(.stripes) { drawStripes(c, bodyW: bodyW, bodyH: bodyH, color: coat.patchDark) }
        c.restoreGState()

        // Sitting haunch
        if sitting {
            blob(c, -22, 20, 40, 34, coat.furShade, rot: 0.2)
            blob(c, -4, 6, 26, 14, coat.fur)
        }

        // Near legs
        if asleep {
            blob(c, 54, 9, 22, 14, coat.fur)
        } else if sitting {
            blob(c, 36, 12, 17, 24, coat.fur)
        } else {
            leg(-26, gait, coat.fur)
            leg(26, gait + .pi, coat.fur)
        }

        drawHead(c, at: head, rot: headRot)
        c.restoreGState()
    }

    /// Brindle tiger stripes, following the curve of the body's top edge.
    private func drawStripes(_ c: CGContext, bodyW: CGFloat, bodyH: CGFloat, color: NSColor) {
        for sx in stride(from: CGFloat(-32), through: 36, by: 17) {
            let edge = bodyH / 2 * (1 - pow(sx / (bodyW / 2), 2)).squareRoot()
            stroke(c, 3, color: color) {
                $0.move(to: CGPoint(x: sx, y: edge - 1.5))
                $0.addQuadCurve(to: CGPoint(x: sx + 5, y: edge - 15), control: CGPoint(x: sx - 2, y: edge - 8))
            }
        }
    }

    // MARK: Head

    private func drawHead(_ c: CGContext, at p: CGPoint, rot: CGFloat) {
        let coat = appearance.coat, groom = appearance.groom, accessory = appearance.accessory
        let asleep = mood == .sleep
        let happy = mood == .happy
        let sad = mood == .sad
        let sniff = mood == .sniff
        let run = mood == .run
        let yawn = mood == .wake
        let earSwing = sin(phase) * (mood == .run ? 0.22 : (mood == .walk ? 0.1 : 0)) + (happy ? sin(mt * 18) * 0.14 : 0)
        let earDrop: CGFloat = sad ? 0.18 : 0

        // Head geometry derived from the groom; the classic topknot (64x52) gives the original proportions.
        let headW = groom.head.width, headH = groom.head.height
        let top = headH / 2
        let crownY = top + groom.crown.height / 2 - 9
        let earX = headW / 2 - 3, earY = 13 - groom.ears.height / 2
        let cheekX = headW / 2 - 8, cheekY = 13 - headH / 2

        c.saveGState()
        c.translateBy(x: p.x, y: p.y)
        c.rotate(by: rot)

        // Behind the head: mane, crown tuft, ponytails, ears
        if groom.mane { drawMane(c, coat.patchDark, headW: headW, headH: headH) }
        if groom.crown != .zero { blob(c, 2, crownY, groom.crown.width, groom.crown.height, coat.fur) }
        if groom.ponytails { drawPonytails(c, fur: coat.fur, topY: top) }
        blob(c, -earX, earY, groom.ears.width, groom.ears.height, coat.patch, rot: 0.12 + earSwing + earDrop)
        blob(c, earX, earY, groom.ears.width, groom.ears.height, coat.patchDark, rot: -0.12 - earSwing - earDrop)
        if accessory == .scarf { drawScarf(c) }

        // Cheek fluff and head
        blob(c, -cheekX, cheekY, groom.cheeks.width, groom.cheeks.height, coat.fur)
        blob(c, cheekX, cheekY, groom.cheeks.width, groom.cheeks.height, coat.fur)
        blob(c, 0, 0, headW, headH, coat.fur)
        if coat.markings.contains(.eyePatches) {
            blob(c, -15, 6, 24, 20, coat.patch, rot: 0.25, lw: 0)
            blob(c, 15, 6, 24, 20, coat.patch, rot: -0.25, lw: 0)
            blob(c, 0, 8, 10, 26, coat.fur, lw: 0) // white blaze
        }

        if groom.bow {
            blob(c, -6, crownY, 11, 8, Ink.bow, rot: 0.5, lw: 1.8)
            blob(c, 10, crownY, 11, 8, Ink.bow, rot: -0.5, lw: 1.8)
            blob(c, 2, crownY, 6, 6, Ink.bow, lw: 1.8)
        }

        // Blush
        blob(c, -23, -5, 10, 7, Ink.pink.withAlphaComponent(0.55), lw: 0)
        blob(c, 23, -5, 10, 7, Ink.pink.withAlphaComponent(0.55), lw: 0)

        // Eyes
        let closedArch = happy || yawn
        let closedSleep = asleep
        let blink = blinkLeft > 0
        for ex in [CGFloat(-13), CGFloat(13)] {
            if closedArch {
                stroke(c, 2.6) { $0.move(to: CGPoint(x: ex - 6, y: 1)); $0.addQuadCurve(to: CGPoint(x: ex + 6, y: 1), control: CGPoint(x: ex, y: 11)) }
            } else if closedSleep || blink {
                stroke(c, 2.6) { $0.move(to: CGPoint(x: ex - 6, y: 4)); $0.addQuadCurve(to: CGPoint(x: ex + 6, y: 4), control: CGPoint(x: ex, y: -4)) }
            } else {
                let dy: CGFloat = sniff ? -2 : 0
                blob(c, ex, 3 + dy, 12, sad ? 15 : 14, Ink.eye, lw: 0)
                blob(c, ex + 2, 6.5 + dy, 5, 5, .white, lw: 0)
                blob(c, ex - 2, 0 + dy, 2.4, 2.4, .white, lw: 0)
            }
        }
        if sad {
            stroke(c, 2.2) { $0.move(to: CGPoint(x: -21, y: 13)); $0.addLine(to: CGPoint(x: -7, y: 17)) }
            stroke(c, 2.2) { $0.move(to: CGPoint(x: 7, y: 17)); $0.addLine(to: CGPoint(x: 21, y: 13)) }
        }

        // Muzzle
        blob(c, 0, -10, 24, 17, coat.muzzleColor, lw: 0)

        // Mouth
        if sad {
            stroke(c) { $0.move(to: CGPoint(x: 0, y: -10)); $0.addLine(to: CGPoint(x: 0, y: -13)) }
            stroke(c) { $0.move(to: CGPoint(x: -7, y: -18)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: -3, y: -13)) }
            stroke(c) { $0.move(to: CGPoint(x: 7, y: -18)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: 3, y: -13)) }
        } else if yawn {
            blob(c, 0, -19, 12, 14, Ink.eye, lw: 1.8)
            blob(c, 0, -23, 8, 7, Ink.pink, lw: 0)
        } else {
            stroke(c) { $0.move(to: CGPoint(x: 0, y: -10)); $0.addLine(to: CGPoint(x: 0, y: -13)) }
            if happy || run {
                blob(c, 0, -20, 14, 10, Ink.eye, lw: 1.8)
                blob(c, 0, -22, 9, 11, Ink.pink, lw: 1.6)
            } else {
                stroke(c) { $0.move(to: CGPoint(x: -8, y: -14)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: -3, y: -18)) }
                stroke(c) { $0.move(to: CGPoint(x: 8, y: -14)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: 3, y: -18)) }
            }
        }

        // Nose
        blob(c, 0, -7, 12, 8, Ink.eye, lw: 0)
        blob(c, -2, -5.5, 3.5, 2.2, NSColor.white.withAlphaComponent(0.85), lw: 0)

        // Worn on top of everything
        switch accessory {
        case .glasses: drawGlasses(c)
        case .flowers: drawFlowers(c, topY: top)
        case .cap: drawCap(c, topY: top)
        case .crown: drawCrown(c, topY: top)
        case .none, .scarf: break
        }

        c.restoreGState()
    }

    // MARK: Groom details

    private func drawMane(_ c: CGContext, _ color: NSColor, headW: CGFloat, headH: CGFloat) {
        let count = 10
        for k in 0..<count {
            let a = CGFloat(k) / CGFloat(count) * 2 * .pi
            blob(c, cos(a) * (headW / 2 + 4), sin(a) * (headH / 2 + 4), 28, 28, color)
        }
    }

    private func drawPonytails(_ c: CGContext, fur: NSColor, topY: CGFloat) {
        for side: CGFloat in [-1, 1] {
            blob(c, side * 27, topY - 4, 13, 22, fur, rot: -side * 1.1)
            blob(c, side * 19, topY - 1, 8, 8, Ink.bow, lw: 1.6)
        }
    }

    // MARK: Accessories

    private func drawScarf(_ c: CGContext) {
        blob(c, 0, -29, 46, 16, Ink.scarf)
        blob(c, 15, -39, 10, 18, Ink.scarf, rot: -0.3)
        blob(c, 4, -32, 7, 7, NSColor.white.withAlphaComponent(0.7), lw: 0)
        blob(c, -12, -31, 7, 7, NSColor.white.withAlphaComponent(0.7), lw: 0)
    }

    private func drawGlasses(_ c: CGContext) {
        for ex in [CGFloat(-13), CGFloat(13)] {
            blob(c, ex, 3, 21, 19, NSColor.white.withAlphaComponent(0.22), lw: 2.6)
        }
        stroke(c, 2.4) { $0.move(to: CGPoint(x: -3, y: 4)); $0.addLine(to: CGPoint(x: 3, y: 4)) }
    }

    private func drawFlower(_ c: CGContext, at p: CGPoint, petal: NSColor) {
        for k in 0..<5 {
            let a = CGFloat(k) / 5 * 2 * .pi + .pi / 2
            blob(c, p.x + cos(a) * 4.6, p.y + sin(a) * 4.6, 7.5, 7.5, petal, lw: 1.4)
        }
        blob(c, p.x, p.y, 5, 5, Ink.gold, lw: 1.2)
    }

    private func drawFlowers(_ c: CGContext, topY: CGFloat) {
        drawFlower(c, at: CGPoint(x: -21, y: topY * 0.8), petal: Ink.petals[0])
        drawFlower(c, at: CGPoint(x: 21, y: topY * 0.8), petal: Ink.petals[1])
    }

    private func drawCap(_ c: CGContext, topY: CGFloat) {
        blob(c, 0, topY, 40, 28, Ink.cap)
        blob(c, 13, topY - 12, 28, 8, Ink.capBrim, lw: 2)
        blob(c, 0, topY + 14, 6, 6, Ink.capBrim, lw: 1.6)
    }

    private func drawCrown(_ c: CGContext, topY: CGFloat) {
        let y = topY - 2
        polygon(c, [
            CGPoint(x: -15, y: y), CGPoint(x: -17, y: y + 17), CGPoint(x: -7, y: y + 9),
            CGPoint(x: 0, y: y + 20), CGPoint(x: 7, y: y + 9), CGPoint(x: 17, y: y + 17),
            CGPoint(x: 15, y: y),
        ], Ink.gold)
        blob(c, 0, y + 6, 6, 6, Ink.gem, lw: 1.4)
    }

    // MARK: Particles

    func drawParticles() {
        for p in parts {
            let k = p.life / p.maxLife
            let alpha = min(1, k * 2.2)
            var text = "", size: CGFloat = 16, color = NSColor.red
            switch p.kind {
            case .heart: text = "♥"; size = 16 + (1 - k) * 8; color = NSColor(red: 1, green: 0.35, blue: 0.5, alpha: alpha)
            case .zzz: text = "z"; size = 12 + (1 - k) * 14; color = NSColor(white: 0.95, alpha: alpha)
            case .drop: text = "💧"; size = 14; color = .white
            case .spark: text = "✦"; size = 14; color = NSColor(red: 1, green: 0.85, blue: 0.3, alpha: alpha)
            }
            let attrs: [NSAttributedString.Key: Any] = [
                .font: NSFont.systemFont(ofSize: size, weight: .heavy),
                .foregroundColor: color,
                .strokeColor: NSColor(red: 0.3, green: 0.19, blue: 0.14, alpha: alpha),
                .strokeWidth: p.kind == .drop ? 0 : -3,
            ]
            NSAttributedString(string: text, attributes: attrs).draw(at: NSPoint(x: p.x, y: p.y))
        }
    }
}
