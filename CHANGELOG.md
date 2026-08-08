# Changelog

All notable changes to this project will be documented in this file.

## [1.4.0] - 2026-08-08

### Fixed
- **Traditional Chinese devices got a Simplified title and an English body.**
  Reported from a real device running a Traditional Chinese system language.

  Flutter hands you **script-based** locales, but content maps are keyed by
  **country**: a Traditional Chinese device resolves to
  `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')` — and its
  **`countryCode` is `null`**. Every locale path in this package looked only at
  `languageCode` + `countryCode`, so it produced plain `'zh'`, matched no key in
  a `{en, zh_TW, zh_CN}` map, and fell through to the English fallback.

  Three call sites were wrong, and each failed differently:
  - `_getCurrentLocale()` dropped the script before matching even started
  - `PolicyItem.getText()` and `PrivacyPolicyLocalization.getLocalization()`
    then matched country-only keys
  - `_normalizeLocale('zh-Hant-CN')` took *first + last* and answered `zh_CN`
    — backwards; `zh-Hant` alone became the meaningless key `zh_HANT`

  Two rules now govern all of them:
  1. **Script beats country.** `zh-Hant-CN` is Traditional — the user chose the
     script; the region only says where they are.
  2. **Try a candidate chain, not a single key.** `zh_HK` and `zh_MO` reach
     `zh_TW` before giving up, so Hong Kong and Macau users stop seeing English.

- `getDeviceLocale()` had the same country-only hole and now returns `zh_TW`
  (not `zh`) on a Traditional Chinese device.

### Added
- `normalizeLocale()`, `localeCandidates()` and `resolveFromMap()` are exported
  so apps can resolve their own content maps the same way.

### Notes
- No API changes; existing callers keep working. Apps that already pass an
  explicit `locale:` are unaffected either way.

## [1.3.0] - 2026-08-07
### Added
- `cardColor` — the content card's background. Previously hard-coded to
  `Colors.white`, which made the page unusable in a dark theme: callers could
  colour the page background and the text, but the card stayed white, so
  theme-aware (light) text became invisible on it. **Defaults to white**, so
  existing apps are unaffected.
- `acceptButtonColor` / `acceptButtonTextColor` — the accept button was
  hard-coded to `Colors.deepPurple`, leaving a purple button in apps with any
  other palette. **Defaults to the previous purple**, so existing apps are
  unaffected.

### Fixed
- `titleTextColor` defaulted to `Colors.white`, and the package's own default
  background is also white — so the title was invisible for any caller that
  didn't pass a colour. The default is now chosen from the luminance of the
  background that is actually painted. Explicit values are still honoured.

### Notes
- The page and the card are **two separate surfaces**: `contentTextColor` must
  contrast with `cardColor`, while `titleTextColor` contrasts with
  `backgroundColor`. See the Theming section in the README.
- 9 widget tests cover the three changes, including regressions that pin the
  unchanged defaults.

## [1.2.2] - 2025-12-01
### Added
- iOS-friendly single-CTA mode: `withoutExitButtonWhenIOSPlatform` hides the reject/exit button on iOS so users proceed directly to the system prompt; override the button copy with `iosContinueText`.
- New `continueText` localization entry (defaults to localized "Continue").

## [1.2.1] - 2025-11-10
### Fixed
- **Locale Normalization**: Enhanced locale matching to support various format variations
  - BCP 47 format with hyphens (e.g., `zh-TW`, `en-US`) now correctly maps to internal format
  - Lowercase variants (e.g., `zh-tw`, `en-us`) are now properly recognized
  - Mixed case formats (e.g., `zh_tw`, `EN_US`) are automatically normalized
  - Script codes (e.g., `zh-Hans-TW`, `zh-Hant-CN`) are intelligently parsed
- **Improved Locale Resolution**: Fixed locale matching issues in both `PrivacyPolicyLocalization.getLocalization()` and `PolicyItem.getText()` methods
  - Prevents incorrect fallback to English when localized content is available
  - Ensures consistent behavior across different locale input formats
  - Maintains full backward compatibility with existing code

### Technical Details
- Added `_normalizeLocale()` method to standardize locale strings before matching
- Enhanced fallback logic to normalize both target and fallback locales
- All locale strings are now converted to a consistent `language_COUNTRY` format internally

## [1.2.0] - 2025-11-10
### Added
- **Hierarchical Policy Structure**: New `policyItemsHierarchical` parameter supporting multi-level nested policy items
- **Multi-Language Support**: Built-in support for 18+ languages with automatic locale detection
- **PolicyItem Class**: New class for creating hierarchical and multi-language policy content
  - Support for `Map<String, String>` to provide translations
  - Convenience constructors: `PolicyItem.single()` and `PolicyItem.localized()`
  - Automatic fallback to default language when translation not found
- **PrivacyPolicyLocalization Class**: Built-in UI text translations for:
  - English, Traditional Chinese, Simplified Chinese, Japanese, Korean
  - Spanish, French, German, Portuguese, Russian
  - Arabic, Vietnamese, Thai, Indonesian, Italian
  - Dutch, Polish, Turkish, Hindi
- **New Localization Parameters**:
  - `locale`: Force specific locale (e.g., 'zh_TW', 'ja')
  - `fallbackLocale`: Set default fallback language (default: 'en')
  - `localization`: Custom UI text localization
- **New Methods**:
  - `getDeviceLocale()`: Get device locale string (e.g., 'zh_TW', 'en')
  - `PrivacyPolicyLocalization.getLocalization()`: Get localization for specific locale

### Changed
- **Rendering Engine**: Enhanced to support recursive hierarchical rendering with indentation
- **UI Improvements**:
  - Different bullet styles for parent items (chevron) vs leaf items (bullet point)
  - Bold text for parent items with children
  - Configurable indentation (20px per level)
- **API Enhancement**: All legacy parameters still supported for backward compatibility

### Fixed
- Empty text items are now skipped in rendering when locale not found

## [1.1.3] - 2025-08-06
### Added
- Text color customization properties for better foreground/background contrast control
- `titleTextColor` property to customize the privacy policy title text color
- `contentTextColor` property to customize policy item text and bullet point colors
- `linkTextColor` property to customize privacy policy and terms of service link colors

### Fixed
- Resolved text visibility issues when using custom background colors
- Improved text contrast for better readability across different theme configurations

## [1.1.2] - 2025-08-03
### Added
- Version control mechanism for privacy policy updates
- `isAcceptedForVersion()` method to check acceptance for specific policy versions
- `setAcceptedForVersion()` method to record acceptance with version tracking
- `getAcceptedVersion()` and `getAcceptedAt()` methods for version history

### Changed
- Simplified version control logic to use string comparison instead of complex version parsing
- Enhanced constructor to accept `policyVersion` parameter for automatic version management
- Improved backward compatibility with existing acceptance records

### Removed
- Removed unnecessary `enableVersionControl` flag for cleaner API

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
