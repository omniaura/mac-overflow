// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "MacOverflow",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(
            name: "MacOverflow",
            targets: ["MacOverflow"]
        )
    ],
    dependencies: [],
    targets: [
        .executableTarget(
            name: "MacOverflow",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "MacOverflowTests",
            dependencies: ["MacOverflow"],
            path: "Tests"
        )
    ]
)
