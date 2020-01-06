// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "SSCustomTabbar",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "SSCustomTabbar", targets: ["SSCustomTabbar"])
    ],
    targets: [
        .target(name: "SSCustomTabbar", path: "SSCustomTabbar/Classes")
    ]
)

