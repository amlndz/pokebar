# PokeBar ⚡

Un espectáculo Pokémon en la barra de menús de macOS. Charmander pasea por la
barra y vive su historia de evolución en bucle, en una ventana transparente que
ignora los clics. 100 % Swift + AppKit.

## El guion

1. **Charmander** pasea por la barra (~5 s)
2. Aparece **Bulbasaur** por la derecha → ¡combate! → Charmander gana
3. ✨ Evoluciona a **Charmeleon** → pasea (~5 s)
4. Aparece **Ivysaur** → combate → victoria
5. ✨ Evoluciona a **Charizard** → pasea (~5 s)
6. Aparece **Venusaur** → combate final → victoria
7. Vuelta de honor y el espectáculo se reinicia

El icono de la barra es una **pokeball** 🔴 — desde su menú puedes reiniciar el
combate o salir.

## Sprites

Los sprites vienen del proyecto [PMD Sprite Collab](https://sprites.pmdcollab.org)
([GitHub](https://github.com/PMDCollab/SpriteCollab)) — animaciones de andar,
atacar y recibir daño de los Pokémon 0001-0006, troceadas en frames
individuales en `Sources/PokeBar/Resources/`.

## Compilar y ejecutar

```sh
./build-app.sh   # genera PokeBar.app
open PokeBar.app
```

Para desarrollo rápido: `swift run PokeBar`.

## Estructura

| Archivo | Qué contiene |
|---|---|
| `Sources/PokeBar/AppDelegate.swift` | Director del espectáculo (máquina de fases del combate) |
| `Sources/PokeBar/BattleStage.swift` | Ventana sobre la barra + actores animados |
| `Sources/PokeBar/PokeSprites.swift` | Carga de frames y pokeball del menú |
| `Sources/PokeBar/Resources/` | Frames de los 6 Pokémon (walk/attack/hurt, izquierda/derecha) |
