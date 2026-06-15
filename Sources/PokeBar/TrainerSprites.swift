import AppKit

/// Sprite del entrenador, generado por código (pixel art 14x22).
enum TrainerSprites {

    private static let cap = NSColor(srgbRed: 0.85, green: 0.15, blue: 0.18, alpha: 1)
    private static let skin = NSColor(srgbRed: 0.94, green: 0.76, blue: 0.62, alpha: 1)
    private static let jacket = NSColor(srgbRed: 0.18, green: 0.35, blue: 0.75, alpha: 1)
    private static let pants = NSColor(srgbRed: 0.22, green: 0.24, blue: 0.30, alpha: 1)
    private static let shoe = NSColor(white: 0.85, alpha: 1)
    private static let eye = NSColor(srgbRed: 0.1, green: 0.1, blue: 0.1, alpha: 1)

    private struct Canvas {
        static let w = 16, h = 22
        var px: [Int: NSColor] = [:]

        mutating func set(_ x: Int, _ y: Int, _ c: NSColor) {
            guard x >= 0, x < Self.w, y >= 0, y < Self.h else { return }
            px[y * Self.w + x] = c
        }

        mutating func rect(_ x: Int, _ y: Int, _ w: Int, _ h: Int, _ c: NSColor) {
            for dy in 0..<h { for dx in 0..<w { set(x + dx, y + dy, c) } }
        }

        func image(mirrored: Bool) -> NSImage {
            let pixels = px
            let image = NSImage(size: NSSize(width: Self.w, height: Self.h), flipped: true) { _ in
                for (idx, color) in pixels {
                    var x = idx % Self.w
                    let y = idx / Self.w
                    if mirrored { x = Self.w - 1 - x }
                    color.setFill()
                    NSRect(x: CGFloat(x), y: CGFloat(y), width: 1, height: 1).fill()
                }
                return true
            }
            return image
        }
    }

    /// Cuerpo del entrenador mirando a la derecha.
    /// `legPhase`: 0 piernas juntas, 1 piernas separadas.
    /// `armThrown`: brazo extendido lanzando la pokeball.
    private static func body(legPhase: Int, armThrown: Bool) -> Canvas {
        var c = Canvas()
        // Gorra con visera al frente.
        c.rect(3, 0, 5, 1, cap)
        c.rect(2, 1, 8, 1, cap)
        // Cara.
        c.rect(3, 2, 5, 3, skin)
        c.set(6, 3, eye)
        // Chaqueta.
        c.rect(2, 5, 7, 6, jacket)
        // Brazo.
        if armThrown {
            c.rect(8, 5, 4, 2, jacket)      // brazo extendido
            c.set(12, 5, skin)              // mano
        } else {
            c.rect(8, 6, 2, 4, jacket)
            c.set(8, 10, skin); c.set(9, 10, skin)
        }
        // Piernas.
        if legPhase == 0 {
            c.rect(3, 11, 2, 8, pants)
            c.rect(6, 11, 2, 8, pants)
            c.rect(3, 19, 2, 2, shoe)
            c.rect(6, 19, 2, 2, shoe)
        } else {
            c.rect(2, 11, 2, 8, pants)
            c.rect(7, 11, 2, 8, pants)
            c.rect(1, 19, 3, 2, shoe)
            c.rect(7, 19, 3, 2, shoe)
        }
        return c
    }

    private static var cache: [String: [NSImage]] = [:]

    /// Frames reales del entrenador (hoja overworld); el pixel art generado
    /// queda como respaldo si faltaran los recursos.
    private static func resourceWalk(facingLeft: Bool) -> [NSImage]? {
        let key = "trainer-walk-\(facingLeft ? "l" : "r")"
        if let cached = cache[key] { return cached }
        var result: [NSImage] = []
        var i = 0
        while let url = Bundle.module.url(forResource: "\(key)-\(i)", withExtension: "png"),
              let image = NSImage(contentsOf: url) {
            result.append(image)
            i += 1
        }
        guard !result.isEmpty else { return nil }
        cache[key] = result
        return result
    }

    static func walkFrames(facingLeft: Bool) -> [NSImage] {
        if let frames = resourceWalk(facingLeft: facingLeft) { return frames }
        return [
            body(legPhase: 0, armThrown: false).image(mirrored: facingLeft),
            body(legPhase: 1, armThrown: false).image(mirrored: facingLeft),
        ]
    }

    static func throwFrames(facingLeft: Bool) -> [NSImage] {
        // Pose de pie (frame neutro de la hoja) en el momento del lanzamiento.
        if let frames = resourceWalk(facingLeft: facingLeft) { return [frames[0]] }
        return [body(legPhase: 0, armThrown: true).image(mirrored: facingLeft)]
    }

    /// Pokeball pequeña que vuela por el escenario.
    static func ball() -> NSImage {
        NSImage(size: NSSize(width: 10, height: 10), flipped: false) { rect in
            let circle = rect.insetBy(dx: 0.5, dy: 0.5)
            NSColor.white.setFill()
            NSBezierPath(ovalIn: circle).fill()
            let top = NSBezierPath()
            top.appendArc(withCenter: NSPoint(x: rect.midX, y: rect.midY),
                          radius: circle.width / 2, startAngle: 0, endAngle: 180)
            top.close()
            NSColor(srgbRed: 0.88, green: 0.18, blue: 0.20, alpha: 1).setFill()
            top.fill()
            NSColor.black.setStroke()
            let outline = NSBezierPath(ovalIn: circle)
            outline.lineWidth = 1
            outline.stroke()
            let band = NSBezierPath()
            band.move(to: NSPoint(x: circle.minX, y: rect.midY))
            band.line(to: NSPoint(x: circle.maxX, y: rect.midY))
            band.lineWidth = 1
            band.stroke()
            NSColor.white.setFill()
            NSBezierPath(ovalIn: NSRect(x: rect.midX - 1.5, y: rect.midY - 1.5, width: 3, height: 3)).fill()
            return true
        }
    }
}
