import CoreGraphics

/// The dog's state and behaviour. Rendering lives in `DogDrawing.swift`.
final class Dog {
    enum Mood { case walk, run, sit, sniff, sleep, happy, sad, wake }

    var appearance = Appearance()

    var x: CGFloat = 300
    var dir: CGFloat = 1
    var mood: Mood = .sit
    var mt: CGFloat = 0
    var dur: CGFloat = 1.5
    var target: CGFloat = 300
    var t: CGFloat = 0
    var phase: CGFloat = 0
    var blinkIn: CGFloat = 3
    var blinkLeft: CGFloat = 0
    var hop: CGFloat = 0
    var spawnAcc: CGFloat = 0
    var parts: [Particle] = []
    let margin: CGFloat = 80
    let groundY: CGFloat = 4
    let scale: CGFloat = 1.15

    func set(_ m: Mood, _ d: CGFloat) { mood = m; mt = 0; dur = d; spawnAcc = 0 }

    func go(_ tx: CGFloat, run: Bool) {
        target = tx
        dir = tx >= x ? 1 : -1
        set(run ? .run : .walk, 0)
    }

    func pickNext(w: CGFloat) {
        let lo = margin, hi = max(margin + 1, w - margin)
        switch Int.random(in: 0..<100) {
        case 0..<40:
            var tx = CGFloat.random(in: lo...hi)
            if abs(tx - x) < 160 { tx = x < w / 2 ? min(hi, x + 280) : max(lo, x - 280) }
            go(tx, run: false)
        case 40..<60:
            if Bool.random() { dir = -dir }
            set(.sit, .random(in: 3...6))
        case 60..<80:
            if Bool.random() { dir = -dir }
            set(.sniff, .random(in: 2...4))
        default:
            set(.sleep, .random(in: 12...22))
        }
    }

    func react(ok: Bool) {
        set(ok ? .happy : .sad, ok ? 1.4 : 2.4)
    }

    func spawn(_ k: Particle.Kind, dx: CGFloat, dy: CGFloat, vx: CGFloat, vy: CGFloat, life: CGFloat) {
        parts.append(Particle(kind: k, x: x + dir * dx, y: groundY + dy, vx: vx, vy: vy, life: life, maxLife: life))
    }

    func update(_ dt: CGFloat, w: CGFloat) {
        t += dt
        mt += dt
        blinkIn -= dt
        if blinkIn < 0 { blinkIn = .random(in: 2...5); blinkLeft = 0.13 }
        blinkLeft = max(0, blinkLeft - dt)
        hop = 0
        x = min(max(x, margin), max(margin, w - margin))

        switch mood {
        case .walk, .run:
            let step = (mood == .run ? 290 : 72) * dt
            if abs(target - x) <= step { x = target; pickNext(w: w) }
            else { x += (target > x ? 1 : -1) * step }
            phase += dt * (mood == .run ? 17 : 9)
            hop = abs(sin(phase)) * (mood == .run ? 4 : 1.5)
        case .sit, .sniff:
            if mt > dur { pickNext(w: w) }
        case .sleep:
            spawnAcc += dt
            if spawnAcc > 1.4 { spawnAcc = 0; spawn(.zzz, dx: 52, dy: 62, vx: 10 * dir, vy: 22, life: 2.4) }
            if mt > dur { set(.wake, 0.8) }
        case .wake:
            if mt > dur { pickNext(w: w) }
        case .happy:
            hop = abs(sin(mt * 9)) * 26
            spawnAcc += dt
            if spawnAcc > 0.22 {
                spawnAcc = 0
                spawn(.heart, dx: .random(in: 10...50), dy: 100, vx: .random(in: -12...12), vy: 40, life: 1.3)
            }
            if mt > dur {
                let lo = margin, hi = max(margin + 1, w - margin)
                let tx = x < w / 2 ? CGFloat.random(in: (w * 0.6)...hi) : CGFloat.random(in: lo...(w * 0.4 + 1))
                go(tx, run: true)
            }
        case .sad:
            spawnAcc += dt
            if spawnAcc > 0.7 { spawnAcc = 0; spawn(.drop, dx: 52, dy: 80, vx: 6 * dir, vy: -25, life: 0.9) }
            if mt > dur { set(.sit, 2.5) }
        }

        for i in parts.indices {
            parts[i].x += parts[i].vx * dt
            parts[i].y += parts[i].vy * dt
            parts[i].life -= dt
        }
        parts.removeAll { $0.life <= 0 }
    }
}
