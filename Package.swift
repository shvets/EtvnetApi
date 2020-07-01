// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "EtvnetApi",
  platforms: [
    .macOS(.v10_12),
    .iOS(.v10),
    .tvOS(.v10)
  ],
  products: [
    .library(name: "EtvnetApi", targets: ["EtvnetApi"])
  ],
  dependencies: [
    //.package(path: "../SimpleHttpClient")
    .package(url: "https://github.com/shvets/SimpleHttpClient.git", from: "1.0.4"),
    .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.3.2")
  ],
  targets: [
    .target(
      name: "EtvnetApi",
      dependencies: [
        "SimpleHttpClient",
        "SwiftSoup"
      ]),
    .testTarget(
      name: "EtvnetApiTests",
      dependencies: [
        "EtvnetApi"
      ]),
  ]
)
