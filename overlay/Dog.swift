import CoreGraphics

/// The dog's state and behaviour. Rendering lives in `DogDrawing.swift`.
final class Dog {
    enum Mood { case walk, run, sit, sniff, sleep, happy, sad, wake, jump, cry, eat, poop, pee }

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
    private var walkAfterWake = false
    /// Set once an action has left its mark on the ground (poop, puddle), so it happens only once.
    private var actionDone = false
    let groundY: CGFloat = 4
    var scale: CGFloat { appearance.size.scale }
    /// Keeps the (wider) dog fully on screen at the screen edges.
    var margin: CGFloat { 70 * scale }
    /// How far this breed's body is longer (+) or shorter (-) than the classic 98pt shih tzu, per end.
    var bodyOffset: CGFloat { appearance.breed.anatomy.body.width / 2 - 49 }
    /// Distance behind the dog's centre where its rear end is.
    var rearReach: CGFloat { appearance.breed.anatomy.body.width / 2 + 18 }

    func set(_ m: Mood, _ d: CGFloat) { mood = m; mt = 0; dur = d; spawnAcc = 0; actionDone = false }

    func go(_ tx: CGFloat, run: Bool) {
        target = tx
        dir = tx >= x ? 1 : -1
        set(run ? .run : .walk, 0)
    }

    /// Walk to a random spot at least a short stroll away.
    func wander(w: CGFloat) {
        let lo = margin, hi = max(margin + 1, w - margin)
        var tx = CGFloat.random(in: lo...hi)
        if abs(tx - x) < 160 { tx = x < w / 2 ? min(hi, x + 280) : max(lo, x - 280) }
        go(tx, run: false)
    }

    /// Whether a point (in overlay-window coordinates) is on or near the dog.
    func contains(_ p: CGPoint) -> Bool {
        abs(p.x - x) <= 80 * scale && p.y >= 0 && p.y <= 120 * scale
    }

    /// A poke: a sleeping dog stretches awake, then heads off for a walk.
    func poke() {
        guard mood == .sleep else { return }
        set(.wake, 0.8)
        walkAfterWake = true
    }

    func pickNext(w: CGFloat) {
        switch Int.random(in: 0..<100) {
        case 0..<40:
            wander(w: w)
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

    /// Actions the user asked for by name; a command result must not cut them short.
    var isPerformingAction: Bool { [.jump, .cry, .eat, .poop, .pee].contains(mood) }

    func react(ok: Bool) {
        guard !isPerformingAction else { return }
        set(ok ? .happy : .sad, ok ? 1.4 : 2.4)
    }

    func spawn(_ k: Particle.Kind, dx: CGFloat, dy: CGFloat, vx: CGFloat, vy: CGFloat, life: CGFloat) {
        parts.append(Particle(kind: k, x: x + dir * dx * scale, y: groundY + dy * scale, vx: vx, vy: vy, life: life, maxLife: life))
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
            if mt > dur {
                if walkAfterWake { walkAfterWake = false; wander(w: w) } else { pickNext(w: w) }
            }
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
        case .jump:
            // One big leap: up and back down over the action's duration.
            hop = sin(min(mt / dur, 1) * .pi) * 48
            if mt > dur { pickNext(w: w) }
        case .cry:
            spawnAcc += dt
            hop = abs(sin(mt * 14)) * 1.5   // sobbing
            if spawnAcc > 0.16 {
                spawnAcc = 0
                for eyeX: CGFloat in [29, 55] {
                    spawn(.drop, dx: eyeX + bodyOffset + .random(in: -2...2), dy: 76, vx: .random(in: -6...6), vy: -12, life: 0.7)
                }
            }
            if mt > dur { set(.sit, 2.0) }
        case .eat:
            spawnAcc += dt
            if spawnAcc > 0.22 {
                spawnAcc = 0
                spawn(.crumb, dx: 90 + bodyOffset, dy: 16, vx: .random(in: -14...14), vy: .random(in: 20...38), life: 0.5)
            }
            if mt > dur { pickNext(w: w) }
        case .poop:
            if !actionDone && mt > dur * 0.55 {
                actionDone = true
                spawn(.poop, dx: -rearReach, dy: 0, vx: 0, vy: 0, life: 6)
            }
            if mt > dur { pickNext(w: w) }
        case .pee:
            if !actionDone && mt > 0.4 {
                actionDone = true
                spawn(.puddle, dx: -(rearReach + 6), dy: 0, vx: 0, vy: 0, life: 7)
            }
            if mt > dur { pickNext(w: w) }
        }

        for i in parts.indices {
            parts[i].x += parts[i].vx * dt
            parts[i].y += parts[i].vy * dt
            parts[i].life -= dt
        }
        parts.removeAll { $0.life <= 0 }
    }
}
