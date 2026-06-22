import AppKit

// El enum Species (los 151 de la primera generación) se genera con
// tools/fetch_pokemon.py y vive en SpeciesData.swift.

enum PokeSprites {
    private static var cache: [String: [NSImage]] = [:]

    /// Carga los frames `<especie>[-shiny]-<anim>-<r|l>-<n>.png` del bundle.
    /// Si se pide shiny y esa especie no tiene variante, cae a la normal.
    static func frames(_ species: Species, anim: String, facingLeft: Bool, shiny: Bool = false) -> [NSImage] {
        let variant = shiny ? "-shiny" : ""
        let key = "\(species.rawValue)\(variant)-\(anim)-\(facingLeft ? "l" : "r")"
        if let cached = cache[key] { return cached }
        var result: [NSImage] = []
        var i = 0
        while let url = Bundle.module.url(forResource: "\(key)-\(i)", withExtension: "png"),
              let image = NSImage(contentsOf: url) {
            result.append(image)
            i += 1
        }
        if result.isEmpty && shiny {
            result = frames(species, anim: anim, facingLeft: facingLeft) // sin shiny: normal
        }
        cache[key] = result
        return result
    }

    /// Cúmulo de estrellitas doradas que marca a un Pokémon shiny.
    static func sparkle() -> NSImage {
        let size = NSSize(width: 22, height: 22)
        return NSImage(size: size, flipped: false) { rect in
            let gold = NSColor(srgbRed: 1.0, green: 0.90, blue: 0.25, alpha: 1)
            // (centro x, centro y, radio) de cada estrella, agrupadas arriba.
            let stars: [(CGFloat, CGFloat, CGFloat)] = [
                (rect.maxX - 6, rect.maxY - 6, 6),
                (rect.maxX - 14, rect.maxY - 13, 3.5),
                (rect.maxX - 3.5, rect.maxY - 15, 2.5),
            ]
            for (cx, cy, r) in stars {
                let p = NSBezierPath()
                let inner = r * 0.34
                for k in 0..<8 { // estrella de 4 puntas: 8 vértices alternos
                    let angle = CGFloat(k) * .pi / 4
                    let rad = k % 2 == 0 ? r : inner
                    let pt = NSPoint(x: cx + cos(angle) * rad, y: cy + sin(angle) * rad)
                    k == 0 ? p.move(to: pt) : p.line(to: pt)
                }
                p.close()
                gold.setFill(); p.fill()
                NSColor.white.withAlphaComponent(0.9).setStroke()
                p.lineWidth = 0.6; p.stroke()
            }
            return true
        }
    }

    /// Pokeball para el ítem de la barra de menús, dibujada por código.
    static func pokeballIcon() -> NSImage {
        let size = NSSize(width: 17, height: 17)
        return NSImage(size: size, flipped: false) { rect in
            let circle = rect.insetBy(dx: 1, dy: 1)

            // Mitad inferior blanca.
            NSColor.white.setFill()
            NSBezierPath(ovalIn: circle).fill()

            // Mitad superior roja.
            let top = NSBezierPath()
            top.appendArc(withCenter: NSPoint(x: rect.midX, y: rect.midY),
                          radius: circle.width / 2, startAngle: 0, endAngle: 180)
            top.close()
            NSColor(srgbRed: 0.88, green: 0.18, blue: 0.20, alpha: 1).setFill()
            top.fill()

            // Contorno y banda central.
            NSColor.black.setStroke()
            let outline = NSBezierPath(ovalIn: circle)
            outline.lineWidth = 1.5
            outline.stroke()
            let band = NSBezierPath()
            band.move(to: NSPoint(x: circle.minX, y: rect.midY))
            band.line(to: NSPoint(x: circle.maxX, y: rect.midY))
            band.lineWidth = 1.5
            band.stroke()

            // Botón central.
            let button = NSRect(x: rect.midX - 2.5, y: rect.midY - 2.5, width: 5, height: 5)
            NSColor.white.setFill()
            NSBezierPath(ovalIn: button).fill()
            let buttonRing = NSBezierPath(ovalIn: button)
            buttonRing.lineWidth = 1.2
            buttonRing.stroke()
            return true
        }
    }
}
