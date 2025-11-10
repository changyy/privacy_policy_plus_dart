import 'dart:ui' as ui;
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

void main() {
  group('Locale Format Debug Tests', () {
    test('Check PlatformDispatcher locale format', () async {
      // Get the actual device locale
      final locale = ui.PlatformDispatcher.instance.locale;

      print('=== Device Locale Information ===');
      print('Full locale toString(): ${locale.toString()}');
      print('languageCode: ${locale.languageCode}');
      print('countryCode: ${locale.countryCode}');
      print('scriptCode: ${locale.scriptCode}');
      print('toLanguageTag(): ${locale.toLanguageTag()}');

      // Simulate what the code does
      final languageCode = locale.languageCode;
      final countryCode = locale.countryCode;
      String computedLocale;

      if (countryCode != null && countryCode.isNotEmpty) {
        computedLocale = '${languageCode}_$countryCode';
      } else {
        computedLocale = languageCode;
      }

      print('Computed locale string: $computedLocale');

      // Check if it matches any built-in localization
      final hasExactMatch = PrivacyPolicyLocalization
          .builtInLocalizations
          .containsKey(computedLocale);

      print('Has exact match in builtInLocalizations: $hasExactMatch');

      if (!hasExactMatch) {
        print('Available keys in builtInLocalizations:');
        PrivacyPolicyLocalization.builtInLocalizations.keys.forEach((key) {
          print('  - $key');
        });
      }

      // Test the actual lookup
      final localization = PrivacyPolicyLocalization.getLocalization(
        computedLocale,
      );
      print('Resolved acceptText: ${localization.acceptText}');
    });

    test('Test various locale format variations', () {
      final testCases = [
        'zh_TW',   // Underscore (current format)
        'zh-TW',   // Hyphen (BCP 47 format)
        'zh_tw',   // Lowercase country
        'zh-tw',   // Hyphen + lowercase
        'zh',      // Language only
        'ZH_TW',   // Uppercase language
        'zh_Hant', // Script code
        'en_US',
        'en-US',
        'ja_JP',
        'ko_KR',
      ];

      print('\n=== Testing Locale Format Variations ===');
      for (final testLocale in testCases) {
        final loc = PrivacyPolicyLocalization.getLocalization(testLocale);
        final matched = PrivacyPolicyLocalization
            .builtInLocalizations
            .containsKey(testLocale);

        print('$testLocale -> acceptText: ${loc.acceptText} '
            '(exact match: $matched)');
      }
    });

    test('Test PolicyItem with various locale formats', () {
      final item = PolicyItem({
        'en': 'English',
        'zh_TW': '繁體中文',
        'zh_CN': '简体中文',
        'ja': '日本語',
      });

      final testCases = [
        'zh_TW',
        'zh-TW',
        'zh_tw',
        'zh-tw',
        'zh',
        'zh_Hant',
      ];

      print('\n=== Testing PolicyItem Locale Resolution ===');
      for (final testLocale in testCases) {
        final text = item.getText(testLocale);
        print('$testLocale -> "$text"');
      }
    });
  });
}
