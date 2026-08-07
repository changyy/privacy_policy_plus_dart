import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

void main() {
  _colorApiTests();

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

/// Colour APIs added in 1.3.0.
///
/// The card was always white while callers could only colour the page
/// background and the text. Text that follows a `ColorScheme` therefore turned
/// light in a dark theme and became invisible on the still-white card.
void _colorApiTests() {
  Widget host(Widget child, {ThemeData? theme}) => MaterialApp(
        theme: theme,
        home: child,
      );

  const items = <String>['We use analytics'];

  group('cardColor', () {
    testWidgets('defaults to white so existing apps are unaffected', (tester) async {
      await tester.pumpWidget(
        host(const PrivacyPolicyPage(policyItems: items, locale: 'en')),
      );
      await tester.pumpAndSettle();

      final card = tester.widgetList<Container>(find.byType(Container)).firstWhere(
            (c) => (c.decoration as BoxDecoration?)?.color != null,
          );
      expect((card.decoration as BoxDecoration).color, Colors.white);
    });

    testWidgets('can be made dark, which is what a dark theme needs', (tester) async {
      await tester.pumpWidget(
        host(
          const PrivacyPolicyPage(
            policyItems: items,
            locale: 'en',
            cardColor: Color(0xFF3A3227),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final card = tester.widgetList<Container>(find.byType(Container)).firstWhere(
            (c) => (c.decoration as BoxDecoration?)?.color != null,
          );
      expect(
        (card.decoration as BoxDecoration).color,
        const Color(0xFF3A3227),
        reason: 'a hard-coded white card always collides with dark-theme text colours',
      );
    });
  });

  group('title colour is chosen automatically', () {
    Color titleColorOf(WidgetTester tester) =>
        tester.widget<Text>(find.text('Welcome')).style!.color!;

    testWidgets('light background gives a dark title (the old fixed white was invisible)', (tester) async {
      await tester.pumpWidget(
        host(
          const PrivacyPolicyPage(
            policyItems: items,
            locale: 'en',
            titleText: 'Welcome',
            backgroundColor: Color(0xFFFAFAFA),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(titleColorOf(tester), Colors.black87);
    });

    testWidgets('dark background still gives a white title (unchanged behaviour)', (tester) async {
      await tester.pumpWidget(
        host(
          const PrivacyPolicyPage(
            policyItems: items,
            locale: 'en',
            titleText: 'Welcome',
            backgroundColor: Color(0xFF2A241C),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(titleColorOf(tester), Colors.white);
    });

    testWidgets('an explicit colour wins over the automatic choice', (tester) async {
      await tester.pumpWidget(
        host(
          const PrivacyPolicyPage(
            policyItems: items,
            locale: 'en',
            titleText: 'Welcome',
            backgroundColor: Color(0xFFFAFAFA),
            titleTextColor: Color(0xFF6B4423),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(titleColorOf(tester), const Color(0xFF6B4423));
    });
  });

  group('accept button colours', () {
    testWidgets('can replace the hard-coded deepPurple', (tester) async {
      await tester.pumpWidget(
        host(
          const PrivacyPolicyPage(
            policyItems: items,
            locale: 'en',
            acceptButtonColor: Color(0xFF6B4423),
            acceptButtonTextColor: Color(0xFFEFE6D5),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final btn = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton).first,
      );
      final bg = btn.style!.backgroundColor!.resolve(<WidgetState>{});
      expect(bg, const Color(0xFF6B4423));
    });
  });
}
