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
    .library(
      name: "PageSheetPlus",
      targets: ["PageSheetPlus"]),
  ],
  dependencies: [
    .package(
      name: "ViewModifierBuilder",
      url: "https://github.com/ericlewis/ViewModifierBuilder", .upToNextMajor(from: "0.1.0"))
  ],
  targets: [
    .target(
      name: "PageSheet",
      dependencies: [],
      path: "./Sources/Core"),
    .target(
      name: "PageSheetPlus",
      dependencies: [
        "PageSheet",
        "ViewModifierBuilder"
      ]
    )
  ]
)
