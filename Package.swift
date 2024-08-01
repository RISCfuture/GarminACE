// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GarminACE",
    defaultLocalization: "en",
    platforms: [.macOS(.v13), .iOS(.v16), .watchOS(.v9), .tvOS(.v16)],
    products: [
        .library(
            name: "GarminACE",
            targets: ["GarminACE"]),
    ],
    dependencies: [
        .package(url: "https://github.com/malcommac/SwiftScanner.git", from: "1.1.0"),
        .package(url: "https://github.com/Quick/Quick.git", from: "2.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "8.0.7"),
        .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.6.0")
    ],
    targets: [
        .target(
            name: "GarminACE",
            dependencies: ["SwiftScanner", "CryptoSwift"],
            resources: [.process("Resources")]),
        .testTarget(
            name: "GarminACETests",
            dependencies: ["GarminACE", "Nimble", "Quick"],
            resources: [.copy("Resources")])
    ]
)
