# privacy_policy_plus

[![pub package](https://img.shields.io/pub/v/privacy_policy_plus.svg)](https://pub.dev/packages/privacy_policy_plus)

[![Demo](https://raw.githubusercontent.com/changyy/privacy_policy_plus_dart/main/example/assets/screenshot320.png)](https://pub.dev/packages/privacy_policy_plus)

A flexible, beautiful, and developer-friendly Flutter widget for displaying privacy policy and consent screens. Easily integrate privacy compliance into your app with customizable UI, country-based logic, and version control.

## Features
- One-line privacy policy and terms consent page
- **Version control** for policy updates with automatic re-consent
- Customizable app icon, policy items, and button actions
- Privacy/terms links with built-in navigation
- Region-based display logic (skip/show by country)
- Built-in shared_preferences persistence

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  privacy_policy_plus: ^1.1.1
```

## Quick Start

```dart
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

// Check if current policy version is accepted
final accepted = await PrivacyPolicyPage.isAcceptedForVersion(
  currentPolicyVersion: '2025-08-03',
);

if (!accepted) {
  // Show privacy policy with version control
  PrivacyPolicyPage(
    policyVersion: '2025-08-03', // Auto version tracking
    policyItems: const [
      'This app collects usage analytics.',
      'Data is stored locally only.',
    ],
    onAccept: () => Navigator.pushReplacement(...),
  );
}
```

## Basic Usage

```dart
PrivacyPolicyPage(
  topIcon: Icon(Icons.privacy_tip, size: 64),
  backgroundColor: Colors.grey[100],
  policyItems: const [
    'This app does not collect personal data.',
    'Analytics are anonymous and optional.',
  ],
  privacyLink: 'https://example.com/privacy',
  privacyTitle: 'Full Privacy Policy',
  acceptText: 'I Agree',
  rejectText: 'Exit',
  policyVersion: '1.0.0', // Enable version control
)
```

## API Reference

### Version Control Methods
```dart
// Check specific version acceptance
await PrivacyPolicyPage.isAcceptedForVersion(currentPolicyVersion: '1.0.0');

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
```

### Key Parameters
- `policyVersion`: String? - Enable version control
- `policyItems`: List<String> - Privacy terms (required)
- `topIcon`: Widget? - App icon
- `privacyLink`/`termsLink`: External links
- `onAccept`/`onReject`: Custom callbacks

## License
MIT

