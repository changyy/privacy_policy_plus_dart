import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

void main() {
  group('PrivacyPolicyPage static logic', () {
    test('shouldShowPrivacyPage returns true for onlyRegionList match', () {
      final result = PrivacyPolicyPage.shouldShowPrivacyPage(
        region: 'TW',
        skipRegionList: const ['US', 'CA'],
        onlyRegionList: const ['TW', 'JP'],
      );
      expect(result, isTrue);
    });

    test('shouldShowPrivacyPage returns false for skipRegionList match', () {
      final result = PrivacyPolicyPage.shouldShowPrivacyPage(
        region: 'US',
        skipRegionList: const ['US', 'CA'],
        onlyRegionList: const ['TW', 'JP'],
      );
      expect(result, isFalse);
    });

    test('shouldShowPrivacyPage returns true for no region limit', () {
      final result = PrivacyPolicyPage.shouldShowPrivacyPage(
        region: 'FR',
        skipRegionList: null,
        onlyRegionList: null,
      );
      expect(result, isTrue);
    });
  });

  group('PolicyItem', () {
    test('PolicyItem.single creates single-language item', () {
      final item = PolicyItem.single('Test text');
      expect(item.text, 'Test text');
      expect(item.children, isNull);
    });

    test('PolicyItem with children has correct structure', () {
      final item = PolicyItem.single(
        'Parent',
        children: [
          PolicyItem.single('Child 1'),
          PolicyItem.single('Child 2'),
        ],
      );
      expect(item.hasChildren, isTrue);
      expect(item.children!.length, 2);
      expect(item.isLeaf, isFalse);
    });

    test('PolicyItem getText returns correct locale text', () {
      final item = PolicyItem({
        'en': 'English',
        'zh_TW': '繁體中文',
        'zh_CN': '简体中文',
      });
      expect(item.getText('en'), 'English');
      expect(item.getText('zh_TW'), '繁體中文');
      expect(item.getText('zh_CN'), '简体中文');
    });

    test('PolicyItem getText falls back correctly', () {
      final item = PolicyItem({
        'en': 'English only',
        'zh_TW': '繁體中文',
      });
      // Request ja, should fall back to en
      expect(item.getText('ja', fallbackLocale: 'en'), 'English only');
      // Request zh_CN, should try zh first, then fall back to en
      expect(item.getText('zh_CN', fallbackLocale: 'en'), 'English only');
    });

    test('PolicyItem getText with language code fallback', () {
      final item = PolicyItem({
        'zh': '中文',
      });
      // Request zh_TW, should find 'zh'
      expect(item.getText('zh_TW'), '中文');
      expect(item.getText('zh_CN'), '中文');
    });
  });

  group('PrivacyPolicyLocalization', () {
    test('getLocalization returns correct locale', () {
      final loc = PrivacyPolicyLocalization.getLocalization('zh_TW');
      expect(loc.acceptText, '接受');
      expect(loc.rejectText, '拒絕');
      expect(loc.titleText, '隱私權政策');
    });

    test('getLocalization falls back to English', () {
      final loc = PrivacyPolicyLocalization.getLocalization('xx_YY');
      expect(loc.acceptText, 'Accept');
      expect(loc.titleText, 'Privacy Policy');
    });

    test('getLocalization handles language code only', () {
      final loc = PrivacyPolicyLocalization.getLocalization('zh');
      expect(loc.acceptText, '接受');
    });
  });
}
