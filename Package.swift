// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "MobileLLMPromptRefiner",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "MobileLLMPromptRefiner",
            targets: ["MobileLLMPromptRefiner"]
        ),
    ],
    dependencies: [
        // Core ML and Foundation Models framework dependencies
        .package(url: "https://github.com/tattn/LocalLLMClient.git", branch: "main"), // Consider pinning to tag or commit
        .package(url: "https://github.com/apple/swift-async-algorithms.git", from: "1.0.0"),
        .package(url: "https://github.com/pointfreeco/combine-schedulers", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "MobileLLMPromptRefiner",
            dependencies: [
                "LocalLLMClient",
                .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
                .product(name: "CombineSchedulers", package: "combine-schedulers"),
            ],
            resources: [
                .process("Resources/Models"),
                .process("Resources/Assets.xcassets"),
            ]
        ),
        .testTarget(
            name: "MobileLLMPromptRefinerTests",
            dependencies: ["MobileLLMPromptRefiner"]
        ),
    ]
)
