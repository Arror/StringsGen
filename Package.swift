// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "StringsGen",
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "4.2.5"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.9.0"),
        .package(url: "https://github.com/LittleRockInGitHub/LLRegex.git", from: "1.3.0"),
    ],
    targets: [
        .target(
            name: "StringsGen",
            dependencies: ["SWXMLHash", "PathKit", "LLRegex"]),
    ]
)
