// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
//
// Generated file. Do not edit.
//

import PackageDescription

let package = Package(
    name: "FlutterGeneratedPluginSwiftPackage",
    platforms: [
        .macOS("10.15")
    ],
    products: [
        .library(name: "FlutterGeneratedPluginSwiftPackage", type: .static, targets: ["FlutterGeneratedPluginSwiftPackage"])
    ],
    dependencies: [
        .package(name: "url_launcher_macos", path: "../.packages/url_launcher_macos-3.2.5"),
        .package(name: "shared_preferences_foundation", path: "../.packages/shared_preferences_foundation-2.5.6"),
        .package(name: "local_auth_darwin", path: "../.packages/local_auth_darwin-2.0.4"),
        .package(name: "path_provider_foundation", path: "../.packages/path_provider_foundation-2.5.1"),
        .package(name: "flutter_secure_storage_darwin", path: "../.packages/flutter_secure_storage_darwin-0.3.2"),
        .package(name: "flutter_appauth", path: "../.packages/flutter_appauth-12.0.0"),
        .package(name: "file_selector_macos", path: "../.packages/file_selector_macos-0.9.5"),
        .package(name: "file_picker", path: "../.packages/file_picker-11.0.2"),
        .package(name: "connectivity_plus", path: "../.packages/connectivity_plus-6.1.5"),
        .package(name: "FlutterFramework", path: "../.packages/FlutterFramework")
    ],
    targets: [
        .target(
            name: "FlutterGeneratedPluginSwiftPackage",
            dependencies: [
                .product(name: "url-launcher-macos", package: "url_launcher_macos"),
                .product(name: "shared-preferences-foundation", package: "shared_preferences_foundation"),
                .product(name: "local-auth-darwin", package: "local_auth_darwin"),
                .product(name: "path-provider-foundation", package: "path_provider_foundation"),
                .product(name: "flutter-secure-storage-darwin", package: "flutter_secure_storage_darwin"),
                .product(name: "flutter-appauth", package: "flutter_appauth"),
                .product(name: "file-selector-macos", package: "file_selector_macos"),
                .product(name: "file-picker", package: "file_picker"),
                .product(name: "connectivity-plus", package: "connectivity_plus"),
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ]
        )
    ]
)
