import 'dart:ui' show Locale;

import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

/// `resolveSupportedLocale` — the step *before* this package's own matching.
///
/// Reported 2026-08-10 while shooting first-launch screenshots in five locales:
/// a device set to `zh_TW` rendered the privacy page in **Simplified**. The
/// package resolved exactly what it was handed (`Locale('zh')`); the script had
/// already been dropped by Flutter's `supportedLocales` matching.
void main() {
  const scriptBased = [
    Locale('en'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  const countryBased = [
    Locale('en', 'US'),
    Locale('zh', 'TW'),
    Locale('zh', 'CN'),
    Locale('ja', 'JP'),
  ];

  group('script-based supportedLocales (app_zh_Hant.arb style)', () {
    test('zh_TW → Hant, not the bare zh that would give Simplified', () {
      final hit = resolveSupportedLocale(const Locale('zh', 'TW'), scriptBased);
      expect(hit?.scriptCode, 'Hant');
    });

    test('zh_HK and zh_MO also reach Traditional', () {
      for (final country in ['HK', 'MO']) {
        expect(
          resolveSupportedLocale(Locale('zh', country), scriptBased)
              ?.scriptCode,
          'Hant',
          reason: 'zh_$country',
        );
      }
    });

    test('zh_CN → Hans', () {
      expect(
        resolveSupportedLocale(const Locale('zh', 'CN'), scriptBased)
            ?.scriptCode,
        'Hans',
      );
    });

    test('zh_SG and zh_MY → Hans', () {
      for (final country in ['SG', 'MY']) {
        expect(
          resolveSupportedLocale(Locale('zh', country), scriptBased)
              ?.scriptCode,
          'Hans',
          reason: 'zh_$country',
        );
      }
    });
  });

  group('country-based supportedLocales (app_zh_TW.arb style)', () {
    test('zh_HK reaches zh_TW even though the app ships no zh_HK', () {
      final hit =
          resolveSupportedLocale(const Locale('zh', 'HK'), countryBased);
      expect(hit?.countryCode, 'TW');
    });

    test('zh_SG reaches zh_CN', () {
      expect(
        resolveSupportedLocale(const Locale('zh', 'SG'), countryBased)
            ?.countryCode,
        'CN',
      );
    });
  });

  group('stays quiet when it has nothing to add', () {
    test('script already present — nothing was lost', () {
      expect(
        resolveSupportedLocale(
          const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
          scriptBased,
        ),
        isNull,
      );
    });

    test('bare zh carries no signal — do not guess', () {
      // Guessing here would be worse than the default: the caller's
      // fallbackLocale chain is the right place to decide.
      expect(resolveSupportedLocale(const Locale('zh'), scriptBased), isNull);
    });

    test('non-Chinese locales are none of its business', () {
      expect(resolveSupportedLocale(const Locale('ja'), scriptBased), isNull);
      expect(resolveSupportedLocale(const Locale('vi'), scriptBased), isNull);
      expect(
        resolveSupportedLocale(const Locale('en', 'GB'), scriptBased),
        isNull,
      );
    });

    test('null device (system locale unavailable)', () {
      expect(resolveSupportedLocale(null, scriptBased), isNull);
    });

    test('app ships no Chinese at all → null, never a wrong guess', () {
      expect(
        resolveSupportedLocale(const Locale('zh', 'TW'), const [Locale('en')]),
        isNull,
      );
    });

    test('app ships only Simplified → zh_TW gets null, not Simplified', () {
      // Returning Hans here would be a silent downgrade. Flutter's own
      // fallback is at least predictable, and the app author can see it.
      final onlyHans = [
        const Locale('en'),
        const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
      ];
      expect(
          resolveSupportedLocale(const Locale('zh', 'TW'), onlyHans), isNull);
    });
  });

  group('agrees with normalizeLocale (one rule, two shapes)', () {
    test('the region→script mapping is not a second opinion', () {
      for (final country in ['TW', 'HK', 'MO', 'CN', 'SG', 'MY']) {
        final viaString = normalizeLocale('zh_$country');
        final viaLocale = resolveSupportedLocale(
          Locale('zh', country),
          scriptBased,
        );
        final expected = viaString == 'zh_TW' ? 'Hant' : 'Hans';
        expect(viaLocale?.scriptCode, expected, reason: 'zh_$country');
      }
    });
  });
}
