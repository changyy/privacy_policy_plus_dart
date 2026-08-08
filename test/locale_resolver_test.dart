import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_policy_plus/src/locale_resolver.dart';

/// The bug these tests lock down (reported 2026-08-08):
///
/// A Traditional Chinese iPhone showed a **Simplified title with an English
/// body**. Flutter resolves such a device to `zh` + `scriptCode: Hant` with a
/// **null countryCode**; the old code only looked at `countryCode`, produced
/// `'zh'`, matched nothing in a `{en, zh_TW, zh_CN, ja}` map, and fell back to
/// English.
void main() {
  group('normalizeLocale — script beats country', () {
    test('zh-Hant (no country) → zh_TW — the shipped bug', () {
      expect(normalizeLocale('zh-Hant'), 'zh_TW');
      expect(normalizeLocale('zh_Hant'), 'zh_TW');
    });

    test('zh-Hans (no country) → zh_CN', () {
      expect(normalizeLocale('zh-Hans'), 'zh_CN');
    });

    test('zh-Hant-CN → zh_TW (script wins, not the country)', () {
      // The old implementation took first+last and answered zh_CN — wrong.
      expect(normalizeLocale('zh-Hant-CN'), 'zh_TW');
    });

    test('zh-Hans-TW → zh_CN (same rule, reversed)', () {
      expect(normalizeLocale('zh-Hans-TW'), 'zh_CN');
    });

    test('casing does not matter', () {
      expect(normalizeLocale('ZH-hant-tw'), 'zh_TW');
      expect(normalizeLocale('zh_HANT'), 'zh_TW');
    });
  });

  group('normalizeLocale — country when there is no script', () {
    test('zh_TW / zh_HK / zh_MO are Traditional', () {
      expect(normalizeLocale('zh_TW'), 'zh_TW');
      expect(normalizeLocale('zh-HK'), 'zh_TW');
      expect(normalizeLocale('zh_MO'), 'zh_TW');
    });

    test('zh_CN / zh_SG are Simplified', () {
      expect(normalizeLocale('zh_CN'), 'zh_CN');
      expect(normalizeLocale('zh-SG'), 'zh_CN');
    });

    test('bare zh stays zh so the caller can still try it', () {
      expect(normalizeLocale('zh'), 'zh');
    });
  });

  group('normalizeLocale — other languages', () {
    test('en / en_US / ja', () {
      expect(normalizeLocale('en'), 'en');
      expect(normalizeLocale('en-US'), 'en_US');
      expect(normalizeLocale('ja'), 'ja');
    });

    test('a script subtag on a non-Chinese language is dropped', () {
      expect(normalizeLocale('sr-Latn-RS'), 'sr_RS');
    });

    test('empty stays empty', () {
      expect(normalizeLocale(''), '');
    });
  });

  group('localeCandidates', () {
    test('Traditional reaches HK/MO before giving up', () {
      final chain = localeCandidates('zh-Hant');
      expect(chain.first, 'zh_TW');
      expect(chain, contains('zh_HK'));
      expect(chain.last, 'zh');
    });

    test('Simplified reaches SG', () {
      expect(localeCandidates('zh_CN'), contains('zh_SG'));
    });

    test('no duplicates', () {
      final chain = localeCandidates('zh_TW');
      expect(chain.toSet().length, chain.length);
    });

    test('non-Chinese ends with the bare language code', () {
      expect(localeCandidates('en_US'), ['en_US', 'en']);
    });
  });

  group('resolveFromMap', () {
    const map = {'en': 'english', 'zh_TW': '繁體', 'zh_CN': '简体', 'ja': '日本語'};

    test('zh-Hant → 繁體 (this is what the user actually saw break)', () {
      expect(resolveFromMap(map, 'zh-Hant'), '繁體');
    });

    test('zh_HK → 繁體, not English', () {
      expect(resolveFromMap(map, 'zh_HK'), '繁體');
    });

    test('zh-Hans → 简体', () {
      expect(resolveFromMap(map, 'zh-Hans'), '简体');
    });

    test('unknown language falls back', () {
      expect(resolveFromMap(map, 'fr'), 'english');
    });

    test('returns null when even the fallback is missing', () {
      expect(resolveFromMap(const {'ja': '日本語'}, 'fr'), isNull);
    });

    test('a map keyed only by bare zh still works', () {
      expect(resolveFromMap(const {'zh': '中文', 'en': 'x'}, 'zh-Hant'), '中文');
    });
  });
}
