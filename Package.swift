// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
	name: "niossl-trust-test",
	platforms: [
		.macOS(.v13),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.6.0"),
		.package(url: "https://github.com/vapor/vapor.git", from: "4.115.0"),
		.package(url: "https://github.com/swift-server/async-http-client.git", from: "1.26.0"),
		.package(url: "https://github.com/swift-server-community/mqtt-nio.git", .upToNextMajor(from: "2.0.0")),
	],
	targets: [
		.executableTarget(
			name: "server",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "Vapor", package: "vapor"),
			]
		),
		.executableTarget(
			name: "client",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "AsyncHTTPClient", package: "async-http-client"),
			]
		),
		.executableTarget(
			name: "mqtt-client",
			dependencies: [
				.product(name: "ArgumentParser", package: "swift-argument-parser"),
				.product(name: "MQTTNIO", package: "mqtt-nio"),
			]
		),
	]
)
