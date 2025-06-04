// swift-tools-version:5.9
import PackageDescription

#if os(Linux)
let package = Package(
    name: "NexusFiles",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(name: "NexusFiles", targets: ["NexusFiles"]),
        .executable(name: "NexusFilesMac", targets: ["NexusFilesMac"])
    ],
    dependencies: [
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.9.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "NexusFiles",
            dependencies: [
                "CoreXLSX",
                "SwiftCSV"
            ],
            path: "Sources",
            resources: [.process("Localization")]
        ),
        .executableTarget(
            name: "NexusFilesMac",
            dependencies: ["NexusFiles"],
            path: "MacApp"
        ),
        .testTarget(
            name: "NexusFilesTests",
            dependencies: ["NexusFiles"],
            path: "Tests"
        )
    ]
)
#else
let package = Package(
    name: "NexusFiles",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17), .macOS(.v14)
    ],
    products: [
        .library(name: "NexusFiles", targets: ["NexusFiles"]),
        .executable(name: "NexusFilesMac", targets: ["NexusFilesMac"])
    ],
    dependencies: [
        .package(url: "https://github.com/damuellen/xlsxwriter.swift", from: "1.0.0"),
        .package(url: "https://github.com/CoreOffice/CoreXLSX.git", from: "0.9.0"),
        .package(url: "https://github.com/swiftcsv/SwiftCSV.git", from: "0.6.0")
    ],
    targets: [
        .target(
            name: "NexusFiles",
            dependencies: [
                .product(name: "xlsxwriter", package: "xlsxwriter.swift"),
                "CoreXLSX",
                "SwiftCSV"
            ],
            path: "Sources",
            resources: [.process("Localization")]
        ),
        .executableTarget(
            name: "NexusFilesMac",
            dependencies: ["NexusFiles"],
            path: "MacApp"
        ),
        .target(
            name: "NexusFilesShareExtension",
            dependencies: ["NexusFiles"],
            path: "ShareExtension"
        ),
        .testTarget(
            name: "NexusFilesTests",
            dependencies: ["NexusFiles"],
            path: "Tests"
        )
    ]
)
#endif
