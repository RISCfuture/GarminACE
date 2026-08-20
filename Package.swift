// swift-tools-version:6.0

import PackageDescription

let approachableConcurrency: [SwiftSetting] = [
  .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
  .enableUpcomingFeature("InferIsolatedConformances")
]

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
    .package(url: "https://github.com/apple/swift-docc-plugin.git", from: "1.5.0"),
    .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.10.0")
  ],
  targets: [
    .target(
      name: "GarminACE",
      dependencies: ["SwiftScanner", "CryptoSwift"],
      resources: [.process("Localizable.xcstrings")],
      swiftSettings: approachableConcurrency
    ),
    .testTarget(
      name: "GarminACETests",
      dependencies: ["GarminACE"],
      resources: [.copy("Resources")],
      swiftSettings: approachableConcurrency
    )
  ],
  swiftLanguageModes: [.v5, .v6]
)
