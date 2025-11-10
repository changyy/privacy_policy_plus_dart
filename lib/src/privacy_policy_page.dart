import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'policy_item.dart';
import 'privacy_policy_localization.dart';

class PrivacyPolicyPage extends StatelessWidget {
  // === Legacy API (for backward compatibility) ===
  final List<String>? policyItems;

  // === New hierarchical API ===
  final List<PolicyItem>? policyItemsHierarchical;

  // === Common parameters ===
  final Widget? topIcon;
  final Color? backgroundColor;
  final String sharedPrefKey;
  final String? privacyLink;
  final String? termsLink;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;

  // === Text styling ===
  final Color? titleTextColor;
  final Color? contentTextColor;
  final Color? linkTextColor;

  // === Version control mechanism ===
  final String? policyVersion;

  // === Localization parameters ===
  /// Locale for displaying policy content and UI text
  /// If null, automatically detects from device locale
  /// Format: 'en', 'zh_TW', 'zh_CN', 'ja', etc.
  final String? locale;

  /// Fallback locale when target locale is not found
  /// Default: 'en'
  final String fallbackLocale;

  /// Custom localization for UI elements (buttons, titles, etc.)
  /// If null, uses built-in localizations based on locale
  final PrivacyPolicyLocalization? localization;

  // === Legacy text parameters (override localization) ===
  final String? titleText;
  final String? acceptText;
  final String? rejectText;
  final String? privacyTitle;
  final String? termsTitle;
  final String? snackBarOpenLinkText;

  const PrivacyPolicyPage({
    Key? key,
    // Legacy API
    this.policyItems,
    // New API
    this.policyItemsHierarchical,
    // Common parameters
    this.topIcon,
    this.backgroundColor,
    this.sharedPrefKey = 'app_prviacy_accept_data',
    this.privacyLink,
    this.termsLink,
    this.onAccept,
    this.onReject,
    // Text styling
    this.titleTextColor,
    this.contentTextColor,
    this.linkTextColor,
    // Version control
    this.policyVersion,
    // Localization
    this.locale,
    this.fallbackLocale = 'en',
    this.localization,
    // Legacy text parameters
    this.titleText,
    this.acceptText,
    this.rejectText,
    this.privacyTitle,
    this.termsTitle,
    this.snackBarOpenLinkText,
  })  : assert(
          policyItems != null || policyItemsHierarchical != null,
          'Either policyItems or policyItemsHierarchical must be provided',
        ),
        super(key: key);

  /// Check if privacy policy has been accepted (legacy API, maintains backward compatibility)
  static Future<bool> isAccepted({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  /// Check if specific version of privacy policy has been accepted
  static Future<bool> isAcceptedForVersion({
    required String currentPolicyVersion,
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final versionKey = '${key}_version';
    final acceptedVersion = prefs.getString(versionKey);

    if (acceptedVersion == null) {
      return prefs.getBool(key) ?? false;
    }

    return acceptedVersion == currentPolicyVersion;
  }

  /// Get the privacy policy version that user has accepted
  static Future<String?> getAcceptedVersion({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final versionKey = '${key}_version';
    return prefs.getString(versionKey);
  }

  /// Determine whether to skip privacy page (do not display)
  static bool shouldSkipPrivacyPage({
    required String? region,
    List<String>? skipRegionList,
    List<String>? onlyRegionList,
  }) {
    if (region == null) return false;
    if (onlyRegionList != null) {
      return !(onlyRegionList.contains(region));
    }
    if (skipRegionList != null && skipRegionList.contains(region)) return true;
    return false;
  }

  /// Set privacy policy as accepted (legacy API)
  static Future<void> setAccepted({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  /// Set specific version of privacy policy as accepted
  static Future<void> setAcceptedForVersion({
    required String policyVersion,
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);

    final versionKey = '${key}_version';
    await prefs.setString(versionKey, policyVersion);

    final timestampKey = '${key}_accepted_at';
    await prefs.setString(timestampKey, DateTime.now().toIso8601String());
  }

  /// Get the time when user accepted privacy policy
  static Future<DateTime?> getAcceptedAt({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final timestampKey = '${key}_accepted_at';
    final timestamp = prefs.getString(timestampKey);

    if (timestamp != null) {
      try {
        return DateTime.parse(timestamp);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Determine whether to show privacy page
  static bool shouldShowPrivacyPage({
    required String? region,
    List<String>? skipRegionList,
    List<String>? onlyRegionList,
  }) {
    if (onlyRegionList != null) {
      return region != null && onlyRegionList.contains(region);
    }
    if (skipRegionList != null) {
      return !(region != null && skipRegionList.contains(region));
    }
    return true;
  }

  /// Get device country/region code (estimation only)
  static Future<String?> getDeviceCountryCode() async {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      return locale.countryCode?.toUpperCase();
    } catch (_) {}
    return null;
  }

  /// Get device locale string (e.g., 'en', 'zh_TW', 'zh_CN')
  static Future<String> getDeviceLocale() async {
    try {
      final locale = ui.PlatformDispatcher.instance.locale;
      final languageCode = locale.languageCode;
      final countryCode = locale.countryCode;

      if (countryCode != null && countryCode.isNotEmpty) {
        return '${languageCode}_$countryCode';
      }
      return languageCode;
    } catch (_) {}
    return 'en';
  }

  /// Automatically get device region and determine if privacy page should be skipped
  static Future<bool> shouldSkipPrivacyPageByDevice({
    List<String>? skipRegionList,
    List<String>? onlyRegionList,
  }) async {
    final region = await getDeviceCountryCode();
    return shouldSkipPrivacyPage(
      region: region,
      skipRegionList: skipRegionList,
      onlyRegionList: onlyRegionList,
    );
  }

  /// Get the current locale to use for displaying content
  String _getCurrentLocale(BuildContext context) {
    if (locale != null) {
      return locale!;
    }

    // Try to get from Flutter Localizations
    try {
      final deviceLocale = Localizations.localeOf(context);
      final languageCode = deviceLocale.languageCode;
      final countryCode = deviceLocale.countryCode;

      if (countryCode != null && countryCode.isNotEmpty) {
        return '${languageCode}_$countryCode';
      }
      return languageCode;
    } catch (_) {
      return fallbackLocale;
    }
  }

  /// Get the localization to use for UI elements
  PrivacyPolicyLocalization _getLocalization(BuildContext context) {
    // If custom localization provided, use it
    if (localization != null) {
      return localization!;
    }

    // Otherwise, get from built-in localizations
    final currentLocale = _getCurrentLocale(context);
    return PrivacyPolicyLocalization.getLocalization(
      currentLocale,
      fallbackLocale: fallbackLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = _getCurrentLocale(context);
    final loc = _getLocalization(context);

    return Scaffold(
      backgroundColor: backgroundColor ?? Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            if (topIcon != null) ...[
              Padding(
                padding: const EdgeInsets.only(top: 48.0, bottom: 24.0),
                child: Center(child: topIcon!),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    Text(
                      titleText ?? loc.titleText,
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: titleTextColor ?? Colors.white,
                              ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Render policy items
                          if (policyItemsHierarchical != null)
                            ...policyItemsHierarchical!.map(
                              (item) => _buildPolicyItem(
                                item,
                                currentLocale,
                              ),
                            )
                          else if (policyItems != null)
                            ...policyItems!.map(
                              (item) => _buildLegacyPolicyItem(item),
                            ),

                          // Privacy link
                          if (privacyLink != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: GestureDetector(
                                onTap: () => _launchUrl(
                                  context,
                                  privacyLink!,
                                  loc,
                                ),
                                child: Text(
                                  privacyTitle ?? loc.privacyTitle,
                                  style: TextStyle(
                                    color: linkTextColor ?? Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),

                          // Terms link
                          if (termsLink != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () => _launchUrl(
                                  context,
                                  termsLink!,
                                  loc,
                                ),
                                child: Text(
                                  termsTitle ?? loc.termsTitle,
                                  style: TextStyle(
                                    color: linkTextColor ?? Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 32.0,
                horizontal: 32.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple.shade50,
                      foregroundColor: Colors.deepPurple,
                      elevation: 0,
                    ),
                    onPressed: () async {
                      if (policyVersion != null) {
                        await setAcceptedForVersion(
                          policyVersion: policyVersion!,
                          key: sharedPrefKey,
                        );
                      } else {
                        await setAccepted(key: sharedPrefKey);
                      }

                      if (onAccept != null) {
                        onAccept!();
                      } else {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(true);
                        }
                      }
                    },
                    child: Text(acceptText ?? loc.acceptText),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (onReject != null) {
                        onReject!();
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: Text(rejectText ?? loc.rejectText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build hierarchical policy item with indentation
  Widget _buildPolicyItem(
    PolicyItem item,
    String locale, {
    double indent = 0,
  }) {
    final text = item.getText(locale, fallbackLocale: fallbackLocale);

    // If text is empty after locale resolution, skip rendering
    if (text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: EdgeInsets.only(bottom: item.hasChildren ? 8.0 : 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: indent),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Icon(
                    item.hasChildren
                        ? Icons.chevron_right
                        : Icons.brightness_1,
                    size: item.hasChildren ? 16 : 8,
                    color: contentTextColor ?? Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: item.hasChildren
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: contentTextColor ?? Colors.grey[800],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (item.hasChildren)
            ...item.children!.map(
              (child) => _buildPolicyItem(
                child,
                locale,
                indent: indent + 20,
              ),
            ),
        ],
      ),
    );
  }

  /// Build legacy policy item (backward compatibility)
  Widget _buildLegacyPolicyItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 6.0),
            child: Icon(
              Icons.brightness_1,
              size: 8,
              color: contentTextColor ?? Colors.deepPurple,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              item,
              style: TextStyle(
                fontSize: 16,
                color: contentTextColor ?? Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _launchUrl(
    BuildContext context,
    String url,
    PrivacyPolicyLocalization loc,
  ) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${snackBarOpenLinkText ?? loc.snackBarOpenLinkText}: $url',
        ),
      ),
    );
  }
}
