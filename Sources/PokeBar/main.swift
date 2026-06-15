import AppKit

let app = NSApplication.shared
let delegate = AppDelegate()
app.delegate = delegate
// Solo barra de menús: sin icono en el Dock ni ventana principal.
app.setActivationPolicy(.accessory)
app.run()
