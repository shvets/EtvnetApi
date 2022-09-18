// swift-tools-version:5.7

import PackageDescription

let package = Package(
  name: "EtvnetApi",
  platforms: [
    .macOS(.v10_15),
    .iOS(.v15),
    .tvOS(.v15)
  ],
  products: [
    .library(name: "EtvnetApi", targets: ["EtvnetApi"])
  ],
  dependencies: [
    //.package(path: "../SimpleHttpClient"),
    .package(url: "https://github.com/shvets/SimpleHttpClient", from: "1.0.8"),
    .package(url: "https://github.com/scinfu/SwiftSoup", from: "2.3.2"),
    .package(url: "https://github.com/JohnSundell/Codextended", from: "0.3.0"),
    .package(url: "https://github.com/shvets/DiskStorage", from: "1.0.1"),
    //.package(path: "../DiskStorage"),
  ],
  targets: [
    .target(
      name: "EtvnetApi",
      dependencies: [
        "SimpleHttpClient",
        "SwiftSoup",
        "Codextended",
        "DiskStorage"
      ]),
    .testTarget(
      name: "EtvnetApiTests",
      dependencies: [
        "EtvnetApi"
      ]),
  ]
)
