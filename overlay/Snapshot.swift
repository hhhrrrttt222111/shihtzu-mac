import AppKit

/// Offscreen contact sheets for visual checks (`--snapshot`, `--gallery`).
enum Snapshot {
    private struct Cell {
        let dog: Dog
        let label: String?
    }

    private static let cellWidth = 260, cellHeight = 240

    /// Every mood, wearing `appearance`.
    static func moods(to path: String, appearance: Appearance) {
        let moods: [Dog.Mood] = [.walk, .run, .sit, .sniff, .sleep, .happy, .sad, .wake, .jump, .cry, .eat, .poop, .pee]
        let cells = moods.map { mood -> Cell in
            let d = pose(mood, appearance)
            if mood == .sleep { d.spawn(.zzz, dx: 52, dy: 62, vx: 0, vy: 0, life: 1.5) }
            if mood == .happy { d.hop = 14; d.spawn(.heart, dx: 30, dy: 100, vx: 0, vy: 0, life: 1) }
            if mood == .jump { d.hop = 34 }
            if mood == .cry { for eyeX: CGFloat in [29, 55] { d.spawn(.drop, dx: eyeX + d.bodyOffset, dy: 70, vx: 0, vy: 0, life: 0.7) } }
            if mood == .eat { d.spawn(.crumb, dx: 90 + d.bodyOffset, dy: 22, vx: 0, vy: 0, life: 0.5) }
            if mood == .poop { d.spawn(.poop, dx: -d.rearReach, dy: 0, vx: 0, vy: 0, life: 6) }
            if mood == .pee {
                d.spawn(.puddle, dx: -(d.rearReach + 6), dy: 0, vx: 0, vy: 0, life: 7)
                d.parts[0].life = 5   // already spread out
            }
            return Cell(dog: d, label: nil)
        }
        render(cells, columns: moods.count, to: path)
    }

    /// Every coat, groom and accessory, each varied against the current appearance.
    static func gallery(to path: String, base: Appearance) {
        var cells: [Cell] = []
        for coat in base.breed.coats {
            var a = base; a.coat = coat
            cells.append(Cell(dog: pose(.walk, a), label: coat.key))
        }
        for groom in base.breed.grooms {
            var a = base; a.groom = groom
            cells.append(Cell(dog: pose(.walk, a), label: groom.key))
        }
        for accessory in Accessory.allCases {
            var a = base; a.accessory = accessory
            cells.append(Cell(dog: pose(.walk, a), label: accessory.key))
        }
        render(cells, columns: 6, to: path)
    }

    /// Every breed in its default coat and groom (keeping the current accessory and size).
    static func breeds(to path: String, base: Appearance) {
        let cells = Breed.all.map { breed -> Cell in
            var a = Appearance(breed: breed)
            a.accessory = base.accessory
            a.size = base.size
            return Cell(dog: pose(.walk, a), label: breed.key)
        }
        render(cells, columns: 5, to: path)
    }

    private static func pose(_ mood: Dog.Mood, _ appearance: Appearance) -> Dog {
        let d = Dog()
        d.appearance = appearance
        d.mood = mood; d.x = 0; d.t = 1.3; d.phase = 0.9; d.mt = 0.35; d.dir = 1
        return d
    }

    private static func render(_ cells: [Cell], columns: Int, to path: String) {
        let rows = (cells.count + columns - 1) / columns
        let width = cellWidth * columns, height = cellHeight * rows
        let rep = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: width, pixelsHigh: height,
                                   bitsPerSample: 8, samplesPerPixel: 4, hasAlpha: true, isPlanar: false,
                                   colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
        NSGraphicsContext.saveGraphicsState()
        let ctx = NSGraphicsContext(bitmapImageRep: rep)!
        NSGraphicsContext.current = ctx
        ctx.cgContext.setFillColor(NSColor(white: 0.25, alpha: 1).cgColor)
        ctx.cgContext.fill(CGRect(x: 0, y: 0, width: width, height: height))
        for (n, cell) in cells.enumerated() {
            let originX = (n % columns) * cellWidth, originY = (rows - 1 - n / columns) * cellHeight
            ctx.cgContext.saveGState()
            ctx.cgContext.translateBy(x: CGFloat(originX + cellWidth / 2), y: CGFloat(originY))
            cell.dog.draw(ctx.cgContext)
            cell.dog.drawParticles()
            ctx.cgContext.restoreGState()
            if let label = cell.label {
                let attrs: [NSAttributedString.Key: Any] = [.font: NSFont.systemFont(ofSize: 12, weight: .medium),
                                                            .foregroundColor: NSColor.white]
                NSAttributedString(string: label, attributes: attrs)
                    .draw(at: NSPoint(x: originX + 8, y: originY + cellHeight - 20))
            }
        }
        NSGraphicsContext.restoreGraphicsState()
        try? rep.representation(using: .png, properties: [:])?.write(to: URL(fileURLWithPath: path))
    }
}
