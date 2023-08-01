// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "TensorFlowLiteSwift",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(name: "TensorFlowLite", targets: ["TensorFlowLite"]),
    ],
    dependencies: [
        .package(url: "https://github.com/tensorflow/tensorflow.git", .exact("d8ce9f9c301d021a69953134185ab728c1c248d3")),
    ],
    targets: [
        .target(
            name: "TensorFlowLite",
            dependencies: ["TensorFlowLiteC"],
            path: "Sources",
            exclude: [
                "CoreMLDelegate.swift",
                "MetalDelegate.swift",
            ]
        ),
        .target(
            name: "TensorFlowLiteC",
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "TensorFlowLiteTests",
            dependencies: ["TensorFlowLite"],
            path: "Tests",
            exclude: ["MetalDelegateTests.swift"],
            resources: [
                .copy("testdata/add.bin"),
                .copy("testdata/add_quantized.bin"),
                .copy("testdata/multi_signatures.bin"),
            ]
        ),
        .testTarget(
            name: "TensorFlowLiteCTests",
            dependencies: ["TensorFlowLiteC"],
            path: "Tests",
            resources: [
                .copy("testdata/add.bin"),
                .copy("testdata/add_quantized.bin"),
                .copy("testdata/multi_add.bin"),
            ]
        ),
    ]
)
