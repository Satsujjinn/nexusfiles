// swift-tools-version:5.9
import PackageDescription

var targets: [Target] = [
    .target(
        name: "NexusFiles",
        dependencies: [
            "CoreXLSX",
            "SwiftCSV",
            "ZIPFoundation"
        ],
        path: "Sources",
        resources: [.process("Localization")]
    ),
    .executableTarget(
        name: "NexusFilesMac",
        dependencies: ["NexusFiles"],
        path: "MacApp"
    ),
    .executableTarget(
        name: "NexusFilesCLI",
        dependencies: [
            "NexusFiles",
            .product(name: "ArgumentParser", package: "swift-argument-parser")
        ],
        path: "CLI"
    ),
    .testTarget(
        name: "NexusFilesTests",
        dependencies: ["NexusFiles"],
        path: "Tests"
    )
]

#if os(iOS)
targets.append(
    .target(
        name: "NexusFilesShareExtension",
        dependencies: ["NexusFiles"],
        path: "ShareExtension"
    )
)
#endif

let package = Package(
    name: "NexusFiles",
    defaultLocalization: "en",
    platforms: [
        .iOS("13"), .macOS("15")
    ],
    products: [
        .library(name: "NexusFiles", targets: ["NexusFiles"]),
        .executable(name: "NexusFilesMac", targets: ["NexusFilesMac"]),
        .executable(name: "nexusfiles", targets: ["NexusFilesCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.9.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.6.0"),
        .package(url: "https://github.com/weichsel/ZIPFoundation.git", branch: "feature/swift6"),
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.3.0")
    ],
    targets: targets
)
