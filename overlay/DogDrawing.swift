import AppKit

/// Spots for dalmatian / merle / dapple coats: x, y (in the classic 98x48 body) and radius.
private let spotPattern: [(x: CGFloat, y: CGFloat, r: CGFloat)] = [
    (-34, 6, 9), (-18, -8, 11), (-2, 9, 8), (12, -6, 10), (26, 8, 9), (38, -4, 7), (-8, -16, 6), (4, 18, 5),
]

extension Dog {
    func draw(_ c: CGContext) {
        let coat = appearance.coat, groom = appearance.groom, anatomy = appearance.breed.anatomy
        let sitting = mood == .sit || mood == .sad
        let asleep = mood == .sleep
        let moving = mood == .walk || mood == .run
        let excited = mood == .run || mood == .happy

        // Proportions relative to the classic 98x48 body on 23pt legs (the shih tzu).
        let bodyW = anatomy.body.width + (asleep ? 6 : 0)
        let stretch = bodyW / 98
        let off = anatomy.body.width / 2 - 49             // how far head and tail sit from the classic ends
        let legH = anatomy.leg.height, legW = anatomy.leg.width
        let stance = (legH - 23) + (anatomy.body.height - 48) / 2   // body rides higher on long legs
        let lift = asleep ? 0 : (sitting ? stance / 2 : stance)
        var bodyH = anatomy.body.height

        c.saveGState()
        c.translateBy(x: x, y: groundY + hop)
        c.scaleBy(x: dir * scale, y: scale)

        // Shadow
        let sh = max(0.55, 1 - hop / 60)
        let shadowW = bodyW + 6
        c.setFillColor(NSColor(white: 0, alpha: 0.16).cgColor)
        c.fillEllipse(in: CGRect(x: -shadowW / 2 * sh, y: -hop / scale - 5, width: shadowW * sh, height: 10))

        // Pose
        var bodyY: CGFloat = 42 + lift, bodyRot: CGFloat = 0
        var head = CGPoint(x: 44 + off, y: 68 + lift)
        var headRot: CGFloat = 0
        if sitting { bodyY = 36 + lift; bodyRot = 0.38; head = CGPoint(x: 40 + off, y: 82 + lift) }
        if mood == .sad { head = CGPoint(x: 42 + off, y: 74 + lift); headRot = -0.14 }
        if mood == .sniff {
            head = CGPoint(x: 52 + off + sin(t * 9) * 2, y: 46 + lift + sin(t * 14) * 1.5)
            headRot = -0.25
        }
        if asleep {
            let br = sin(t * 2.2) * 1.2
            bodyY = 24; bodyH = anatomy.body.height * 0.79 + br
            head = CGPoint(x: 50 + off, y: 24 + br * 0.5); headRot = -0.1
        }
        if mood == .wake { head = CGPoint(x: 46 + off, y: 66 + lift); headRot = sin(mt * 10) * 0.08 }
        if moving { head.y += sin(phase * 2) * 1.5; headRot = sin(phase) * 0.05 }
        if sitting && mood == .sit { headRot = sin(t * 1.3) * 0.07 }
        if mood == .happy { headRot = sin(mt * 9) * 0.1 }

        // Tail
        let wagSpeed: CGFloat = excited ? 24 : (mood == .walk ? 10 : ((sitting && mood == .sit) ? 7 : (asleep || mood == .sad ? 0 : 5)))
        let wag = sin(t * wagSpeed) * (wagSpeed > 0 ? 5 : 0)
        let tailBaseY = (asleep ? 30.0 : (sitting ? 22.0 : 64.0)) + lift
        // Where the tail meets the back: on the body outline, turned with the body's pose.
        let rear = CGPoint(x: -bodyW * 0.4, y: bodyH * 0.3)
        let root = CGPoint(x: rear.x * cos(bodyRot) - rear.y * sin(bodyRot),
                           y: bodyY + rear.x * sin(bodyRot) + rear.y * cos(bodyRot))
        drawTail(c, coat: coat, style: anatomy.tail, scale: groom.tail, wag: wag, plumeAt: CGPoint(x: -off, y: tailBaseY), root: root)

        // Legs (far side first)
        let socks = coat.markings.contains(.socks)
        let farLeg = socks ? coat.accentColor.darkened(0.08) : coat.furShade
        let nearLeg = socks ? coat.accentColor : coat.fur
        let gait = phase
        let legX = 26 + off
        func leg(_ lx: CGFloat, _ p: CGFloat, _ color: NSColor) {
            let m: CGFloat = moving ? 1 : 0
            let px = lx + sin(p) * 9 * m
            let py = legH / 2 + 0.5 + max(0, cos(p)) * 6 * m
            blob(c, px, py, legW, legH, color)
        }
        if asleep {
            // legs tucked
        } else if sitting {
            blob(c, 28 + off, (legH - 1) / 2, legW, legH - 1, farLeg)
        } else {
            leg(-legX, gait + .pi, farLeg)
            leg(legX, gait, farLeg)
        }

        // Belly fluff
        if !asleep && groom.bellyFluff > 0 {
            let f = groom.bellyFluff
            for fx in stride(from: CGFloat(-30), through: 30, by: 15) {
                blob(c, fx * stretch, bodyY - bodyH * 0.42 - (f - 1) * 6, 18 * f, 14 * f, coat.fur)
            }
        }

        // Body
        c.saveGState()
        c.translateBy(x: 0, y: bodyY)
        c.rotate(by: bodyRot)
        if anatomy.curly { drawCurls(c, bodyW: bodyW, bodyH: bodyH, color: coat.fur) }
        drawBody(c, coat: coat, bodyW: bodyW, bodyH: bodyH)
        c.restoreGState()

        // Sitting haunch
        if sitting {
            blob(c, -22 - off, 20 + lift, 40, 34, coat.furShade, rot: 0.2)
            blob(c, -4 - off, 6 + lift, 26, 14, coat.fur)
        }

        // Near legs
        if asleep {
            blob(c, 54 + off, 9, 22, 14, coat.fur)
        } else if sitting {
            blob(c, 36 + off, (legH + 1) / 2, legW, legH + 1, nearLeg)
        } else {
            leg(-legX, gait, nearLeg)
            leg(legX, gait + .pi, nearLeg)
        }

        drawHead(c, at: head, rot: headRot)
        c.restoreGState()
    }

    // MARK: Body

    /// Fur, markings (clipped to the body) and outline.
    private func drawBody(_ c: CGContext, coat: Coat, bodyW: CGFloat, bodyH: CGFloat) {
        let stretch = bodyW / 98, rect = CGRect(x: -bodyW / 2, y: -bodyH / 2, width: bodyW, height: bodyH)
        blob(c, 0, 0, bodyW, bodyH, coat.fur, lw: 0)

        c.saveGState()
        c.addEllipse(in: rect)
        c.clip()
        if coat.markings.contains(.saddle) {
            blob(c, -12 * stretch, bodyH * 0.22, 54 * stretch, bodyH * 0.46, coat.patch, lw: 0)
            blob(c, -26 * stretch, bodyH * 0.1, 30 * stretch, bodyH * 0.4, coat.patchDark, lw: 0)
        }
        if coat.markings.contains(.bib) {
            blob(c, bodyW / 2 - 14, -bodyH * 0.1, 30, bodyH * 0.8, coat.accentColor, lw: 0)
        }
        if coat.markings.contains(.spots) {
            for s in spotPattern {
                blob(c, s.x * stretch, s.y * bodyH / 48, s.r * 1.1, s.r, coat.patch, lw: 0)
            }
        }
        if coat.markings.contains(.stripes) { drawStripes(c, bodyW: bodyW, bodyH: bodyH, color: coat.patchDark) }
        c.restoreGState()

        c.setStrokeColor(Ink.line.cgColor)
        c.setLineWidth(2.4)
        c.strokeEllipse(in: rect)
    }

    /// Brindle tiger stripes, following the curve of the body's top edge.
    private func drawStripes(_ c: CGContext, bodyW: CGFloat, bodyH: CGFloat, color: NSColor) {
        for sx in stride(from: -bodyW * 0.33, through: bodyW * 0.37, by: 17) {
            let edge = bodyH / 2 * (1 - pow(sx / (bodyW / 2), 2)).squareRoot()
            stroke(c, 3, color: color) {
                $0.move(to: CGPoint(x: sx, y: edge - 1.5))
                $0.addQuadCurve(to: CGPoint(x: sx + 5, y: edge - 15), control: CGPoint(x: sx - 2, y: edge - 8))
            }
        }
    }

    /// Scalloped curls bulging past the top of the body; drawn before the body so only the outer half shows.
    private func drawCurls(_ c: CGContext, bodyW: CGFloat, bodyH: CGFloat, color: NSColor) {
        for sx in stride(from: -bodyW / 2 + 9, through: bodyW / 2 - 9, by: 13) {
            let edge = bodyH / 2 * (1 - pow(sx / (bodyW / 2), 2)).squareRoot()
            blob(c, sx, edge - 1, 17, 15, color)
        }
    }

    // MARK: Tail

    /// The shih tzu's plume keeps its original high placement (`plumeAt`); every other style grows from `root`.
    private func drawTail(_ c: CGContext, coat: Coat, style: Anatomy.TailStyle, scale s: CGFloat,
                          wag: CGFloat, plumeAt: CGPoint, root: CGPoint) {
        let rx = root.x, ry = root.y
        switch style {
        case .plume:
            let x = plumeAt.x, baseY = plumeAt.y
            blob(c, x - 46 + wag * 0.4, baseY + 10, 20 * s, 22 * s, coat.furShade, rot: 0.3 + wag * 0.03)
            blob(c, x - 44 + wag, baseY + 20, 24 * s, 24 * s, coat.fur, rot: 0.2)
            blob(c, x - 40 + wag, baseY + 24, 12 * s, 12 * s, coat.ear ?? coat.patch, lw: 0)
        case .pom:
            blob(c, rx + 1 + wag * 0.3, ry + 7, 11, 14, coat.furShade, rot: 0.3)
            blob(c, rx + wag * 0.6, ry + 19, 24 * s, 24 * s, coat.fur)
        case .curl:
            blob(c, rx, ry + 3, 13, 15, coat.furShade, rot: 0.3)
            blob(c, rx - 1 + wag * 0.5, ry + 15, 22 * s, 21 * s, coat.fur)
            stroke(c, 1.8) {
                $0.addArc(center: CGPoint(x: rx - 1 + wag * 0.5, y: ry + 15), radius: 4 * s,
                          startAngle: 0.4, endAngle: 4.6, clockwise: false)
            }
        case .straight:
            blob(c, rx - 2, ry + 2, 16, 12, coat.furShade, rot: -0.4)
            blob(c, rx - 14 + wag * 0.6, ry + 8, 30 * s, 9 * s, coat.fur, rot: -0.4)
        case .bushy:
            blob(c, rx - 3, ry - 2, 20 * s, 24 * s, coat.furShade, rot: -0.5)
            blob(c, rx - 9 + wag * 0.4, ry - 12, 22 * s, 28 * s, coat.fur, rot: -0.35)
            blob(c, rx - 12 + wag * 0.8, ry - 24, 17 * s, 22 * s, coat.fur, rot: -0.2)
        case .nub:
            blob(c, rx - 4 + wag * 0.4, ry + 3, 16, 15, coat.fur)
        }
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
