"""Descarga TODOS los Pokémon hasta Gen 5 (Blanco/Negro, #001-649).

- Nombres y evoluciones reales desde PokeAPI.
- Sprites desde PMDCollab: andar/atacar/recibir daño + gestos (dormir/saltar).
- Genera SpeciesData.swift (enum + mapa de evolución), web/dex.json y los
  iconos frontales de web/dex/.

Las especies sin sprites completos en PMDCollab se descartan automáticamente.
Uso: python fetch_all.py
"""
import os
import re
import json
import urllib.request
import urllib.error
from concurrent.futures import ThreadPoolExecutor
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "Sources", "PokeBar", "Resources")
WEB_DEX = os.path.join(ROOT, "web", "dex")
SWIFT = os.path.join(ROOT, "Sources", "PokeBar", "SpeciesData.swift")
DEX_JSON = os.path.join(ROOT, "web", "dex.json")

CACHE = "/tmp/pmd"
API_CACHE = "/tmp/pokeapi"
PMD = "https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/sprite"
POKEAPI = "https://pokeapi.co/api/v2"

MAX_DEX = 649
ANIMS = {"Walk": "walk", "Attack": "attack", "Hurt": "hurt", "Sleep": "sleep", "Hop": "hop"}
REQUIRED = {"Walk", "Attack", "Hurt"}  # sin estas, se descarta la especie
ROWS = {"r": 2, "l": 6}  # filas de dirección (derecha / izquierda)

os.makedirs(OUT, exist_ok=True)
os.makedirs(WEB_DEX, exist_ok=True)
os.makedirs(API_CACHE, exist_ok=True)


def sanitize(name: str) -> str:
    return re.sub(r"[^a-z0-9]", "", name.lower())


def http_get(url: str, timeout=30):
    req = urllib.request.Request(url, headers={"User-Agent": "PokeBar/1.0"})
    return urllib.request.urlopen(req, timeout=timeout).read()


# ── 1. PokeAPI: nombre + de qué evoluciona ──────────────────────────────
def fetch_species_meta(dex: int):
    cache = os.path.join(API_CACHE, f"{dex}.json")
    if os.path.exists(cache) and os.path.getsize(cache) > 0:
        data = json.load(open(cache))
    else:
        for _ in range(3):
            try:
                raw = http_get(f"{POKEAPI}/pokemon-species/{dex}/")
                data = json.loads(raw)
                open(cache, "wb").write(raw)
                break
            except Exception:
                data = None
        if data is None:
            return dex, None, None
    efs = data.get("evolves_from_species")
    return dex, sanitize(data["name"]), (sanitize(efs["name"]) if efs else None)


print("PokeAPI: nombres y evoluciones…")
meta = {}
with ThreadPoolExecutor(max_workers=16) as ex:
    for dex, name, evo_from in ex.map(fetch_species_meta, range(1, MAX_DEX + 1)):
        if name:
            meta[dex] = (name, evo_from)
print(f"  {len(meta)} especies en PokeAPI")

name_to_dex = {n: d for d, (n, _) in meta.items()}
# Mapa de evolución hacia adelante (maneja ramificaciones tipo Eevee).
forward = {}
for dex, (name, evo_from) in meta.items():
    if evo_from and evo_from in name_to_dex:
        forward.setdefault(evo_from, []).append(name)


# ── 2. PMDCollab: descarga de hojas ─────────────────────────────────────
FILES = ["AnimData.xml"] + [f"{a}-Anim.png" for a in ANIMS]


def fetch_sprites(dex: int):
    d = os.path.join(CACHE, f"{dex:04d}")
    os.makedirs(d, exist_ok=True)
    for f in FILES:
        path = os.path.join(d, f)
        if os.path.exists(path) and os.path.getsize(path) > 0:
            continue
        try:
            data = http_get(f"{PMD}/{dex:04d}/{f}")
            open(path, "wb").write(data)
        except Exception:
            pass  # animación opcional puede no existir
    return dex


print("PMDCollab: descargando sprites (puede tardar)…")
done = 0
with ThreadPoolExecutor(max_workers=24) as ex:
    for _ in ex.map(fetch_sprites, meta.keys()):
        done += 1
        if done % 80 == 0:
            print(f"  {done}/{len(meta)}")


# ── 3. Troceado en frames ───────────────────────────────────────────────
def anim_sizes(d):
    xml = open(os.path.join(d, "AnimData.xml")).read()
    sizes = {}
    for m in re.finditer(r"<Anim>(.*?)</Anim>", xml, re.S):
        a = m.group(1)
        n = re.search(r"<Name>(.*?)</Name>", a)
        fw = re.search(r"<FrameWidth>(\d+)</FrameWidth>", a)
        fh = re.search(r"<FrameHeight>(\d+)</FrameHeight>", a)
        if n and fw and fh:
            sizes[n.group(1)] = (int(fw.group(1)), int(fh.group(1)))
    return sizes


def slice_species(dex: int, name: str) -> bool:
    d = os.path.join(CACHE, f"{dex:04d}")
    if not os.path.exists(os.path.join(d, "AnimData.xml")):
        return False
    try:
        sizes = anim_sizes(d)
    except Exception:
        return False
    if not REQUIRED.issubset(sizes):
        return False

    # Icono frontal para la web (fila 0 = mirando a cámara).
    try:
        fw, fh = sizes["Walk"]
        wsheet = Image.open(os.path.join(d, "Walk-Anim.png")).convert("RGBA")
        front = wsheet.crop((0, 0, fw, fh))
        box = front.getbbox()
        if box:
            front.crop(box).save(os.path.join(WEB_DEX, f"{name}.png"))
    except Exception:
        pass

    for anim, out_name in ANIMS.items():
        png = os.path.join(d, f"{anim}-Anim.png")
        if anim not in sizes or not os.path.exists(png):
            continue
        fw, fh = sizes[anim]
        try:
            sheet = Image.open(png).convert("RGBA")
        except Exception:
            if anim in REQUIRED:
                return False
            continue
        cols = sheet.width // fw
        rows = sheet.height // fh
        if cols == 0:
            if anim in REQUIRED:
                return False
            continue
        for dkey, row in ROWS.items():
            r = row if rows >= 8 else 0
            frames = [sheet.crop((c * fw, r * fh, (c + 1) * fw, (r + 1) * fh)) for c in range(cols)]
            boxes = [f.getbbox() for f in frames if f.getbbox()]
            if not boxes:
                continue
            x0 = min(b[0] for b in boxes); y0 = min(b[1] for b in boxes)
            x1 = max(b[2] for b in boxes); y1 = max(b[3] for b in boxes)
            for i, f in enumerate(frames):
                f.crop((x0, y0, x1, y1)).save(os.path.join(OUT, f"{name}-{out_name}-{dkey}-{i}.png"))
    return True


print("Troceando frames…")
available = []  # (dex, name) en orden de Pokédex
for dex in sorted(meta):
    name = meta[dex][0]
    if slice_species(dex, name):
        available.append((dex, name))
    if len(available) % 80 == 0 and available:
        print(f"  {len(available)} listos…")

avail_names = {n for _, n in available}
print(f"OK: {len(available)} especies con sprites completos")


# ── 4. Generación de SpeciesData.swift ──────────────────────────────────
ordered = [n for _, n in available]
next_map = {
    src: [t for t in targets if t in avail_names]
    for src, targets in forward.items()
    if src in avail_names
}
next_map = {k: v for k, v in next_map.items() if v}

cases = "\n".join(f"    case {n}" for n in ordered)


def chunk_all(names, per=8):
    out = []
    for i in range(0, len(names), per):
        out.append("        " + ", ".join(f".{n}" for n in names[i:i + per]))
    return ",\n".join(out)


next_entries = ",\n".join(
    f"        .{src}: [" + ", ".join(f".{t}" for t in targets) + "]"
    for src, targets in sorted(next_map.items())
)

with open(SWIFT, "w") as f:
    f.write(f"""// Generado por tools/fetch_all.py — no editar a mano.
// Todos los Pokémon hasta la 5ª generación (Blanco/Negro) con sprites en PMDCollab.

enum Species: String {{
{cases}

    /// Evoluciones directas (puede haber varias, p. ej. Eevee).
    static let next: [Species: [Species]] = [
{next_entries}
    ]

    /// Pool completo: el héroe y los rivales salen de aquí, tengan o no evolución.
    static let all: [Species] = [
{chunk_all(ordered)}
    ]
}}
""")
print(f"Escrito {SWIFT} ({len(ordered)} casos, {len(next_map)} con evolución)")

# Lista para la web (marquesina + favicon aleatorio).
json.dump(ordered, open(DEX_JSON, "w"))
print(f"Escrito {DEX_JSON}")
