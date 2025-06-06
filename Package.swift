// swift-tools-version:5.9
import PackageDescription

var targets: [Target] = [
    .target(
        name: "NexusFiles",
        dependencies: [
            "CoreXLSX",
            "SwiftCSV"
        ],
        path: "Sources",
        resources: [.process("Localization")]
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
        .library(name: "NexusFiles", targets: ["NexusFiles"])
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.9.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.6.0"),
    ],
    targets: targets
)
