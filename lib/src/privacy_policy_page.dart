import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrivacyPolicyPage extends StatelessWidget {
  final List<String> policyItems;
  final Widget? topIcon;
  final Color? backgroundColor;
  final String sharedPrefKey;
  final String? privacyLink;
  final String? privacyTitle;
  final String? termsLink;
  final String? termsTitle;
  final String acceptText;
  final String rejectText;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final String? titleText;
  final String? snackBarOpenLinkText;

  // 🆕 Version control mechanism
  final String?
      policyVersion; // Privacy policy version/date, e.g. "2025-08-03" or "v1.2.0"

  const PrivacyPolicyPage({
    Key? key,
    required this.policyItems,
    this.topIcon,
    this.backgroundColor,
    this.sharedPrefKey = 'app_prviacy_accept_data',
    this.privacyLink,
    this.privacyTitle,
    this.termsLink,
    this.termsTitle,
    this.acceptText = 'Accept',
    this.rejectText = 'Exit',
    this.onAccept,
    this.onReject,
    this.titleText = 'Privacy Policy',
    this.snackBarOpenLinkText = 'Open link',
    this.policyVersion, // 🆕 Privacy policy version control
  }) : super(key: key);

  /// Check if privacy policy has been accepted (legacy API, maintains backward compatibility)
  static Future<bool> isAccepted({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  /// 🆕 Check if specific version of privacy policy has been accepted
  ///
  /// - [currentPolicyVersion]: Current privacy policy version
  /// - [key]: SharedPreferences storage key
  ///
  /// Returns true if user has accepted the exact same privacy policy version
  static Future<bool> isAcceptedForVersion({
    required String currentPolicyVersion,
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Check for versioned acceptance record
    final versionKey = '${key}_version';
    final acceptedVersion = prefs.getString(versionKey);

    if (acceptedVersion == null) {
      // If no version record exists, check legacy boolean acceptance record
      // Legacy users will be prompted to re-confirm (due to no explicit version record)
      return prefs.getBool(key) ?? false;
    }

    // 🎯 Simple string comparison: versions must be exactly the same to be considered accepted
    return acceptedVersion == currentPolicyVersion;
  }

  /// 🆕 Get the privacy policy version that user has accepted
  static Future<String?> getAcceptedVersion({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final versionKey = '${key}_version';
    return prefs.getString(versionKey);
  }

  /// Determine whether to skip privacy page (do not display)
  ///
  /// - region: Current region code (e.g. 'US', 'TW')
  /// - skipRegionList: List of regions to not display (optional)
  /// - onlyRegionList: List of regions to only display (optional)
  ///
  /// Rules:
  /// 1. If onlyRegionList is defined, only display in those regions, skip all others
  /// 2. If skipRegionList is defined, do not display in those regions
  /// 3. If neither is defined, default to display
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

  /// Set privacy policy as accepted (legacy API, maintains backward compatibility)
  static Future<void> setAccepted({
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  /// 🆕 Set specific version of privacy policy as accepted
  ///
  /// - [policyVersion]: Accepted privacy policy version
  /// - [key]: SharedPreferences storage key
  static Future<void> setAcceptedForVersion({
    required String policyVersion,
    String key = 'app_prviacy_accept_data',
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Set both legacy and new records to ensure backward compatibility
    await prefs.setBool(key, true);

    // Record version information
    final versionKey = '${key}_version';
    await prefs.setString(versionKey, policyVersion);

    // Record acceptance timestamp
    final timestampKey = '${key}_accepted_at';
    await prefs.setString(timestampKey, DateTime.now().toIso8601String());
  }

  /// 🆕 Get the time when user accepted privacy policy
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
  ///
  /// - region: Current region code (e.g. 'US', 'TW')
  /// - skipRegionList: List of regions to not display (optional)
  /// - onlyRegionList: List of regions to only display (optional)
  ///
  /// Rules:
  /// 1. If onlyRegionList is defined, only display in those regions
  /// 2. If skipRegionList is defined, do not display in those regions
  /// 3. If neither is defined, default to display
  static bool shouldShowPrivacyPage({
    required String? region,
    List<String>? skipRegionList,
    List<String>? onlyRegionList,
  }) {
    if (onlyRegionList != null) {
      // Only allow display in onlyRegionList regions
      return region != null && onlyRegionList.contains(region);
    }
    if (skipRegionList != null) {
      // Skip regions in skipRegionList
      return !(region != null && skipRegionList.contains(region));
    }
    // Default to display
    return true;
  }

  /// Get device country/region code (estimation only, not GPS/IP accurate)
  static Future<String?> getDeviceCountryCode() async {
    try {
      // Flutter 3.7+ recommends using PlatformDispatcher instead of window
      final locale = ui.PlatformDispatcher.instance.locale;
      return locale.countryCode?.toUpperCase();
    } catch (_) {}
    return null;
  }

  /// Automatically get device region and determine if privacy page should be skipped
  ///
  /// - skipRegionList: List of regions to not display (optional)
  /// - onlyRegionList: List of regions to only display (optional)
  ///
  /// Returns true if should skip (not display)
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

  @override
  Widget build(BuildContext context) {
    // Region can be determined externally, assuming external logic has already decided
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
                      titleText ?? 'Privacy Policy',
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
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
                          ...policyItems.map(
                            (item) => Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 6.0),
                                  child: Icon(
                                    Icons.brightness_1,
                                    size: 10,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (privacyLink != null && privacyTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: GestureDetector(
                                onTap: () => _launchUrl(context, privacyLink!),
                                child: Text(
                                  privacyTitle!,
                                  style: TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          if (termsLink != null && termsTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: GestureDetector(
                                onTap: () => _launchUrl(context, termsLink!),
                                child: Text(
                                  termsTitle!,
                                  style: TextStyle(
                                    color: Colors.blue,
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
                      // 🆕 Choose storage method based on whether version info is provided
                      if (policyVersion != null) {
                        await setAcceptedForVersion(
                          policyVersion: policyVersion!,
                          key: sharedPrefKey,
                        );
                      } else {
                        // Legacy compatibility mode
                        await setAccepted(key: sharedPrefKey);
                      }

                      if (onAccept != null) {
                        onAccept!();
                      } else {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(true);
                        }
                        // If cannot pop, do nothing, let external control handle it
                      }
                    },
                    child: Text(acceptText),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      if (onReject != null) {
                        onReject!();
                      } else {
                        Navigator.of(context).pop(false);
                      }
                    },
                    child: Text(rejectText),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchUrl(BuildContext context, String url) {
    // TODO: Can implement with url_launcher
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${snackBarOpenLinkText ?? 'Open link'}: $url')),
    );
  }
}
