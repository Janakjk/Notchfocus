// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NotchFocus",
    platforms: [
        .macOS(.v13)
    ],
    targets: [
        .executableTarget(
            name: "NotchFocus",
            path: "Sources/NotchFocus"
        )
    ]
)

