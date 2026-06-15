import AppKit

/// Un combatiente sobre el escenario: imagen, animación y posición.
final class Actor {
    let view = NSImageView()
    private(set) var frames: [NSImage] = []
    private var frameInterval: TimeInterval = 0.12
    private var oneShot = false
    private var clock: TimeInterval = 0

    var centerX: CGFloat = 0
    /// Elevación sobre el suelo (para la pokeball en vuelo).
    var yOffset: CGFloat = 0
    var facingLeft = false
    var visible: Bool {
        get { !view.isHidden }
        set { view.isHidden = !newValue }
    }

    init() {
        view.imageScaling = .scaleProportionallyUpOrDown
        view.wantsLayer = true
        view.layer?.magnificationFilter = .nearest
        view.layer?.minificationFilter = .trilinear
    }

    func setAnim(_ frames: [NSImage], interval: TimeInterval, oneShot: Bool = false) {
        self.frames = frames
        self.frameInterval = interval
        self.oneShot = oneShot
        clock = 0
    }

    /// La animación one-shot ya mostró todos sus frames.
    var finished: Bool {
        oneShot && clock >= frameInterval * TimeInterval(frames.count)
    }

    func tick(_ dt: TimeInterval) {
        guard !frames.isEmpty else { return }
        clock += dt
        var index = Int(clock / frameInterval)
        if oneShot {
            index = min(index, frames.count - 1) // se queda en el último frame
        } else {
            index %= frames.count
        }
        view.image = frames[index]
    }
}

/// Ventana transparente sobre la barra de menús donde transcurre el combate.
/// Ignora los clics: el menú de macOS sigue siendo usable.
final class BattleStage {
    private let window: NSWindow
    private(set) var barFrame: NSRect = .zero
    private(set) var scale: CGFloat = 1
    /// Zona ocupada por el notch (coordenadas x locales), si lo hay.
    private(set) var notchRange: ClosedRange<CGFloat>?

    let hero = Actor()
    let foe = Actor()
    let trainer = Actor()
    let ball = Actor()

    var width: CGFloat { barFrame.width }

    init() {
        window = NSWindow(contentRect: .zero, styleMask: .borderless, backing: .buffered, defer: false)
        window.backgroundColor = .clear
        window.isOpaque = false
        window.hasShadow = false
        window.level = .statusBar
        window.ignoresMouseEvents = true
        window.collectionBehavior = [.canJoinAllSpaces, .stationary, .ignoresCycle]
        window.contentView?.addSubview(hero.view)
        window.contentView?.addSubview(foe.view)
        window.contentView?.addSubview(trainer.view)
        window.contentView?.addSubview(ball.view)
        trainer.visible = false
        ball.visible = false

        layoutForScreen()
        window.orderFrontRegardless()

        NotificationCenter.default.addObserver(
            forName: NSApplication.didChangeScreenParametersNotification,
            object: nil, queue: .main
        ) { [weak self] _ in
            self?.layoutForScreen()
        }
    }

    /// La pantalla integrada del Mac (no el monitor externo con foco).
    private var builtInScreen: NSScreen? {
        NSScreen.screens.first { screen in
            let key = NSDeviceDescriptionKey("NSScreenNumber")
            guard let id = (screen.deviceDescription[key] as? NSNumber)?.uint32Value else { return false }
            return CGDisplayIsBuiltin(id) != 0
        }
    }

    private func layoutForScreen() {
        guard let screen = builtInScreen ?? NSScreen.main ?? NSScreen.screens.first else { return }
        let barHeight = max(22, screen.frame.maxY - screen.visibleFrame.maxY)
        barFrame = NSRect(x: screen.frame.minX,
                          y: screen.frame.maxY - barHeight,
                          width: screen.frame.width,
                          height: barHeight)
        // 26 px ≈ alto de un sprite de andar; que llene la barra.
        scale = max(0.7, (barHeight - 4) / 26)

        // Notch: el hueco entre las dos áreas auxiliares superiores.
        if screen.safeAreaInsets.top > 0,
           let left = screen.auxiliaryTopLeftArea,
           let right = screen.auxiliaryTopRightArea {
            notchRange = left.width...(screen.frame.width - right.width)
        } else {
            notchRange = nil
        }

        window.setFrame(barFrame, display: true)
        place(hero)
        place(foe)
    }

    /// Oculta o muestra el escenario completo.
    func setHidden(_ hidden: Bool) {
        if hidden {
            window.orderOut(nil)
        } else {
            window.orderFrontRegardless()
        }
    }

    /// Coloca un actor: tamaño según su frame actual, pies en el suelo
    /// (más su elevación, para la pokeball en vuelo).
    func place(_ actor: Actor) {
        guard let image = actor.frames.first else { return }
        var w = image.size.width * scale
        var h = image.size.height * scale
        // Nadie se sale de la barra (p. ej. el entrenador, más alto).
        let maxH = barFrame.height - 3
        if h > maxH {
            w *= maxH / h
            h = maxH
        }
        let x = actor.centerX - w / 2
        actor.view.frame = NSRect(x: x, y: 2 + actor.yOffset, width: w, height: h)
    }
}
