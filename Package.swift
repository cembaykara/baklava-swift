// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "BaklavaSDK",
	platforms: [.iOS(.v14), .macOS(.v11)],
	products: [
		// Products define the executables and libraries a package produces, making them visible to other packages.
		.library(
			name: "BaklavaCore",
			targets: ["BaklavaCore"]),
		.library(
			name: "BaklavaServices",
			targets: ["BaklavaServices"]),
        .library(
            name: "BaklavaAuth",
            targets: ["BaklavaAuth"]),
	],
    dependencies: [
        .package(name: "JWTDecode", url: "https://github.com/auth0/JWTDecode.swift.git", .upToNextMajor(from: "3.1.0")),
    ],
	targets: [
		// Targets are the basic building blocks of a package, defining a module or a test suite.
		// Targets can depend on other targets in this package and products from dependencies.
		.target(
			name: "BaklavaCore",
            dependencies: ["JWTDecode"],
			path: "BaklavaCore"),
		.target(
			name: "BaklavaServices",
			dependencies: ["BaklavaCore"],
		path: "BaklavaServices"),
        .target(
            name: "BaklavaAuth",
            dependencies: ["BaklavaCore"],
            path: "BaklavaAuth")
	]
)
