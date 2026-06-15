"""Descarga hojas de PMDCollab, las trocea en frames y genera SpeciesData.swift.

Uso: python fetch_pokemon.py
Las líneas que fallan (sprites incompletos) se truncan o descartan y se informa.
"""
import os
import re
import urllib.request
from PIL import Image

ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
OUT = os.path.join(ROOT, "Sources", "PokeBar", "Resources")
SWIFT = os.path.join(ROOT, "Sources", "PokeBar", "SpeciesData.swift")
CACHE = "/tmp/pmd"
BASE = "https://raw.githubusercontent.com/PMDCollab/SpriteCollab/master/sprite"

# Líneas evolutivas: (nombre, id de PMDCollab). Toda la generación 1 (151).
LINES = [
    [("bulbasaur", "0001"), ("ivysaur", "0002"), ("venusaur", "0003")],
    [("charmander", "0004"), ("charmeleon", "0005"), ("charizard", "0006")],
    [("squirtle", "0007"), ("wartortle", "0008"), ("blastoise", "0009")],
    [("caterpie", "0010"), ("metapod", "0011"), ("butterfree", "0012")],
    [("weedle", "0013"), ("kakuna", "0014"), ("beedrill", "0015")],
    [("pidgey", "0016"), ("pidgeotto", "0017"), ("pidgeot", "0018")],
    [("rattata", "0019"), ("raticate", "0020")],
    [("spearow", "0021"), ("fearow", "0022")],
    [("ekans", "0023"), ("arbok", "0024")],
    [("pikachu", "0025"), ("raichu", "0026")],
    [("sandshrew", "0027"), ("sandslash", "0028")],
    [("nidoranf", "0029"), ("nidorina", "0030"), ("nidoqueen", "0031")],
    [("nidoranm", "0032"), ("nidorino", "0033"), ("nidoking", "0034")],
    [("clefairy", "0035"), ("clefable", "0036")],
    [("vulpix", "0037"), ("ninetales", "0038")],
    [("jigglypuff", "0039"), ("wigglytuff", "0040")],
    [("zubat", "0041"), ("golbat", "0042")],
    [("oddish", "0043"), ("gloom", "0044"), ("vileplume", "0045")],
    [("paras", "0046"), ("parasect", "0047")],
    [("venonat", "0048"), ("venomoth", "0049")],
    [("diglett", "0050"), ("dugtrio", "0051")],
    [("meowth", "0052"), ("persian", "0053")],
    [("psyduck", "0054"), ("golduck", "0055")],
    [("mankey", "0056"), ("primeape", "0057")],
    [("growlithe", "0058"), ("arcanine", "0059")],
    [("poliwag", "0060"), ("poliwhirl", "0061"), ("poliwrath", "0062")],
    [("abra", "0063"), ("kadabra", "0064"), ("alakazam", "0065")],
    [("machop", "0066"), ("machoke", "0067"), ("machamp", "0068")],
    [("bellsprout", "0069"), ("weepinbell", "0070"), ("victreebel", "0071")],
    [("tentacool", "0072"), ("tentacruel", "0073")],
    [("geodude", "0074"), ("graveler", "0075"), ("golem", "0076")],
    [("ponyta", "0077"), ("rapidash", "0078")],
    [("slowpoke", "0079"), ("slowbro", "0080")],
    [("magnemite", "0081"), ("magneton", "0082")],
    [("farfetchd", "0083")],
    [("doduo", "0084"), ("dodrio", "0085")],
    [("seel", "0086"), ("dewgong", "0087")],
    [("grimer", "0088"), ("muk", "0089")],
    [("shellder", "0090"), ("cloyster", "0091")],
    [("gastly", "0092"), ("haunter", "0093"), ("gengar", "0094")],
    [("onix", "0095")],
    [("drowzee", "0096"), ("hypno", "0097")],
    [("krabby", "0098"), ("kingler", "0099")],
    [("voltorb", "0100"), ("electrode", "0101")],
    [("exeggcute", "0102"), ("exeggutor", "0103")],
    [("cubone", "0104"), ("marowak", "0105")],
    [("hitmonlee", "0106")],
    [("hitmonchan", "0107")],
    [("lickitung", "0108")],
    [("koffing", "0109"), ("weezing", "0110")],
    [("rhyhorn", "0111"), ("rhydon", "0112")],
    [("chansey", "0113")],
    [("tangela", "0114")],
    [("kangaskhan", "0115")],
    [("horsea", "0116"), ("seadra", "0117")],
    [("goldeen", "0118"), ("seaking", "0119")],
    [("staryu", "0120"), ("starmie", "0121")],
    [("mrmime", "0122")],
    [("scyther", "0123")],
    [("jynx", "0124")],
    [("electabuzz", "0125")],
    [("magmar", "0126")],
    [("pinsir", "0127")],
    [("tauros", "0128")],
    [("magikarp", "0129"), ("gyarados", "0130")],
    [("lapras", "0131")],
    [("ditto", "0132")],
    [("eevee", "0133"), ("vaporeon", "0134")],
    [("jolteon", "0135")],
    [("flareon", "0136")],
    [("porygon", "0137")],
    [("omanyte", "0138"), ("omastar", "0139")],
    [("kabuto", "0140"), ("kabutops", "0141")],
    [("aerodactyl", "0142")],
    [("snorlax", "0143")],
    [("articuno", "0144")],
    [("zapdos", "0145")],
    [("moltres", "0146")],
    [("dratini", "0147"), ("dragonair", "0148"), ("dragonite", "0149")],
    [("mewtwo", "0150")],
    [("mew", "0151")],
]

ANIMS = {"Walk": "walk", "Attack": "attack", "Hurt": "hurt"}
ROWS = {"r": 2, "l": 6}  # fila 2 mira a la derecha, fila 6 a la izquierda
FILES = ["AnimData.xml", "Walk-Anim.png", "Attack-Anim.png", "Hurt-Anim.png"]


def fetch(pid: str) -> bool:
    d = os.path.join(CACHE, pid)
    os.makedirs(d, exist_ok=True)
    for f in FILES:
        path = os.path.join(d, f)
        if os.path.exists(path) and os.path.getsize(path) > 0:
            continue
        try:
            urllib.request.urlretrieve(f"{BASE}/{pid}/{f}", path)
        except Exception:
            if os.path.exists(path):
                os.remove(path)
            return False
    return True


def slice_species(name: str, pid: str) -> bool:
    d = os.path.join(CACHE, pid)
    xml = open(os.path.join(d, "AnimData.xml")).read()
    sizes = {}
    for m in re.finditer(r"<Anim>(.*?)</Anim>", xml, re.S):
        a = m.group(1)
        n = re.search(r"<Name>(.*?)</Name>", a)
        fw = re.search(r"<FrameWidth>(\d+)</FrameWidth>", a)
        fh = re.search(r"<FrameHeight>(\d+)</FrameHeight>", a)
        if n and fw:
            sizes[n.group(1)] = (int(fw.group(1)), int(fh.group(1)))
    if not all(a in sizes for a in ANIMS):
        return False

    for anim, out_name in ANIMS.items():
        fw, fh = sizes[anim]
        sheet = Image.open(os.path.join(d, f"{anim}-Anim.png")).convert("RGBA")
        cols = sheet.width // fw
        rows = sheet.height // fh
        if cols == 0:
            return False
        for dkey, row in ROWS.items():
            r = row if rows == 8 else 0
            frames = [sheet.crop((c * fw, r * fh, (c + 1) * fw, (r + 1) * fh)) for c in range(cols)]
            boxes = [f.getbbox() for f in frames if f.getbbox()]
            if not boxes:
                return False
            x0 = min(b[0] for b in boxes); y0 = min(b[1] for b in boxes)
            x1 = max(b[2] for b in boxes); y1 = max(b[3] for b in boxes)
            for i, f in enumerate(frames):
                f.crop((x0, y0, x1, y1)).save(os.path.join(OUT, f"{name}-{out_name}-{dkey}-{i}.png"))
    return True


def main():
    os.makedirs(OUT, exist_ok=True)
    good_lines = []
    for line in LINES:
        ok_line = []
        for name, pid in line:
            if fetch(pid) and slice_species(name, pid):
                ok_line.append(name)
            else:
                print(f"  ✗ {name} ({pid}) incompleto — línea truncada aquí")
                break
        if ok_line:
            good_lines.append(ok_line)

    species = [s for line in good_lines for s in line]
    print(f"OK: {len(good_lines)} líneas, {len(species)} especies")

    cases = "\n".join(f"    case {s}" for s in species)
    lines_swift = ",\n".join(
        "        [" + ", ".join(f".{s}" for s in line) + "]" for line in good_lines
    )
    with open(SWIFT, "w") as f:
        f.write(f"""// Generado por tools/fetch_pokemon.py — no editar a mano.

enum Species: String {{
{cases}

    /// Líneas evolutivas disponibles para el héroe.
    static let lines: [[Species]] = [
{lines_swift},
    ]

    /// Pool completo del que salen los rivales aleatorios.
    static let all: [Species] = lines.flatMap {{ $0 }}
}}
""")
    print(f"Escrito {SWIFT}")


if __name__ == "__main__":
    main()
