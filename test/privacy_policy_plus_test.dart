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
}
