// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWSignInWith3rd",
    platforms: [
        .iOS(.v12)
    ],
    products: [
        .library(name: "WWSignInWith3rd", targets: ["WWSignInWith3rd"]),
    ],
    dependencies: [
        .package(name: "WWNetworking", url: "https://github.com/William-Weng/WWNetworking.git", from: "1.0.0"),
        .package(name: "LineSDK", url: "https://github.com/line/line-sdk-ios-swift.git", from: "5.7.0"),
        .package(name: "Swifter", url: "https://github.com/mattdonnelly/Swifter.git", from: "2.5.0"),
    ],
    targets: [
        .target(name: "WWSignInWith3rd", dependencies: ["WWNetworking", "LineSDK", "Swifter"]),
        .testTarget(name: "WWSignInWith3rdTests", dependencies: ["WWSignInWith3rd"]),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
