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
      targets: ["PageSheetCore", "PageSheetPlus"]),
    .library(
      name: "PageSheetCore",
      targets: ["PageSheetCore"]),
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
      name: "PageSheetCore",
      dependencies: [],
      path: "./Sources/Core"),
    .target(
      name: "PageSheetPlus",
      dependencies: [
        "PageSheetCore",
        "ViewModifierBuilder",
      ]
    ),
  ]
)
