// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "PageSheet",
  platforms: [
    .iOS("15.0")
  ],
  products: [
    .library(
      name: "PageSheet",
      targets: ["PageSheet"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "PageSheet",
      dependencies: [],
      path: "./Sources")
  ]
)
