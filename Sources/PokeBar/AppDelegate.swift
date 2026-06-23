import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {

    private enum Phase {
        case patrol       // el héroe pasea por la barra
        case approach     // el rival entra; ambos van al punto de combate
        case heroAttack   // turno de ataque del héroe
        case foeAttack    // turno de ataque del rival
        case foeDown      // el rival cae derrotado y se desvanece
        case evolving     // parpadeo de evolución
        case farewell     // gestos de despedida antes de la captura
        case trainerEnter // evolución final completada: llega el entrenador
        case ballThrow    // la pokeball vuela hacia el héroe
        case ballShake    // la bola se menea en el suelo: ¡capturado!
        case swapNew      // sale el siguiente Pokémon (parpadeo)
        case trainerExit  // el entrenador se marcha; el nuevo héroe pasea
    }

    private var statusItem: NSStatusItem?
    private var stage: BattleStage?
    private var updateTimer: Timer?

    private var phase: Phase = .patrol
    private var phaseClock: TimeInterval = 0

    // Héroe y rival. El héroe puede ser cualquier especie, tenga evolución o no.
    private var heroSpecies: Species = .pikachu
    private var foeSpecies: Species = .pikachu
    private var pendingEvolution: Species?
    private var finalWins = 0       // victorias acumuladas siendo ya inevolucionable
    private var winsTarget = 1      // cuántas aguanta antes de que lo capturen

    // Combate.
    private var attackCount = 0
    private var foeOnRight = true
    private var battleHeroX: CGFloat = 0
    private var heroAtPost = false
    private var paceForward = true

    // Despedida: gestos antes de volver a la pokeball.
    private var farewellQueue: [(anim: String, frameInterval: TimeInterval, hold: TimeInterval)] = []
    private var farewellIndex = 0
    private let gestureCatalog: [(anim: String, frameInterval: TimeInterval, hold: TimeInterval)] = [
        ("hop", 0.09, 1.3),       // salta
        ("attack", 0.08, 1.0),    // gruñe / se muestra
        ("sleep", 0.40, 1.9),     // se duerme
    ]

    // Captura.
    private var trainerFromRight = true
    private var ballFromX: CGFloat = 0
    private var ballToX: CGFloat = 0

    // Oculto (pausado) sin cerrar la app.
    private var isHidden = false
    private var hideItem: NSMenuItem?
    private var screenMenu: NSMenu?

    private let patrolSeconds: TimeInterval = 5

    func applicationDidFinishLaunching(_ notification: Notification) {
        let item = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        item.button?.image = PokeSprites.pokeballIcon()
        item.menu = buildMenu()
        statusItem = item

        let stage = BattleStage()
        self.stage = stage
        stage.hero.centerX = stage.width * 0.3
        stage.ball.setAnim([TrainerSprites.ball()], interval: 1)
        restartShow()

        let dt = 1.0 / 30.0
        let timer = Timer(timeInterval: dt, repeats: true) { [weak self] _ in
            self?.update(dt)
        }
        RunLoop.main.add(timer, forMode: .common)
        updateTimer = timer
    }

    // MARK: - Fases

    private func setPhase(_ next: Phase) {
        phase = next
        phaseClock = 0
    }

    /// Asigna un nuevo héroe y prepara cuántas victorias aguanta antes de la captura.
    private func setHero(_ species: Species) {
        heroSpecies = species
        pendingEvolution = nil
        finalWins = 0
        // Si no tiene evolución, aguanta 1-2 combates y luego lo capturan.
        winsTarget = (Species.next[species]?.isEmpty ?? true) ? Int.random(in: 1...2) : 0
    }

    @objc private func restartShow() {
        guard let stage else { return }
        setHero(heroPool.randomElement()!)
        stage.foe.visible = false
        stage.trainer.visible = false
        stage.ball.visible = false
        stage.foe.view.alphaValue = 1
        stage.hero.view.alphaValue = 1
        stage.hero.visible = true
        stage.hero.facingLeft = false
        setHeroAnim("walk", interval: 0.12)
        setPhase(.patrol)
    }

    private func update(_ dt: TimeInterval) {
        guard let stage, !isHidden else { return }
        phaseClock += dt
        stage.hero.tick(dt)
        if stage.foe.visible { stage.foe.tick(dt) }
        if stage.trainer.visible { stage.trainer.tick(dt) }

        switch phase {
        case .patrol:
            walkHero(dt, speed: 20)
            if phaseClock >= patrolSeconds { startApproach() }

        case .approach:
            let foeTarget = battleHeroX + (foeOnRight ? battleGap : -battleGap)
            let foeReady = approach(stage.foe, frames: walkFrames(foeSpecies),
                                    toward: foeTarget, speed: 65, dt: dt)
            var heroReady = false
            if !heroAtPost {
                heroAtPost = approach(stage.hero, frames: walkFrames(heroSpecies),
                                      toward: battleHeroX, speed: 32, dt: dt)
            } else if !foeReady {
                // No espera quieto: avanza hacia el rival y retrocede.
                let dir: CGFloat = foeOnRight ? 1 : -1
                let target = battleHeroX + (paceForward ? 16 * stage.scale * dir : 0)
                if approach(stage.hero, frames: walkFrames(heroSpecies),
                            toward: target, speed: 30, dt: dt) {
                    paceForward.toggle()
                }
            } else {
                heroReady = approach(stage.hero, frames: walkFrames(heroSpecies),
                                     toward: battleHeroX, speed: 45, dt: dt)
            }
            if heroAtPost, heroReady, foeReady {
                stage.hero.facingLeft = !foeOnRight
                stage.foe.facingLeft = foeOnRight
                attackCount = 0
                startHeroAttack()
            }

        case .heroAttack:
            if stage.hero.finished {
                attackCount += 1
                stage.foe.centerX += (foeOnRight ? 7 : -7) * stage.scale
                stage.place(stage.foe)
                if attackCount >= 5 {
                    startFoeDown()
                } else {
                    startFoeAttack()
                }
            }

        case .foeAttack:
            if stage.foe.finished {
                attackCount += 1
                stage.hero.centerX -= (foeOnRight ? 5 : -5) * stage.scale
                stage.place(stage.hero)
                startHeroAttack()
            }

        case .foeDown:
            stage.foe.view.alphaValue = max(0, 1 - phaseClock / 1.5)
            if phaseClock >= 1.5 {
                stage.foe.visible = false
                stage.foe.view.alphaValue = 1
                let evos = Species.next[heroSpecies] ?? []
                if !evos.isEmpty {
                    pendingEvolution = evos.randomElement()
                    setPhase(.evolving)
                } else {
                    finalWins += 1
                    if finalWins >= winsTarget {
                        startFarewell() // se despide y lo capturan
                    } else {
                        stage.hero.facingLeft = false
                        setHeroAnim("walk", interval: 0.12)
                        setPhase(.patrol)
                    }
                }
            }

        case .evolving:
            stage.hero.view.alphaValue = Int(phaseClock / 0.15) % 2 == 0 ? 0.2 : 1
            if phaseClock >= 1.8 {
                stage.hero.view.alphaValue = 1
                if let evo = pendingEvolution { setHero(evo) }
                setHeroAnim("walk", interval: 0.12)
                setPhase(.patrol)
            }

        case .farewell:
            let g = farewellQueue[farewellIndex]
            if phaseClock >= g.hold {
                farewellIndex += 1
                if farewellIndex >= farewellQueue.count {
                    startTrainerEnter()
                } else {
                    setPhase(.farewell) // reinicia el reloj de fase
                    applyFarewellGesture()
                }
            }

        case .trainerEnter:
            let gap = 42 * stage.scale
            let target = stage.hero.centerX + (trainerFromRight ? gap : -gap)
            if approach(stage.trainer, frames: { TrainerSprites.walkFrames(facingLeft: $0) },
                        toward: target, speed: 70, dt: dt) {
                // Lanza la pokeball.
                stage.trainer.facingLeft = trainerFromRight
                stage.trainer.setAnim(TrainerSprites.throwFrames(facingLeft: trainerFromRight), interval: 1)
                stage.place(stage.trainer)
                ballFromX = stage.trainer.centerX
                ballToX = stage.hero.centerX
                stage.ball.centerX = ballFromX
                stage.ball.visible = true
                setPhase(.ballThrow)
            }

        case .ballThrow:
            let t = min(1, phaseClock / 0.45)
            stage.ball.centerX = ballFromX + (ballToX - ballFromX) * t
            stage.ball.yOffset = 14 * stage.scale * 4 * t * (1 - t) // arco
            stage.place(stage.ball)
            if t >= 1 {
                stage.hero.visible = false // ¡dentro de la bola!
                stage.ball.yOffset = 0
                stage.place(stage.ball)
                setPhase(.ballShake)
            }

        case .ballShake:
            // La bola se menea en el suelo.
            stage.ball.centerX = ballToX + sin(phaseClock * 16) * 2 * stage.scale
            stage.place(stage.ball)
            if phaseClock >= 1.8 {
                stage.ball.visible = false
                // Un Pokémon nuevo cualquiera, distinto del capturado.
                setHero((heroPool.filter { $0 != heroSpecies }.randomElement() ?? heroPool.randomElement())!)
                stage.hero.centerX = ballToX
                stage.hero.facingLeft = trainerFromRight
                stage.hero.visible = true
                setHeroAnim("walk", interval: 0.12)
                setPhase(.swapNew)
            }

        case .swapNew:
            // El nuevo Pokémon aparece parpadeando.
            stage.hero.view.alphaValue = Int(phaseClock / 0.12) % 2 == 0 ? 0.25 : 1
            if phaseClock >= 0.9 {
                stage.hero.view.alphaValue = 1
                stage.trainer.setAnim(TrainerSprites.walkFrames(facingLeft: trainerFromRight), interval: 0.15)
                setPhase(.trainerExit)
            }

        case .trainerExit:
            // El entrenador se marcha mientras el nuevo héroe ya pasea.
            walkHero(dt, speed: 20)
            let exitX = trainerFromRight ? stage.width + 30 : -30
            if approach(stage.trainer, frames: { TrainerSprites.walkFrames(facingLeft: $0) },
                        toward: exitX, speed: 75, dt: dt) {
                stage.trainer.visible = false
                setPhase(.patrol)
            }
        }
    }

    // MARK: - Acciones de fase

    private func walkFrames(_ species: Species) -> (Bool) -> [NSImage] {
        { facingLeft in PokeSprites.frames(species, anim: "walk", facingLeft: facingLeft) }
    }

    /// Mueve a un actor hacia su objetivo girándolo si hace falta.
    private func approach(_ actor: Actor, frames: (Bool) -> [NSImage],
                          toward target: CGFloat, speed: CGFloat, dt: TimeInterval) -> Bool {
        guard let stage else { return true }
        let delta = target - actor.centerX
        if abs(delta) <= 2 * stage.scale {
            actor.centerX = target
            stage.place(actor)
            return true
        }
        let movingLeft = delta < 0
        if movingLeft != actor.facingLeft || actor.frames.isEmpty {
            actor.facingLeft = movingLeft
            actor.setAnim(frames(movingLeft), interval: 0.12)
        }
        actor.centerX += (movingLeft ? -1 : 1) * speed * stage.scale * dt
        stage.place(actor)
        return false
    }

    private func walkHero(_ dt: TimeInterval, speed: CGFloat) {
        guard let stage else { return }
        let hero = stage.hero
        let half = (hero.frames.first?.size.width ?? 20) * stage.scale / 2
        hero.centerX += (hero.facingLeft ? -1 : 1) * speed * stage.scale * dt
        if hero.centerX <= half {
            hero.centerX = half
            hero.facingLeft = false
            setHeroAnim("walk", interval: 0.12)
        } else if hero.centerX >= stage.width - half {
            hero.centerX = stage.width - half
            hero.facingLeft = true
            setHeroAnim("walk", interval: 0.12)
        }
        stage.place(hero)
    }

    private var battleGap: CGFloat {
        guard let stage else { return 30 }
        let heroW = (stage.hero.frames.first?.size.width ?? 20) * stage.scale
        let foeW = (stage.foe.frames.first?.size.width ?? 20) * stage.scale
        return (heroW + foeW) / 2 + 4 * stage.scale
    }

    /// Punto de combate: cerca del héroe, pero nunca bajo el notch ni en las
    /// esquinas — los dos combatientes deben verse enteros y con aire.
    private func battlePosition() -> CGFloat {
        guard let stage else { return 100 }
        let gap = battleGap
        let pad = 20 * stage.scale
        let edge = 50 * stage.scale

        let minX = edge + (foeOnRight ? 0 : gap)
        let maxX = stage.width - edge - (foeOnRight ? gap : 0)

        var intervals: [(CGFloat, CGFloat)] = []
        if let notch = stage.notchRange {
            let leftLimit = foeOnRight ? notch.lowerBound - gap - pad : notch.lowerBound - pad
            let rightLimit = foeOnRight ? notch.upperBound + pad : notch.upperBound + gap + pad
            if leftLimit >= minX { intervals.append((minX, min(maxX, leftLimit))) }
            if rightLimit <= maxX { intervals.append((max(minX, rightLimit), maxX)) }
        } else {
            intervals.append((minX, maxX))
        }
        let valid = intervals.filter { $0.0 <= $0.1 }
        guard !valid.isEmpty else { return stage.width / 2 }

        let heroX = stage.hero.centerX
        return valid
            .map { min(max(heroX, $0.0), $0.1) }
            .min(by: { abs($0 - heroX) < abs($1 - heroX) })!
    }

    private func startApproach() {
        guard let stage else { return }
        foeOnRight = Bool.random()
        foeSpecies = (foePool.filter { $0 != heroSpecies }.randomElement() ?? foePool.randomElement())!

        let foe = stage.foe
        foe.facingLeft = foeOnRight
        foe.setAnim(PokeSprites.frames(foeSpecies, anim: "walk", facingLeft: foeOnRight), interval: 0.12)
        foe.centerX = foeOnRight ? stage.width + 20 : -20
        foe.visible = true
        stage.place(foe)

        battleHeroX = battlePosition()
        heroAtPost = false
        paceForward = true
        setPhase(.approach)
    }

    private func startHeroAttack() {
        setHeroAnim("attack", interval: 0.07, oneShot: true)
        setPhase(.heroAttack)
    }

    private func startFoeAttack() {
        guard let stage else { return }
        stage.foe.setAnim(PokeSprites.frames(foeSpecies, anim: "attack",
                                             facingLeft: stage.foe.facingLeft),
                          interval: 0.07, oneShot: true)
        stage.place(stage.foe)
        setPhase(.foeAttack)
    }

    private func startFoeDown() {
        guard let stage else { return }
        stage.foe.setAnim(PokeSprites.frames(foeSpecies, anim: "hurt",
                                             facingLeft: stage.foe.facingLeft),
                          interval: 0.3)
        stage.place(stage.foe)
        setHeroAnim("walk", interval: 0.12)
        setPhase(.foeDown)
    }

    /// Antes de la captura, el héroe hace los gestos que tenga disponibles
    /// (saltar, gruñir, dormir…). Si no tiene ninguno, va directo a la captura.
    private func startFarewell() {
        farewellQueue = gestureCatalog.filter {
            !PokeSprites.frames(heroSpecies, anim: $0.anim, facingLeft: false).isEmpty
        }
        farewellIndex = 0
        guard !farewellQueue.isEmpty else { startTrainerEnter(); return }
        setPhase(.farewell)
        applyFarewellGesture()
    }

    private func applyFarewellGesture() {
        let g = farewellQueue[farewellIndex]
        setHeroAnim(g.anim, interval: g.frameInterval)
    }

    private func startTrainerEnter() {
        guard let stage else { return }
        // Entra por el borde más cercano al héroe.
        trainerFromRight = stage.hero.centerX > stage.width / 2
        let trainer = stage.trainer
        trainer.centerX = trainerFromRight ? stage.width + 20 : -20
        trainer.facingLeft = trainerFromRight
        trainer.setAnim(TrainerSprites.walkFrames(facingLeft: trainerFromRight), interval: 0.15)
        trainer.visible = true
        stage.place(trainer)
        // El héroe se gira hacia el entrenador.
        stage.hero.facingLeft = trainerFromRight
        setHeroAnim("walk", interval: 0.12)
        setPhase(.trainerEnter)
    }

    private func setHeroAnim(_ anim: String, interval: TimeInterval, oneShot: Bool = false) {
        guard let stage else { return }
        stage.hero.setAnim(PokeSprites.frames(heroSpecies, anim: anim, facingLeft: stage.hero.facingLeft),
                           interval: interval, oneShot: oneShot)
        stage.place(stage.hero)
    }

    // MARK: - Menú

    private func buildMenu() -> NSMenu {
        let menu = NSMenu()
        let hide = NSMenuItem(title: "Ocultar", action: #selector(toggleHidden), keyEquivalent: "h")
        hide.target = self
        hideItem = hide
        menu.addItem(hide)
        let restart = NSMenuItem(title: "Reiniciar combate", action: #selector(restartShow), keyEquivalent: "r")
        restart.target = self
        menu.addItem(restart)

        // Submenú de pantallas, poblado al abrirse (los monitores van y vienen).
        let screensItem = NSMenuItem(title: "Pantalla", action: nil, keyEquivalent: "")
        let screensMenu = NSMenu()
        screensMenu.delegate = self
        screensItem.submenu = screensMenu
        screenMenu = screensMenu
        menu.addItem(screensItem)

        // Submenú de generaciones (multiselección; ninguna marcada = todas).
        let gensItem = NSMenuItem(title: "Generación", action: nil, keyEquivalent: "")
        let gensMenu = NSMenu()
        let selected = selectedGenerations
        for gen in 1...Species.generations.count {
            let item = NSMenuItem(title: "Generación \(gen)",
                                  action: #selector(toggleGeneration(_:)), keyEquivalent: "")
            item.target = self
            item.tag = gen
            item.state = selected.contains(gen) ? .on : .off
            gensMenu.addItem(item)
        }
        gensItem.submenu = gensMenu
        menu.addItem(gensItem)

        menu.addItem(.separator())
        let quit = NSMenuItem(title: "Salir", action: #selector(quit), keyEquivalent: "q")
        quit.target = self
        menu.addItem(quit)
        return menu
    }

    /// Rellena el submenú de pantallas justo antes de mostrarse.
    func menuNeedsUpdate(_ menu: NSMenu) {
        guard menu === screenMenu else { return }
        menu.removeAllItems()
        let currentID = stage?.currentScreenID
        for screen in NSScreen.screens {
            let item = NSMenuItem(title: screenLabel(screen),
                                  action: #selector(selectScreen(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = screen
            if BattleStage.displayID(of: screen) == currentID { item.state = .on }
            menu.addItem(item)
        }
    }

    private func screenLabel(_ screen: NSScreen) -> String {
        let name = screen.localizedName
        return BattleStage.isBuiltIn(screen) ? "\(name) (integrada)" : name
    }

    @objc private func selectScreen(_ sender: NSMenuItem) {
        guard let screen = sender.representedObject as? NSScreen else { return }
        stage?.move(to: screen)
    }

    /// Generaciones elegidas (vacío = todas). Se aplica a los siguientes Pokémon.
    private var selectedGenerations: Set<Int> {
        get { Set(UserDefaults.standard.array(forKey: "PokeBarGenerations") as? [Int] ?? []) }
        set { UserDefaults.standard.set(newValue.sorted(), forKey: "PokeBarGenerations") }
    }

    /// Pool de héroes (formas base) y de rivales según las generaciones elegidas.
    private var heroPool: [Species] { Species.firstStage(of: Species.pool(generations: selectedGenerations)) }
    private var foePool: [Species] { Species.pool(generations: selectedGenerations) }

    @objc private func toggleGeneration(_ sender: NSMenuItem) {
        var selected = selectedGenerations
        if selected.contains(sender.tag) { selected.remove(sender.tag) } else { selected.insert(sender.tag) }
        selectedGenerations = selected
        sender.state = selected.contains(sender.tag) ? .on : .off
    }

    @objc private func toggleHidden() {
        isHidden.toggle()
        stage?.setHidden(isHidden)
        hideItem?.title = isHidden ? "Mostrar" : "Ocultar"
    }

    @objc private func quit() {
        NSApp.terminate(nil)
    }
}
