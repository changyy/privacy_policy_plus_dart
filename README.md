# privacy_policy_plus

[![pub package](https://img.shields.io/pub/v/privacy_policy_plus.svg)](https://pub.dev/packages/privacy_policy_plus)

[![Demo](https://raw.githubusercontent.com/changyy/privacy_policy_plus_dart/main/example/assets/screenshot320.png)](https://pub.dev/packages/privacy_policy_plus)

A flexible, beautiful, and developer-friendly Flutter widget for displaying privacy policy and consent screens. Easily integrate privacy compliance into your app with customizable UI, country-based logic, and quick setup.

## Features
- Show privacy policy and terms consent page with one line of code
- Customizable app icon, policy items, and button actions
- Support for privacy/terms links
- Enable/skip by country list (region code)
- Easy integration and extensible for any Flutter app
- Built-in shared_preferences support for consent persistence

## Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  privacy_policy_plus: ^1.0.0
```

Import and use in your app:

```dart
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

MaterialApp(
  navigatorKey: navigatorKey,
  home: PrivacyPolicyPage(
    topIcon: Image.asset('assets/app_icon.png', width: 100, height: 100),
    backgroundColor: Color(0xFFFCF7FF),
    policyItems: const [
      'This app does not collect your personal data.',
      'This app uses Firebase for anonymous usage analytics.',
      'This app uses Admob for advertising services.',
    ],
    privacyLink: 'https://your.privacy.link',
    privacyTitle: 'Privacy Policy Link',
    termsLink: 'https://your.terms.link',
    termsTitle: 'Terms of Service Link',
    acceptText: 'Accept',
    rejectText: 'Exit',
    titleText: 'Privacy Policy',
    snackBarOpenLinkText: 'Open link',
    skipRegionList: const ['US', 'CA'], // Optional: skip in these regions
    onlyRegionList: const ['TW', 'JP'], // Optional: show only in these regions
    onAccept: () {
      navigatorKey.currentState?.pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    },
    onReject: () {
      // Custom reject action
    },
  ),
);
```

## API
- `topIcon`: Widget? (your app icon)
- `backgroundColor`: Color? (background color)
- `policyItems`: List<String> (privacy terms, required)
- `privacyLink`/`privacyTitle`: privacy policy link & title
- `termsLink`/`termsTitle`: terms of service link & title
- `acceptText`/`rejectText`: button text
- `titleText`: page title
- `snackBarOpenLinkText`: snackbar text for link
- `skipRegionList`: List<String>? (region/country code to skip)
- `onlyRegionList`: List<String>? (region/country code to force show)
- `sharedPrefKey`: String (key for shared_preferences, default: 'app_prviacy_accept_data')
- `onAccept`: callback when user accepts (default: pop or do nothing if cannot pop)
- `onReject`: callback when user rejects (default: pop)

### Consent Check Example

```dart
final accepted = await PrivacyPolicyPage.isAccepted();
```

### Region Logic Example

```dart
final shouldShow = PrivacyPolicyPage.shouldShowPrivacyPage(
  region: countryCode,
  skipRegionList: const ['US', 'CA'],
  onlyRegionList: const ['TW', 'JP'],
);
```

## License
MIT

---

**privacy_policy_plus** helps you stay compliant and user-friendly, with minimal code and maximum flexibility.

