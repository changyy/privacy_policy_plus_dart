/// Represents a privacy policy item that can contain hierarchical content
/// and multi-language support.
class PolicyItem {
  /// The text content of this policy item.
  /// - If [String]: Single language text (uses default language)
  /// - If [Map<String, String>]: Multi-language text with locale keys
  ///   (e.g., {'en': 'text', 'zh_TW': '文字', 'zh_CN': '文字'})
  final dynamic text;

  /// Optional child items for hierarchical structure
  final List<PolicyItem>? children;

  const PolicyItem(
    this.text, {
    this.children,
  }) : assert(
          text is String || text is Map<String, String>,
          'text must be either String or Map<String, String>',
        );

  /// Convenience constructor for single language text
  const PolicyItem.single(
    String text, {
    List<PolicyItem>? children,
  })  : text = text,
        children = children;

  /// Convenience constructor for multi-language text
  const PolicyItem.localized(
    Map<String, String> localizedText, {
    List<PolicyItem>? children,
  })  : text = localizedText,
        children = children;

  /// Normalize locale string to standard format (language_COUNTRY)
  ///
  /// Supports various input formats:
  /// - BCP 47 format: zh-TW, en-US → zh_TW, en_US
  /// - Lowercase variants: zh-tw, en-us → zh_TW, en_US
  /// - Mixed case: zh_tw, EN_us → zh_TW, en_US
  /// - Script codes: zh-Hans-TW → zh_TW (takes first and last part)
  /// - Language only: zh, en → zh, en
  ///
  /// Returns normalized locale string in language_COUNTRY format
  static String _normalizeLocale(String locale) {
    if (locale.isEmpty) return locale;

    // Split by both hyphen and underscore
    final parts = locale.split(RegExp(r'[-_]'));

    if (parts.length == 1) {
      // Language code only (e.g., 'en', 'zh', 'ja')
      return parts[0].toLowerCase();
    } else if (parts.length == 2) {
      // Standard language_COUNTRY format (e.g., 'zh_TW', 'en_US')
      final language = parts[0].toLowerCase();
      final country = parts[1].toUpperCase();
      return '${language}_$country';
    } else if (parts.length > 2) {
      // Handle script codes like 'zh-Hans-TW' or 'zh-Hant-CN'
      // Take first (language) and last (country) part
      final language = parts.first.toLowerCase();
      final country = parts.last.toUpperCase();
      return '${language}_$country';
    }

    return locale.toLowerCase();
  }

  /// Get the text for a specific locale with fallback support
  ///
  /// - [locale]: Target locale (e.g., 'en', 'zh_TW', 'zh_CN', 'zh-TW', 'zh-tw', 'ja')
  /// - [fallbackLocale]: Fallback locale if target not found (default: 'en')
  ///
  /// Returns the localized text, or empty string if not found
  ///
  /// Supports various locale formats including BCP 47 (zh-TW) and underscore (zh_TW)
  String getText(String locale, {String fallbackLocale = 'en'}) {
    if (text is String) {
      return text as String;
    }

    if (text is Map<String, String>) {
      final map = text as Map<String, String>;

      // Normalize the input locale
      final normalizedLocale = _normalizeLocale(locale);

      // Try exact match first with normalized locale
      if (map.containsKey(normalizedLocale)) {
        return map[normalizedLocale]!;
      }

      // Try language code only (e.g., 'zh' from 'zh_TW')
      final languageCode = normalizedLocale.split('_').first;
      if (map.containsKey(languageCode)) {
        return map[languageCode]!;
      }

      // Try fallback locale (also normalize it)
      final normalizedFallback = _normalizeLocale(fallbackLocale);
      if (map.containsKey(normalizedFallback)) {
        return map[normalizedFallback]!;
      }

      // Try fallback language code only
      final fallbackLanguageCode = normalizedFallback.split('_').first;
      if (map.containsKey(fallbackLanguageCode)) {
        return map[fallbackLanguageCode]!;
      }

      // Return first available value or empty string
      return map.values.isNotEmpty ? map.values.first : '';
    }

    return '';
  }

  /// Check if this item has children
  bool get hasChildren => children != null && children!.isNotEmpty;

  /// Check if this item is a leaf node (no children)
  bool get isLeaf => !hasChildren;
}
