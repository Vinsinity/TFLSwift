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
        .package(url: "https://github.com/tensorflow/tensorflow.git", .exact("1e8f3f6a3e899fe75d3c394d4fe07f2c2b69e2ec")),
    ],
    targets: [
        .target(
            name: "TensorFlowLite",
            dependencies: ["TensorFlowLiteC", "TensorFlowLiteSwiftCore"],
            path: "tensorflow/lite/swift/Sources",
            exclude: [
                "CoreMLDelegate.swift",
                "MetalDelegate.swift",
            ]
        ),
        .target(
            name: "TensorFlowLiteC",
            dependencies: [],
            path: "tensorflow/lite/swift/Sources"
        ),
        .target(
            name: "TensorFlowLiteSwiftCore",
            dependencies: ["TensorFlowLiteC"],
            path: "tensorflow/lite/swift/Sources",
            sources: ["CoreMLDelegate.swift", "MetalDelegate.swift"]
        ),
        .testTarget(
            name: "TensorFlowLiteTests",
            dependencies: ["TensorFlowLite"],
            path: "tensorflow/lite/swift/Tests",
            exclude: ["MetalDelegateTests.swift"],
            resources: [
                .copy("tensorflow/lite/testdata/add.bin"),
                .copy("tensorflow/lite/testdata/add_quantized.bin"),
                .copy("tensorflow/lite/testdata/multi_signatures.bin"),
            ]
        ),
        .testTarget(
            name: "TensorFlowLiteSwiftCoreTests",
            dependencies: ["TensorFlowLiteSwiftCore"],
            path: "tensorflow/lite/swift/Tests",
            sources: ["InterpreterTests.swift", "MetalDelegateTests.swift"],
            resources: [
                .copy("tensorflow/lite/testdata/add.bin"),
                .copy("tensorflow/lite/testdata/add_quantized.bin"),
                .copy("tensorflow/lite/testdata/multi_add.bin"),
            ]
        ),
    ]
)
