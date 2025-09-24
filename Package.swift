// swift-tools-version:6.0

import PackageDescription

let package = Package(
  name: "GarminACE",
  defaultLocalization: "en",
  platforms: [.macOS(.v14), .iOS(.v17), .watchOS(.v10), .tvOS(.v17), .visionOS(.v1)],
  products: [
    .library(
      name: "GarminACE",
      targets: ["GarminACE"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/malcommac/SwiftScanner.git", from: "1.1.0"),
    .package(url: "https://github.com/Quick/Quick.git", from: "7.6.2"),
    .package(url: "https://github.com/Quick/Nimble.git", from: "13.7.1"),
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.4.3"),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.8.4")
  ],
  targets: [
    .target(
      name: "GarminACE",
      dependencies: ["SwiftScanner", "CryptoSwift"],
      resources: [.process("Localizable.xcstrings")]
    ),
    .testTarget(
      name: "GarminACETests",
      dependencies: ["GarminACE", "Nimble", "Quick"],
      resources: [.copy("Resources")]
    )
  ],
  swiftLanguageModes: [.v5, .v6]
)
