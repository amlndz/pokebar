// Generado por tools/fetch_all.py — no editar a mano.
// Todos los Pokémon hasta la 5ª generación (Blanco/Negro) con sprites en PMDCollab.

enum Species: String {
    case bulbasaur
    case ivysaur
    case venusaur
    case charmander
    case charmeleon
    case charizard
    case squirtle
    case wartortle
    case blastoise
    case caterpie
    case metapod
    case butterfree
    case weedle
    case kakuna
    case beedrill
    case pidgey
    case pidgeotto
    case pidgeot
    case rattata
    case raticate
    case spearow
    case fearow
    case ekans
    case arbok
    case pikachu
    case raichu
    case sandshrew
    case sandslash
    case nidoranf
    case nidorina
    case nidoqueen
    case nidoranm
    case nidorino
    case nidoking
    case clefairy
    case clefable
    case vulpix
    case ninetales
    case jigglypuff
    case wigglytuff
    case zubat
    case golbat
    case oddish
    case gloom
    case vileplume
    case paras
    case parasect
    case venonat
    case venomoth
    case diglett
    case dugtrio
    case meowth
    case persian
    case psyduck
    case golduck
    case mankey
    case primeape
    case growlithe
    case arcanine
    case poliwag
    case poliwhirl
    case poliwrath
    case abra
    case kadabra
    case alakazam
    case machop
    case machoke
    case machamp
    case bellsprout
    case weepinbell
    case victreebel
    case tentacool
    case tentacruel
    case geodude
    case graveler
    case golem
    case ponyta
    case rapidash
    case slowpoke
    case slowbro
    case magnemite
    case magneton
    case farfetchd
    case doduo
    case dodrio
    case seel
    case dewgong
    case grimer
    case muk
    case shellder
    case cloyster
    case gastly
    case haunter
    case gengar
    case onix
    case drowzee
    case hypno
    case krabby
    case kingler
    case voltorb
    case electrode
    case exeggcute
    case exeggutor
    case cubone
    case marowak
    case hitmonlee
    case hitmonchan
    case lickitung
    case koffing
    case weezing
    case rhyhorn
    case rhydon
    case chansey
    case tangela
    case kangaskhan
    case horsea
    case seadra
    case goldeen
    case seaking
    case staryu
    case starmie
    case mrmime
    case scyther
    case jynx
    case electabuzz
    case magmar
    case pinsir
    case tauros
    case magikarp
    case gyarados
    case lapras
    case ditto
    case eevee
    case vaporeon
    case jolteon
    case flareon
    case porygon
    case omanyte
    case omastar
    case kabuto
    case kabutops
    case aerodactyl
    case snorlax
    case articuno
    case zapdos
    case moltres
    case dratini
    case dragonair
    case dragonite
    case mewtwo
    case mew
    case chikorita
    case bayleef
    case meganium
    case cyndaquil
    case quilava
    case typhlosion
    case totodile
    case croconaw
    case feraligatr
    case sentret
    case furret
    case hoothoot
    case noctowl
    case ledyba
    case ledian
    case spinarak
    case ariados
    case crobat
    case chinchou
    case lanturn
    case pichu
    case cleffa
    case igglybuff
    case togepi
    case togetic
    case natu
    case xatu
    case mareep
    case flaaffy
    case ampharos
    case bellossom
    case marill
    case azumarill
    case sudowoodo
    case politoed
    case hoppip
    case skiploom
    case jumpluff
    case aipom
    case sunkern
    case sunflora
    case yanma
    case wooper
    case quagsire
    case espeon
    case umbreon
    case murkrow
    case slowking
    case misdreavus
    case unown
    case wobbuffet
    case girafarig
    case pineco
    case forretress
    case dunsparce
    case gligar
    case steelix
    case snubbull
    case granbull
    case qwilfish
    case scizor
    case shuckle
    case heracross
    case sneasel
    case teddiursa
    case ursaring
    case slugma
    case magcargo
    case swinub
    case piloswine
    case corsola
    case remoraid
    case octillery
    case delibird
    case mantine
    case skarmory
    case houndour
    case houndoom
    case kingdra
    case phanpy
    case donphan
    case porygon2
    case stantler
    case smeargle
    case tyrogue
    case hitmontop
    case smoochum
    case elekid
    case magby
    case miltank
    case blissey
    case raikou
    case entei
    case suicune
    case larvitar
    case pupitar
    case tyranitar
    case lugia
    case hooh
    case celebi
    case treecko
    case grovyle
    case sceptile
    case torchic
    case combusken
    case blaziken
    case mudkip
    case marshtomp
    case swampert
    case poochyena
    case mightyena
    case zigzagoon
    case linoone
    case wurmple
    case silcoon
    case beautifly
    case cascoon
    case dustox
    case lotad
    case lombre
    case ludicolo
    case seedot
    case nuzleaf
    case shiftry
    case taillow
    case swellow
    case wingull
    case pelipper
    case ralts
    case kirlia
    case gardevoir
    case surskit
    case masquerain
    case shroomish
    case breloom
    case slakoth
    case vigoroth
    case slaking
    case nincada
    case ninjask
    case shedinja
    case whismur
    case loudred
    case exploud
    case makuhita
    case hariyama
    case azurill
    case nosepass
    case skitty
    case delcatty
    case sableye
    case mawile
    case aron
    case lairon
    case aggron
    case meditite
    case medicham
    case electrike
    case manectric
    case plusle
    case minun
    case volbeat
    case illumise
    case roselia
    case gulpin
    case swalot
    case carvanha
    case sharpedo
    case wailmer
    case wailord
    case numel
    case camerupt
    case torkoal
    case spoink
    case grumpig
    case spinda
    case trapinch
    case vibrava
    case flygon
    case cacnea
    case cacturne
    case swablu
    case altaria
    case zangoose
    case seviper
    case lunatone
    case solrock
    case barboach
    case whiscash
    case corphish
    case crawdaunt
    case baltoy
    case claydol
    case lileep
    case cradily
    case anorith
    case armaldo
    case feebas
    case milotic
    case castform
    case kecleon
    case shuppet
    case banette
    case duskull
    case dusclops
    case tropius
    case chimecho
    case absol
    case wynaut
    case snorunt
    case glalie
    case spheal
    case sealeo
    case walrein
    case clamperl
    case huntail
    case gorebyss
    case relicanth
    case luvdisc
    case bagon
    case shelgon
    case salamence
    case beldum
    case metang
    case metagross
    case regirock
    case regice
    case registeel
    case latias
    case latios
    case kyogre
    case groudon
    case rayquaza
    case jirachi
    case deoxys
    case turtwig
    case grotle
    case torterra
    case chimchar
    case monferno
    case infernape
    case piplup
    case prinplup
    case empoleon
    case starly
    case staravia
    case staraptor
    case bidoof
    case bibarel
    case kricketot
    case kricketune
    case shinx
    case luxio
    case luxray
    case budew
    case roserade
    case cranidos
    case rampardos
    case shieldon
    case bastiodon
    case burmy
    case wormadam
    case mothim
    case combee
    case vespiquen
    case pachirisu
    case buizel
    case floatzel
    case cherubi
    case cherrim
    case shellos
    case gastrodon
    case ambipom
    case drifloon
    case drifblim
    case buneary
    case lopunny
    case mismagius
    case honchkrow
    case glameow
    case purugly
    case chingling
    case stunky
    case skuntank
    case bronzor
    case bronzong
    case bonsly
    case mimejr
    case happiny
    case chatot
    case spiritomb
    case gible
    case gabite
    case garchomp
    case munchlax
    case riolu
    case lucario
    case hippopotas
    case hippowdon
    case skorupi
    case drapion
    case croagunk
    case toxicroak
    case carnivine
    case finneon
    case lumineon
    case mantyke
    case snover
    case abomasnow
    case weavile
    case magnezone
    case lickilicky
    case rhyperior
    case tangrowth
    case electivire
    case magmortar
    case togekiss
    case yanmega
    case leafeon
    case glaceon
    case gliscor
    case mamoswine
    case porygonz
    case gallade
    case probopass
    case dusknoir
    case froslass
    case rotom
    case uxie
    case mesprit
    case azelf
    case dialga
    case palkia
    case heatran
    case regigigas
    case giratina
    case cresselia
    case phione
    case manaphy
    case darkrai
    case shaymin
    case arceus
    case victini
    case snivy
    case servine
    case serperior
    case tepig
    case pignite
    case emboar
    case oshawott
    case dewott
    case samurott
    case patrat
    case watchog
    case lillipup
    case herdier
    case stoutland
    case purrloin
    case liepard
    case pansage
    case simisage
    case pansear
    case panpour
    case munna
    case musharna
    case pidove
    case unfezant
    case roggenrola
    case boldore
    case gigalith
    case woobat
    case swoobat
    case drilbur
    case excadrill
    case audino
    case timburr
    case gurdurr
    case conkeldurr
    case tympole
    case palpitoad
    case seismitoad
    case sawk
    case sewaddle
    case swadloon
    case leavanny
    case venipede
    case whirlipede
    case scolipede
    case cottonee
    case whimsicott
    case petilil
    case lilligant
    case basculin
    case sandile
    case krokorok
    case krookodile
    case darumaka
    case darmanitan
    case maractus
    case dwebble
    case scraggy
    case scrafty
    case sigilyph
    case yamask
    case cofagrigus
    case archen
    case archeops
    case trubbish
    case garbodor
    case zorua
    case zoroark
    case minccino
    case cinccino
    case gothita
    case gothorita
    case gothitelle
    case solosis
    case duosion
    case reuniclus
    case ducklett
    case swanna
    case vanillite
    case vanillish
    case vanilluxe
    case deerling
    case sawsbuck
    case emolga
    case karrablast
    case escavalier
    case foongus
    case alomomola
    case joltik
    case galvantula
    case ferroseed
    case ferrothorn
    case klink
    case klang
    case klinklang
    case tynamo
    case eelektrik
    case eelektross
    case elgyem
    case beheeyem
    case litwick
    case lampent
    case chandelure
    case axew
    case fraxure
    case haxorus
    case cubchoo
    case beartic
    case cryogonal
    case accelgor
    case mienfoo
    case mienshao
    case druddigon
    case golett
    case golurk
    case pawniard
    case bisharp
    case rufflet
    case braviary
    case vullaby
    case mandibuzz
    case heatmor
    case durant
    case deino
    case zweilous
    case hydreigon
    case larvesta
    case volcarona
    case cobalion
    case terrakion
    case virizion
    case tornadus
    case thundurus
    case reshiram
    case zekrom
    case landorus
    case kyurem
    case keldeo
    case meloetta
    case genesect

    /// Evoluciones directas (puede haber varias, p. ej. Eevee).
    static let next: [Species: [Species]] = [
        .abra: [.kadabra],
        .aipom: [.ambipom],
        .anorith: [.armaldo],
        .archen: [.archeops],
        .aron: [.lairon],
        .axew: [.fraxure],
        .azurill: [.marill],
        .bagon: [.shelgon],
        .baltoy: [.claydol],
        .barboach: [.whiscash],
        .bayleef: [.meganium],
        .beldum: [.metang],
        .bellsprout: [.weepinbell],
        .bidoof: [.bibarel],
        .boldore: [.gigalith],
        .bonsly: [.sudowoodo],
        .bronzor: [.bronzong],
        .budew: [.roselia],
        .buizel: [.floatzel],
        .bulbasaur: [.ivysaur],
        .buneary: [.lopunny],
        .burmy: [.wormadam, .mothim],
        .cacnea: [.cacturne],
        .carvanha: [.sharpedo],
        .cascoon: [.dustox],
        .caterpie: [.metapod],
        .chansey: [.blissey],
        .charmander: [.charmeleon],
        .charmeleon: [.charizard],
        .cherubi: [.cherrim],
        .chikorita: [.bayleef],
        .chimchar: [.monferno],
        .chinchou: [.lanturn],
        .chingling: [.chimecho],
        .clamperl: [.huntail, .gorebyss],
        .clefairy: [.clefable],
        .cleffa: [.clefairy],
        .combee: [.vespiquen],
        .combusken: [.blaziken],
        .corphish: [.crawdaunt],
        .cottonee: [.whimsicott],
        .cranidos: [.rampardos],
        .croagunk: [.toxicroak],
        .croconaw: [.feraligatr],
        .cubchoo: [.beartic],
        .cubone: [.marowak],
        .cyndaquil: [.quilava],
        .darumaka: [.darmanitan],
        .deerling: [.sawsbuck],
        .deino: [.zweilous],
        .dewott: [.samurott],
        .diglett: [.dugtrio],
        .doduo: [.dodrio],
        .dragonair: [.dragonite],
        .dratini: [.dragonair],
        .drifloon: [.drifblim],
        .drilbur: [.excadrill],
        .drowzee: [.hypno],
        .ducklett: [.swanna],
        .duosion: [.reuniclus],
        .dusclops: [.dusknoir],
        .duskull: [.dusclops],
        .eelektrik: [.eelektross],
        .eevee: [.vaporeon, .jolteon, .flareon, .espeon, .umbreon, .leafeon, .glaceon],
        .ekans: [.arbok],
        .electabuzz: [.electivire],
        .electrike: [.manectric],
        .elekid: [.electabuzz],
        .elgyem: [.beheeyem],
        .exeggcute: [.exeggutor],
        .feebas: [.milotic],
        .ferroseed: [.ferrothorn],
        .finneon: [.lumineon],
        .flaaffy: [.ampharos],
        .fraxure: [.haxorus],
        .gabite: [.garchomp],
        .gastly: [.haunter],
        .geodude: [.graveler],
        .gible: [.gabite],
        .glameow: [.purugly],
        .gligar: [.gliscor],
        .gloom: [.vileplume, .bellossom],
        .golbat: [.crobat],
        .goldeen: [.seaking],
        .golett: [.golurk],
        .gothita: [.gothorita],
        .gothorita: [.gothitelle],
        .graveler: [.golem],
        .grimer: [.muk],
        .grotle: [.torterra],
        .grovyle: [.sceptile],
        .growlithe: [.arcanine],
        .gulpin: [.swalot],
        .gurdurr: [.conkeldurr],
        .happiny: [.chansey],
        .haunter: [.gengar],
        .herdier: [.stoutland],
        .hippopotas: [.hippowdon],
        .hoothoot: [.noctowl],
        .hoppip: [.skiploom],
        .horsea: [.seadra],
        .houndour: [.houndoom],
        .igglybuff: [.jigglypuff],
        .ivysaur: [.venusaur],
        .jigglypuff: [.wigglytuff],
        .joltik: [.galvantula],
        .kabuto: [.kabutops],
        .kadabra: [.alakazam],
        .kakuna: [.beedrill],
        .karrablast: [.escavalier],
        .kirlia: [.gardevoir, .gallade],
        .klang: [.klinklang],
        .klink: [.klang],
        .koffing: [.weezing],
        .krabby: [.kingler],
        .kricketot: [.kricketune],
        .krokorok: [.krookodile],
        .lairon: [.aggron],
        .lampent: [.chandelure],
        .larvesta: [.volcarona],
        .larvitar: [.pupitar],
        .ledyba: [.ledian],
        .lickitung: [.lickilicky],
        .lileep: [.cradily],
        .lillipup: [.herdier],
        .litwick: [.lampent],
        .lombre: [.ludicolo],
        .lotad: [.lombre],
        .loudred: [.exploud],
        .luxio: [.luxray],
        .machoke: [.machamp],
        .machop: [.machoke],
        .magby: [.magmar],
        .magikarp: [.gyarados],
        .magmar: [.magmortar],
        .magnemite: [.magneton],
        .magneton: [.magnezone],
        .makuhita: [.hariyama],
        .mankey: [.primeape],
        .mantyke: [.mantine],
        .mareep: [.flaaffy],
        .marill: [.azumarill],
        .marshtomp: [.swampert],
        .meditite: [.medicham],
        .meowth: [.persian],
        .metang: [.metagross],
        .metapod: [.butterfree],
        .mienfoo: [.mienshao],
        .mimejr: [.mrmime],
        .minccino: [.cinccino],
        .misdreavus: [.mismagius],
        .monferno: [.infernape],
        .mudkip: [.marshtomp],
        .munchlax: [.snorlax],
        .munna: [.musharna],
        .murkrow: [.honchkrow],
        .natu: [.xatu],
        .nidoranf: [.nidorina],
        .nidoranm: [.nidorino],
        .nidorina: [.nidoqueen],
        .nidorino: [.nidoking],
        .nincada: [.ninjask, .shedinja],
        .nosepass: [.probopass],
        .numel: [.camerupt],
        .nuzleaf: [.shiftry],
        .oddish: [.gloom],
        .omanyte: [.omastar],
        .onix: [.steelix],
        .oshawott: [.dewott],
        .palpitoad: [.seismitoad],
        .pansage: [.simisage],
        .paras: [.parasect],
        .patrat: [.watchog],
        .pawniard: [.bisharp],
        .petilil: [.lilligant],
        .phanpy: [.donphan],
        .pichu: [.pikachu],
        .pidgeotto: [.pidgeot],
        .pidgey: [.pidgeotto],
        .pignite: [.emboar],
        .pikachu: [.raichu],
        .piloswine: [.mamoswine],
        .pineco: [.forretress],
        .piplup: [.prinplup],
        .poliwag: [.poliwhirl],
        .poliwhirl: [.poliwrath, .politoed],
        .ponyta: [.rapidash],
        .poochyena: [.mightyena],
        .porygon: [.porygon2],
        .porygon2: [.porygonz],
        .prinplup: [.empoleon],
        .psyduck: [.golduck],
        .pupitar: [.tyranitar],
        .purrloin: [.liepard],
        .quilava: [.typhlosion],
        .ralts: [.kirlia],
        .rattata: [.raticate],
        .remoraid: [.octillery],
        .rhydon: [.rhyperior],
        .rhyhorn: [.rhydon],
        .riolu: [.lucario],
        .roggenrola: [.boldore],
        .roselia: [.roserade],
        .rufflet: [.braviary],
        .sandile: [.krokorok],
        .sandshrew: [.sandslash],
        .scraggy: [.scrafty],
        .scyther: [.scizor],
        .seadra: [.kingdra],
        .sealeo: [.walrein],
        .seedot: [.nuzleaf],
        .seel: [.dewgong],
        .sentret: [.furret],
        .servine: [.serperior],
        .sewaddle: [.swadloon],
        .shelgon: [.salamence],
        .shellder: [.cloyster],
        .shellos: [.gastrodon],
        .shieldon: [.bastiodon],
        .shinx: [.luxio],
        .shroomish: [.breloom],
        .shuppet: [.banette],
        .silcoon: [.beautifly],
        .skiploom: [.jumpluff],
        .skitty: [.delcatty],
        .skorupi: [.drapion],
        .slakoth: [.vigoroth],
        .slowpoke: [.slowbro, .slowking],
        .slugma: [.magcargo],
        .smoochum: [.jynx],
        .sneasel: [.weavile],
        .snivy: [.servine],
        .snorunt: [.glalie, .froslass],
        .snover: [.abomasnow],
        .snubbull: [.granbull],
        .solosis: [.duosion],
        .spearow: [.fearow],
        .spheal: [.sealeo],
        .spinarak: [.ariados],
        .spoink: [.grumpig],
        .squirtle: [.wartortle],
        .staravia: [.staraptor],
        .starly: [.staravia],
        .staryu: [.starmie],
        .stunky: [.skuntank],
        .sunkern: [.sunflora],
        .surskit: [.masquerain],
        .swablu: [.altaria],
        .swadloon: [.leavanny],
        .swinub: [.piloswine],
        .taillow: [.swellow],
        .tangela: [.tangrowth],
        .teddiursa: [.ursaring],
        .tentacool: [.tentacruel],
        .tepig: [.pignite],
        .timburr: [.gurdurr],
        .togepi: [.togetic],
        .togetic: [.togekiss],
        .torchic: [.combusken],
        .totodile: [.croconaw],
        .trapinch: [.vibrava],
        .treecko: [.grovyle],
        .trubbish: [.garbodor],
        .turtwig: [.grotle],
        .tympole: [.palpitoad],
        .tynamo: [.eelektrik],
        .tyrogue: [.hitmonlee, .hitmonchan, .hitmontop],
        .vanillish: [.vanilluxe],
        .vanillite: [.vanillish],
        .venipede: [.whirlipede],
        .venonat: [.venomoth],
        .vibrava: [.flygon],
        .vigoroth: [.slaking],
        .voltorb: [.electrode],
        .vullaby: [.mandibuzz],
        .vulpix: [.ninetales],
        .wailmer: [.wailord],
        .wartortle: [.blastoise],
        .weedle: [.kakuna],
        .weepinbell: [.victreebel],
        .whirlipede: [.scolipede],
        .whismur: [.loudred],
        .wingull: [.pelipper],
        .woobat: [.swoobat],
        .wooper: [.quagsire],
        .wurmple: [.silcoon, .cascoon],
        .wynaut: [.wobbuffet],
        .yamask: [.cofagrigus],
        .yanma: [.yanmega],
        .zigzagoon: [.linoone],
        .zorua: [.zoroark],
        .zubat: [.golbat],
        .zweilous: [.hydreigon]
    ]

    /// Pool completo: el héroe y los rivales salen de aquí, tengan o no evolución.
    static let all: [Species] = [
        .bulbasaur, .ivysaur, .venusaur, .charmander, .charmeleon, .charizard, .squirtle, .wartortle,
        .blastoise, .caterpie, .metapod, .butterfree, .weedle, .kakuna, .beedrill, .pidgey,
        .pidgeotto, .pidgeot, .rattata, .raticate, .spearow, .fearow, .ekans, .arbok,
        .pikachu, .raichu, .sandshrew, .sandslash, .nidoranf, .nidorina, .nidoqueen, .nidoranm,
        .nidorino, .nidoking, .clefairy, .clefable, .vulpix, .ninetales, .jigglypuff, .wigglytuff,
        .zubat, .golbat, .oddish, .gloom, .vileplume, .paras, .parasect, .venonat,
        .venomoth, .diglett, .dugtrio, .meowth, .persian, .psyduck, .golduck, .mankey,
        .primeape, .growlithe, .arcanine, .poliwag, .poliwhirl, .poliwrath, .abra, .kadabra,
        .alakazam, .machop, .machoke, .machamp, .bellsprout, .weepinbell, .victreebel, .tentacool,
        .tentacruel, .geodude, .graveler, .golem, .ponyta, .rapidash, .slowpoke, .slowbro,
        .magnemite, .magneton, .farfetchd, .doduo, .dodrio, .seel, .dewgong, .grimer,
        .muk, .shellder, .cloyster, .gastly, .haunter, .gengar, .onix, .drowzee,
        .hypno, .krabby, .kingler, .voltorb, .electrode, .exeggcute, .exeggutor, .cubone,
        .marowak, .hitmonlee, .hitmonchan, .lickitung, .koffing, .weezing, .rhyhorn, .rhydon,
        .chansey, .tangela, .kangaskhan, .horsea, .seadra, .goldeen, .seaking, .staryu,
        .starmie, .mrmime, .scyther, .jynx, .electabuzz, .magmar, .pinsir, .tauros,
        .magikarp, .gyarados, .lapras, .ditto, .eevee, .vaporeon, .jolteon, .flareon,
        .porygon, .omanyte, .omastar, .kabuto, .kabutops, .aerodactyl, .snorlax, .articuno,
        .zapdos, .moltres, .dratini, .dragonair, .dragonite, .mewtwo, .mew, .chikorita,
        .bayleef, .meganium, .cyndaquil, .quilava, .typhlosion, .totodile, .croconaw, .feraligatr,
        .sentret, .furret, .hoothoot, .noctowl, .ledyba, .ledian, .spinarak, .ariados,
        .crobat, .chinchou, .lanturn, .pichu, .cleffa, .igglybuff, .togepi, .togetic,
        .natu, .xatu, .mareep, .flaaffy, .ampharos, .bellossom, .marill, .azumarill,
        .sudowoodo, .politoed, .hoppip, .skiploom, .jumpluff, .aipom, .sunkern, .sunflora,
        .yanma, .wooper, .quagsire, .espeon, .umbreon, .murkrow, .slowking, .misdreavus,
        .unown, .wobbuffet, .girafarig, .pineco, .forretress, .dunsparce, .gligar, .steelix,
        .snubbull, .granbull, .qwilfish, .scizor, .shuckle, .heracross, .sneasel, .teddiursa,
        .ursaring, .slugma, .magcargo, .swinub, .piloswine, .corsola, .remoraid, .octillery,
        .delibird, .mantine, .skarmory, .houndour, .houndoom, .kingdra, .phanpy, .donphan,
        .porygon2, .stantler, .smeargle, .tyrogue, .hitmontop, .smoochum, .elekid, .magby,
        .miltank, .blissey, .raikou, .entei, .suicune, .larvitar, .pupitar, .tyranitar,
        .lugia, .hooh, .celebi, .treecko, .grovyle, .sceptile, .torchic, .combusken,
        .blaziken, .mudkip, .marshtomp, .swampert, .poochyena, .mightyena, .zigzagoon, .linoone,
        .wurmple, .silcoon, .beautifly, .cascoon, .dustox, .lotad, .lombre, .ludicolo,
        .seedot, .nuzleaf, .shiftry, .taillow, .swellow, .wingull, .pelipper, .ralts,
        .kirlia, .gardevoir, .surskit, .masquerain, .shroomish, .breloom, .slakoth, .vigoroth,
        .slaking, .nincada, .ninjask, .shedinja, .whismur, .loudred, .exploud, .makuhita,
        .hariyama, .azurill, .nosepass, .skitty, .delcatty, .sableye, .mawile, .aron,
        .lairon, .aggron, .meditite, .medicham, .electrike, .manectric, .plusle, .minun,
        .volbeat, .illumise, .roselia, .gulpin, .swalot, .carvanha, .sharpedo, .wailmer,
        .wailord, .numel, .camerupt, .torkoal, .spoink, .grumpig, .spinda, .trapinch,
        .vibrava, .flygon, .cacnea, .cacturne, .swablu, .altaria, .zangoose, .seviper,
        .lunatone, .solrock, .barboach, .whiscash, .corphish, .crawdaunt, .baltoy, .claydol,
        .lileep, .cradily, .anorith, .armaldo, .feebas, .milotic, .castform, .kecleon,
        .shuppet, .banette, .duskull, .dusclops, .tropius, .chimecho, .absol, .wynaut,
        .snorunt, .glalie, .spheal, .sealeo, .walrein, .clamperl, .huntail, .gorebyss,
        .relicanth, .luvdisc, .bagon, .shelgon, .salamence, .beldum, .metang, .metagross,
        .regirock, .regice, .registeel, .latias, .latios, .kyogre, .groudon, .rayquaza,
        .jirachi, .deoxys, .turtwig, .grotle, .torterra, .chimchar, .monferno, .infernape,
        .piplup, .prinplup, .empoleon, .starly, .staravia, .staraptor, .bidoof, .bibarel,
        .kricketot, .kricketune, .shinx, .luxio, .luxray, .budew, .roserade, .cranidos,
        .rampardos, .shieldon, .bastiodon, .burmy, .wormadam, .mothim, .combee, .vespiquen,
        .pachirisu, .buizel, .floatzel, .cherubi, .cherrim, .shellos, .gastrodon, .ambipom,
        .drifloon, .drifblim, .buneary, .lopunny, .mismagius, .honchkrow, .glameow, .purugly,
        .chingling, .stunky, .skuntank, .bronzor, .bronzong, .bonsly, .mimejr, .happiny,
        .chatot, .spiritomb, .gible, .gabite, .garchomp, .munchlax, .riolu, .lucario,
        .hippopotas, .hippowdon, .skorupi, .drapion, .croagunk, .toxicroak, .carnivine, .finneon,
        .lumineon, .mantyke, .snover, .abomasnow, .weavile, .magnezone, .lickilicky, .rhyperior,
        .tangrowth, .electivire, .magmortar, .togekiss, .yanmega, .leafeon, .glaceon, .gliscor,
        .mamoswine, .porygonz, .gallade, .probopass, .dusknoir, .froslass, .rotom, .uxie,
        .mesprit, .azelf, .dialga, .palkia, .heatran, .regigigas, .giratina, .cresselia,
        .phione, .manaphy, .darkrai, .shaymin, .arceus, .victini, .snivy, .servine,
        .serperior, .tepig, .pignite, .emboar, .oshawott, .dewott, .samurott, .patrat,
        .watchog, .lillipup, .herdier, .stoutland, .purrloin, .liepard, .pansage, .simisage,
        .pansear, .panpour, .munna, .musharna, .pidove, .unfezant, .roggenrola, .boldore,
        .gigalith, .woobat, .swoobat, .drilbur, .excadrill, .audino, .timburr, .gurdurr,
        .conkeldurr, .tympole, .palpitoad, .seismitoad, .sawk, .sewaddle, .swadloon, .leavanny,
        .venipede, .whirlipede, .scolipede, .cottonee, .whimsicott, .petilil, .lilligant, .basculin,
        .sandile, .krokorok, .krookodile, .darumaka, .darmanitan, .maractus, .dwebble, .scraggy,
        .scrafty, .sigilyph, .yamask, .cofagrigus, .archen, .archeops, .trubbish, .garbodor,
        .zorua, .zoroark, .minccino, .cinccino, .gothita, .gothorita, .gothitelle, .solosis,
        .duosion, .reuniclus, .ducklett, .swanna, .vanillite, .vanillish, .vanilluxe, .deerling,
        .sawsbuck, .emolga, .karrablast, .escavalier, .foongus, .alomomola, .joltik, .galvantula,
        .ferroseed, .ferrothorn, .klink, .klang, .klinklang, .tynamo, .eelektrik, .eelektross,
        .elgyem, .beheeyem, .litwick, .lampent, .chandelure, .axew, .fraxure, .haxorus,
        .cubchoo, .beartic, .cryogonal, .accelgor, .mienfoo, .mienshao, .druddigon, .golett,
        .golurk, .pawniard, .bisharp, .rufflet, .braviary, .vullaby, .mandibuzz, .heatmor,
        .durant, .deino, .zweilous, .hydreigon, .larvesta, .volcarona, .cobalion, .terrakion,
        .virizion, .tornadus, .thundurus, .reshiram, .zekrom, .landorus, .kyurem, .keldeo,
        .meloetta, .genesect
    ]

    /// Formas base (no son evolución de nadie): el héroe siempre empieza aquí.
    static let firstStage: [Species] = {
        let evolved = Set(next.values.flatMap { $0 })
        return all.filter { !evolved.contains($0) }
    }()
}
