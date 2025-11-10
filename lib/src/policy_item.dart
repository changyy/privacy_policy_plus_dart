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

  /// Get the text for a specific locale with fallback support
  ///
  /// - [locale]: Target locale (e.g., 'en', 'zh_TW', 'zh_CN', 'ja')
  /// - [fallbackLocale]: Fallback locale if target not found (default: 'en')
  ///
  /// Returns the localized text, or empty string if not found
  String getText(String locale, {String fallbackLocale = 'en'}) {
    if (text is String) {
      return text as String;
    }

    if (text is Map<String, String>) {
      final map = text as Map<String, String>;

      // Try exact match first
      if (map.containsKey(locale)) {
        return map[locale]!;
      }

      // Try language code only (e.g., 'zh' from 'zh_TW')
      final languageCode = locale.split('_').first;
      if (map.containsKey(languageCode)) {
        return map[languageCode]!;
      }

      // Try fallback locale
      if (map.containsKey(fallbackLocale)) {
        return map[fallbackLocale]!;
      }

      // Try fallback language code only
      final fallbackLanguageCode = fallbackLocale.split('_').first;
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
