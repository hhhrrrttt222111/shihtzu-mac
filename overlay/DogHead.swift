import AppKit

extension Dog {
    func drawHead(_ c: CGContext, at p: CGPoint, rot: CGFloat) {
        let coat = appearance.coat, groom = appearance.groom, anatomy = appearance.breed.anatomy
        let accessory = appearance.accessory
        let asleep = mood == .sleep
        let happy = mood == .happy || mood == .jump
        let sad = mood == .sad || mood == .cry
        let sniff = mood == .sniff
        let run = mood == .run
        let yawn = mood == .wake
        let earSwing = sin(phase) * (mood == .run ? 0.22 : (mood == .walk ? 0.1 : 0)) + (happy ? sin(mt * 18) * 0.14 : 0)
        let earDrop: CGFloat = sad ? 0.18 : 0

        // Head geometry derived from the groom; the classic topknot (64x52) gives the original proportions.
        let headW = groom.head.width, headH = groom.head.height
        let top = headH / 2
        let crownY = top + groom.crown.height / 2 - 9
        let cheekX = headW / 2 - 8, cheekY = 13 - headH / 2
        // A longer muzzle pushes the mouth and nose further down the face.
        let snout = max(0, anatomy.muzzle.height - 17)
        let mouthColor = coat.muzzleColor.isDark ? NSColor(white: 0.88, alpha: 1) : Ink.line

        c.saveGState()
        c.translateBy(x: p.x, y: p.y)
        c.rotate(by: rot)

        // Behind the head: mane, crown tuft, ponytails, ears
        if groom.mane { drawMane(c, coat.patchDark, headW: headW, headH: headH) }
        if groom.crown != .zero { blob(c, 2, crownY, groom.crown.width, groom.crown.height, coat.fur) }
        if groom.ponytails { drawPonytails(c, fur: coat.fur, topY: top) }
        drawEars(c, coat: coat, groom: groom, style: anatomy.ears, swing: earSwing + earDrop, happy: happy)
        if accessory == .scarf { drawScarf(c) }

        // Cheek fluff and head
        blob(c, -cheekX, cheekY, groom.cheeks.width, groom.cheeks.height, coat.fur)
        blob(c, cheekX, cheekY, groom.cheeks.width, groom.cheeks.height, coat.fur)
        blob(c, 0, 0, headW, headH, coat.fur)
        drawFaceMarkings(c, coat: coat)

        if groom.bow {
            blob(c, -6, crownY, 11, 8, Ink.bow, rot: 0.5, lw: 1.8)
            blob(c, 10, crownY, 11, 8, Ink.bow, rot: -0.5, lw: 1.8)
            blob(c, 2, crownY, 6, 6, Ink.bow, lw: 1.8)
        }

        // Blush
        blob(c, -23, -5, 10, 7, Ink.pink.withAlphaComponent(0.55), lw: 0)
        blob(c, 23, -5, 10, 7, Ink.pink.withAlphaComponent(0.55), lw: 0)

        // Muzzle (before the eyes so the snout never covers them)
        c.saveGState()
        c.translateBy(x: 0, y: -snout)
        if coat.markings.contains(.mask) {
            blob(c, 0, -9 + snout / 2, anatomy.muzzle.width + 6, anatomy.muzzle.height + 6, coat.patchDark, lw: 0)
        }
        blob(c, 0, -10 + snout / 2, anatomy.muzzle.width, anatomy.muzzle.height, coat.muzzleColor,
             lw: snout > 0 ? 2.2 : 0)
        c.restoreGState()

        // Eyes
        let closedArch = happy || yawn || mood == .eat || mood == .poop || mood == .pee
        let closedSleep = asleep
        let blink = blinkLeft > 0
        for ex in [CGFloat(-13), CGFloat(13)] {
            if closedArch {
                stroke(c, 2.6) { $0.move(to: CGPoint(x: ex - 6, y: 1)); $0.addQuadCurve(to: CGPoint(x: ex + 6, y: 1), control: CGPoint(x: ex, y: 11)) }
            } else if closedSleep || blink {
                stroke(c, 2.6) { $0.move(to: CGPoint(x: ex - 6, y: 4)); $0.addQuadCurve(to: CGPoint(x: ex + 6, y: 4), control: CGPoint(x: ex, y: -4)) }
            } else {
                let dy: CGFloat = sniff ? -2 : 0
                if let iris = anatomy.eyeColor {
                    blob(c, ex, 3 + dy, 13, sad ? 16 : 15, iris, lw: 0)
                    blob(c, ex, 3 + dy, 6, 9, Ink.eye, lw: 0)
                } else {
                    blob(c, ex, 3 + dy, 12, sad ? 15 : 14, Ink.eye, lw: 0)
                }
                blob(c, ex + 2, 6.5 + dy, 5, 5, .white, lw: 0)
                blob(c, ex - 2, 0 + dy, 2.4, 2.4, .white, lw: 0)
            }
        }
        if sad {
            stroke(c, 2.2) { $0.move(to: CGPoint(x: -21, y: 13)); $0.addLine(to: CGPoint(x: -7, y: 17)) }
            stroke(c, 2.2) { $0.move(to: CGPoint(x: 7, y: 17)); $0.addLine(to: CGPoint(x: 21, y: 13)) }
        }

        // Mouth and nose
        c.saveGState()
        c.translateBy(x: 0, y: -snout)
        if sad {
            stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: 0, y: -10)); $0.addLine(to: CGPoint(x: 0, y: -13)) }
            stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: -7, y: -18)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: -3, y: -13)) }
            stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: 7, y: -18)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: 3, y: -13)) }
        } else if yawn {
            blob(c, 0, -19, 12, 14, Ink.eye, lw: 1.8)
            blob(c, 0, -23, 8, 7, Ink.pink, lw: 0)
        } else {
            stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: 0, y: -10)); $0.addLine(to: CGPoint(x: 0, y: -13)) }
            if happy || run {
                blob(c, 0, -20, 14, 10, Ink.eye, lw: 1.8)
                blob(c, 0, -22, 9, 11, Ink.pink, lw: 1.6)
            } else {
                stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: -8, y: -14)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: -3, y: -18)) }
                stroke(c, color: mouthColor) { $0.move(to: CGPoint(x: 8, y: -14)); $0.addQuadCurve(to: CGPoint(x: 0, y: -13), control: CGPoint(x: 3, y: -18)) }
            }
        }
        blob(c, 0, -7, 12, 8, Ink.eye, lw: 0)
        blob(c, -2, -5.5, 3.5, 2.2, NSColor.white.withAlphaComponent(0.85), lw: 0)
        c.restoreGState()

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

    // MARK: Face

    private func drawFaceMarkings(_ c: CGContext, coat: Coat) {
        let m = coat.markings
        if m.contains(.eyePatches) {
            blob(c, -15, 6, 24, 20, coat.patch, rot: 0.25, lw: 0)
            blob(c, 15, 6, 24, 20, coat.patch, rot: -0.25, lw: 0)
        }
        if m.contains(.eyebrows) {
            blob(c, -14, 14, 9, 7, coat.patch, rot: 0.2, lw: 0)
            blob(c, 14, 14, 9, 7, coat.patch, rot: -0.2, lw: 0)
        }
        if m.contains(.blaze) { blob(c, 0, 8, 10, 26, coat.accentColor, lw: 0) }
        if m.contains(.spots) {
            blob(c, -21, -1, 6, 5.5, coat.patch, lw: 0)
            blob(c, 19, 17, 5.5, 5, coat.patch, lw: 0)
        }
    }

    // MARK: Ears

    private func drawEars(_ c: CGContext, coat: Coat, groom: Groom, style: Anatomy.EarStyle,
                          swing: CGFloat, happy: Bool) {
        let w = groom.ears.width, h = groom.ears.height
        let top = groom.head.height / 2
        switch style {
        case .floppy:
            let ex = groom.head.width / 2 - 3, ey = 13 - h / 2
            blob(c, -ex, ey, w, h, coat.leftEar, rot: 0.12 + swing)
            blob(c, ex, ey, w, h, coat.rightEar, rot: -0.12 - swing)
        case .rounded:
            let ex = groom.head.width / 2 - w / 2 - 1, ey = top - h / 2 + 5
            blob(c, -ex, ey, w, h, coat.leftEar, rot: 0.25 + swing * 0.5)
            blob(c, ex, ey, w, h, coat.rightEar, rot: -0.25 - swing * 0.5)
            blob(c, -ex, ey - 1, w * 0.5, h * 0.55, Ink.pink.withAlphaComponent(0.6), rot: 0.25, lw: 0)
            blob(c, ex, ey - 1, w * 0.5, h * 0.55, Ink.pink.withAlphaComponent(0.6), rot: -0.25, lw: 0)
        case .erect, .folded:
            let ex = groom.head.width / 2 - w / 2 - 1
            for side: CGFloat in [-1, 1] {
                let color = side < 0 ? coat.leftEar : coat.rightEar
                c.saveGState()
                c.translateBy(x: side * ex, y: top - 7)
                c.rotate(by: -side * (0.18 + swing * 0.4))
                let tip = style == .folded ? h * 0.78 : h
                polygon(c, [CGPoint(x: -w / 2, y: 0), CGPoint(x: 0, y: tip), CGPoint(x: w / 2, y: 0)], color)
                if style == .folded {
                    blob(c, side * w * 0.3, tip - 2, w * 0.55, h * 0.3, color, rot: -side * 0.6)
                } else {
                    polygon(c, [CGPoint(x: -w * 0.22, y: 2), CGPoint(x: 0, y: tip * 0.62), CGPoint(x: w * 0.22, y: 2)],
                            Ink.pink.withAlphaComponent(0.6))
                }
                c.restoreGState()
            }
        }
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
}
