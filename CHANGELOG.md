# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-05-20
### Changed
- Updated README documentation to clarify the usage and behavior of `skipRegionList` and `onlyRegionList` parameters with improved comments and examples.

## [1.0.1] - 2025-05-20
### Changed
- Changed `getDeviceCountryCode()` to use `ui.PlatformDispatcher.instance.locale` instead of the deprecated `ui.window.locale` for better compatibility with Flutter 3.7+.
- Removed all `dart:io` dependencies to improve web platform support.

## [1.0.0] - 2025-05-20
### Added
- Initial release.
- Display privacy policy and consent page with a single line of code.
- Support for custom app icon, policy items, button text, and actions.
- Support for privacy policy/terms of service links.
- Region-based display logic (`skipRegionList`, `onlyRegionList`).
- Built-in shared_preferences support for consent persistence.
- Customizable `onAccept`/`onReject` callbacks.
- Flexible API for easy integration and extension.
