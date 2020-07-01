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
    .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.3.2"),
    .package(path: "../SimpleHttpClient")
  ],
  targets: [
    .target(
      name: "EtvnetApi",
      dependencies: [
        "SwiftSoup",
//        "Files",
//        "Codextended",
        "SimpleHttpClient"
      ]),
    .testTarget(
      name: "EtvnetApiTests",
      dependencies: [
        "EtvnetApi"
      ]),
  ]
)
