// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "PokeBar",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "PokeBar",
            path: "Sources/PokeBar",
            resources: [.process("Resources")]
        )
    ]
)
