# privacy_policy_plus

[![pub package](https://img.shields.io/pub/v/privacy_policy_plus.svg)](https://pub.dev/packages/privacy_policy_plus)

[![Demo](https://raw.githubusercontent.com/changyy/privacy_policy_plus_dart/main/example/assets/screenshot320.png)](https://pub.dev/packages/privacy_policy_plus)

A flexible, beautiful, and developer-friendly Flutter widget for displaying privacy policy and consent screens. Easily integrate privacy compliance into your app with customizable UI, country-based logic, and version control.

## Theming

| Parameter | Default | Notes |
|---|---|---|
| `backgroundColor` | `Colors.white` | The page background. |
| `cardColor` | `Colors.white` | The content card. **Set this if your app has a dark theme** — the card used to be hard-coded white, so theme-aware text became invisible on it. |
| `titleTextColor` | auto | Picked from the background's luminance (black87 on light, white on dark). Pass a colour to override. |
| `contentTextColor` | `Colors.grey[800]` / `Colors.deepPurple` | Text inside the card — must contrast with `cardColor`. |
| `linkTextColor` | `Colors.blue` | |
| `acceptButtonColor` | `Colors.deepPurple.shade50` | |
| `acceptButtonTextColor` | `Colors.deepPurple` | |

> ⚠️ **The card and the page are separate surfaces.** `contentTextColor` has to
> contrast with `cardColor`, not with `backgroundColor`. If you only theme the
> page and let the text follow your `ColorScheme`, a dark theme will paint light
> text onto the still-white card.

## Features

- **One-line integration** - Privacy policy and terms consent page with minimal setup
- **Version control** - Automatic re-consent when policy updates
- **Hierarchical display** - Multi-level indentation for structured policy content
- **Multi-language support** - Built-in support for 18+ languages with automatic locale detection
- **Customizable UI** - App icon, colors, policy items, and button actions
- **Privacy/terms links** - Built-in navigation support
- **Region-based logic** - Skip/show by country code
- **Persistent storage** - Built-in shared_preferences integration

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  privacy_policy_plus: ^1.2.0
```

## Quick Start

### Basic Usage (Legacy API)

```dart
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

// Check if current policy version is accepted
final accepted = await PrivacyPolicyPage.isAcceptedForVersion(
  currentPolicyVersion: '1.0.0',
);

if (!accepted) {
  PrivacyPolicyPage(
    policyVersion: '1.0.0',
    policyItems: const [
      'This app collects usage analytics.',
      'Data is stored locally only.',
    ],
    onAccept: () => Navigator.pushReplacement(...),
  );
}
```

### Advanced Usage with Hierarchical Structure and Multi-Language

```dart
PrivacyPolicyPage(
  policyVersion: '1.0.0',

  // Multi-language hierarchical policy items
  policyItemsHierarchical: [
    PolicyItem({
      'en': 'To provide better services, we use:',
      'zh_TW': '為了提供更好的服務，我們使用：',
      'zh_CN': '为了提供更好的服务，我们使用：',
      'ja': 'より良いサービスを提供するために使用します：',
    }, children: [
      PolicyItem({
        'en': 'Data Analytics:',
        'zh_TW': '資料分析：',
        'zh_CN': '数据分析：',
        'ja': 'データ分析：',
      }, children: [
        PolicyItem({
          'en': 'We use Firebase Analytics anonymously',
          'zh_TW': '我們使用 Firebase Analytics 匿名追蹤',
          'zh_CN': '我们使用 Firebase Analytics 匿名跟踪',
          'ja': 'Firebase Analyticsを匿名で使用します',
        }),
        PolicyItem({
          'en': 'This optimizes app performance',
          'zh_TW': '這有助於優化應用程式效能',
          'zh_CN': '这有助于优化应用程序性能',
          'ja': 'アプリのパフォーマンスを最適化します',
        }),
      ]),
      PolicyItem({
        'en': 'Advertising:',
        'zh_TW': '廣告：',
        'zh_CN': '广告：',
        'ja': '広告：',
      }, children: [
        PolicyItem({
          'en': 'We use Google AdMob for ads',
          'zh_TW': '我們使用 Google AdMob 顯示廣告',
          'zh_CN': '我们使用 Google AdMob 显示广告',
          'ja': 'Google AdMobを使用します',
        }),
      ]),
    ]),
    PolicyItem({
      'en': 'We do not collect personal data without consent',
      'zh_TW': '未經同意，我們不會收集個人資料',
      'zh_CN': '未经同意，我们不会收集个人数据',
      'ja': '同意なしに個人データを収集しません',
    }),
  ],

  // Localization settings
  locale: 'zh_TW', // Optional: force specific locale
  fallbackLocale: 'en', // Default: 'en'

  // Customization
  topIcon: Icon(Icons.privacy_tip, size: 64),
  backgroundColor: Colors.grey[100],
  privacyLink: 'https://example.com/privacy',
  termsLink: 'https://example.com/terms',

  onAccept: () => Navigator.pushReplacement(...),
)
```

### iOS ATT-friendly single button (no exit)

```dart
PrivacyPolicyPage(
  policyItemsHierarchical: [...],
  withoutExitButtonWhenIOSPlatform: true, // hides Reject on iOS
  iosContinueText: 'Continue', // optional override (defaults to localized "Continue")
  onAccept: requestTrackingAuthorization,
)
```

### Simple Convenience API

```dart
// Use PolicyItem.single() for single-language content
policyItemsHierarchical: [
  PolicyItem.single(
    'Main policy item',
    children: [
      PolicyItem.single('Sub-item 1'),
      PolicyItem.single('Sub-item 2'),
    ],
  ),
]
```

## API Reference

### Version Control Methods

```dart
// Check specific version acceptance
await PrivacyPolicyPage.isAcceptedForVersion(
  currentPolicyVersion: '1.0.0',
);

// Get accepted version
await PrivacyPolicyPage.getAcceptedVersion();

// Get acceptance timestamp
await PrivacyPolicyPage.getAcceptedAt();
```

### Region Logic

```dart
// Skip in specific regions
PrivacyPolicyPage.shouldShowPrivacyPage(
  region: 'US',
  skipRegionList: ['US', 'CA'],
);

// Show only in specific regions
PrivacyPolicyPage.shouldShowPrivacyPage(
  region: 'TW',
  onlyRegionList: ['TW', 'JP'],
);

// Auto-detect device region
await PrivacyPolicyPage.shouldSkipPrivacyPageByDevice(
  skipRegionList: ['US', 'CA'],
);
```

### Localization

```dart
// Get device locale
final locale = await PrivacyPolicyPage.getDeviceLocale();
// Returns: 'en', 'zh_TW', 'zh_CN', 'ja', etc.

// Custom localization for UI elements
PrivacyPolicyPage(
  localization: PrivacyPolicyLocalization(
    acceptText: 'I Agree',
    rejectText: 'Decline',
    titleText: 'Our Privacy Policy',
    // ...
  ),
)
```

### ⚠️ Wire up `localeResolutionCallback` if your ARB set is script-based

This package resolves whatever locale it is **given**. But by the time a widget
calls `Localizations.localeOf(context)`, Flutter has already matched the device
locale against your `supportedLocales` — and that step can throw the script
away *before this package ever runs*.

With a script-based ARB set (`app_zh_Hant.arb` / `app_zh_Hans.arb`), a device
reporting `zh_TW` (region, **no script**) has no exact match, so Flutter falls
back to matching on the language code alone and lands on `Locale('zh')`. If
`app_zh.arb` happens to be Simplified, **every Traditional Chinese user gets a
Simplified UI** — and this package then faithfully resolves the bare `zh` it was
handed to Simplified too. Nothing is broken downstream; the information was
already gone.

iOS usually reports `zh-Hant-TW` (script present), so this hides on iPhone and
shows up on **Android**, which commonly reports `zh_TW`.

One line fixes it:

```dart
MaterialApp(
  supportedLocales: AppLocalizations.supportedLocales,
  localeResolutionCallback: resolveSupportedLocale, // ← from this package
  // …
)
```

`resolveSupportedLocale` returns `null` for everything it has no opinion about,
so Flutter's normal resolution still runs. It only speaks up for Chinese
locales that carry a region but no script, and it uses the **same** region →
script rule as `normalizeLocale` (`TW`/`HK`/`MO` → Traditional). It works with
either ARB style: it prefers a script-based entry and falls back to a
region-based one.

If your app ships no matching variant it returns `null` rather than guessing —
a silent downgrade to the wrong script is worse than Flutter's predictable
fallback.

### Built-in Language Support

Supported languages (UI elements):
- English (en)
- Traditional Chinese (zh_TW)
- Simplified Chinese (zh_CN, zh)
- Japanese (ja)
- Korean (ko)
- Spanish (es)
- French (fr)
- German (de)
- Portuguese (pt)
- Russian (ru)
- Arabic (ar)
- Vietnamese (vi)
- Thai (th)
- Indonesian (id)
- Italian (it)
- Dutch (nl)
- Polish (pl)
- Turkish (tr)
- Hindi (hi)

## Key Parameters

### PrivacyPolicyPage

| Parameter | Type | Description |
|-----------|------|-------------|
| `policyVersion` | `String?` | Enable version control (e.g., "1.0.0") |
| `policyItems` | `List<String>?` | Legacy: Simple list of policy items |
| `policyItemsHierarchical` | `List<PolicyItem>?` | **NEW**: Hierarchical multi-language items |
| `locale` | `String?` | Force specific locale (e.g., 'zh_TW') |
| `fallbackLocale` | `String` | Fallback locale (default: 'en') |
| `localization` | `PrivacyPolicyLocalization?` | Custom UI text localization |
| `topIcon` | `Widget?` | App icon widget |
| `backgroundColor` | `Color?` | Background color |
| `privacyLink` / `termsLink` | `String?` | External policy links |
| `onAccept` / `onReject` | `VoidCallback?` | Custom callbacks |
| `withoutExitButtonWhenIOSPlatform` | `bool` | On iOS, hides the reject/exit button so users always continue to the system prompt (default: false) |
| `iosContinueText` | `String?` | Override the primary button label when `withoutExitButtonWhenIOSPlatform` is true on iOS (defaults to localized "Continue") |

### PolicyItem

```dart
// Multi-language constructor
PolicyItem(
  {'en': 'English text', 'zh_TW': '中文文字'},
  children: [...],
)

// Single-language convenience constructor
PolicyItem.single('Text', children: [...])

// Localized constructor (explicit)
PolicyItem.localized(
  {'en': 'English', 'zh_TW': '中文'},
  children: [...],
)
```

## Migration Guide

### From v1.1.x to v1.2.0

**Old API (still supported):**
```dart
PrivacyPolicyPage(
  policyItems: ['Item 1', 'Item 2'],
  acceptText: 'Accept',
  titleText: 'Privacy Policy',
)
```

**New API (recommended):**
```dart
PrivacyPolicyPage(
  policyItemsHierarchical: [
    PolicyItem.single('Item 1'),
    PolicyItem({
      'en': 'Item 2',
      'zh_TW': '項目 2',
    }),
  ],
  // UI text auto-localizes based on device locale
  // Or manually override:
  acceptText: 'Accept',
  titleText: 'Privacy Policy',
)
```

## Examples

See the [example](example/) directory for a complete working demo with:
- Hierarchical multi-level policy structure
- Multi-language support (EN, ZH-TW, ZH-CN, JA)
- Version control
- Region-based display logic
- Status checking

## License

MIT

## Author

[changyy](https://github.com/changyy)

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for detailed version history.
