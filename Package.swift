// swift-tools-version:5.9
import PackageDescription

// The share extension relies on UIKit and therefore can't build on non-Darwin
// platforms. We conditionally include that target only when UIKit is available.
#if os(iOS)
let package = Package(
    name: "NexusFiles",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "NexusFiles", targets: ["NexusFiles"])
    ],
    dependencies: [
        .package(url: "https://github.com/damuellen/xlsxwriter.swift", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "NexusFiles",
            dependencies: [
                .product(name: "xlsxwriter", package: "xlsxwriter.swift")
            ],
            path: "Sources"
        ),
        .target(
            name: "NexusFilesShareExtension",
            path: "ShareExtension"
        )
    ]
)
#else
let package = Package(
    name: "NexusFiles",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "NexusFiles", targets: ["NexusFiles"])
    ],
    dependencies: [
        .package(url: "https://github.com/damuellen/xlsxwriter.swift", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "NexusFiles",
            dependencies: [
                .product(name: "xlsxwriter", package: "xlsxwriter.swift")
            ],
            path: "Sources"
        )
    ]
)
#endif
