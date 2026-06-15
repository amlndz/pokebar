import AppKit

// El enum Species (los 151 de la primera generación) se genera con
// tools/fetch_pokemon.py y vive en SpeciesData.swift.

enum PokeSprites {
    private static var cache: [String: [NSImage]] = [:]

    /// Carga los frames `<especie>-<anim>-<r|l>-<n>.png` del bundle.
    static func frames(_ species: Species, anim: String, facingLeft: Bool) -> [NSImage] {
        let key = "\(species.rawValue)-\(anim)-\(facingLeft ? "l" : "r")"
        if let cached = cache[key] { return cached }
        var result: [NSImage] = []
        var i = 0
        while let url = Bundle.module.url(forResource: "\(key)-\(i)", withExtension: "png"),
              let image = NSImage(contentsOf: url) {
            result.append(image)
            i += 1
        }
        cache[key] = result
        return result
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
