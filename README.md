# privacy_policy_plus

[![pub package](https://img.shields.io/pub/v/privacy_policy_plus.svg)](https://pub.dev/packages/privacy_policy_plus)

[![Demo](https://raw.githubusercontent.com/changyy/privacy_policy_plus_dart/main/example/assets/screenshot320.png)](https://pub.dev/packages/privacy_policy_plus)

A flexible, beautiful, and developer-friendly Flutter widget for displaying privacy policy and consent screens. Easily integrate privacy compliance into your app with customizable UI, country-based logic, and version control.

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
