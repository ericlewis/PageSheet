// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "BottomSheetView",
  platforms: [
    .iOS("15.0")
  ],
  products: [
    .library(
      name: "BottomSheetView",
      targets: ["BottomSheetView"]),
  ],
  dependencies: [],
  targets: [
    .target(
      name: "BottomSheetView",
      dependencies: [],
      path: "./Sources")
  ]
)
