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
  final List<String>? skipRegionList;
  final List<String>? forceShowRegionList;
  final List<String>? onlyRegionList;

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
    this.skipRegionList,
    this.forceShowRegionList,
    this.onlyRegionList,
  }) : super(key: key);

  static Future<bool> isAccepted(
      {String key = 'app_prviacy_accept_data'}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key) ?? false;
  }

  static bool shouldSkipPrivacyPage({
    required String? region,
    List<String>? skipRegionList,
    List<String>? forceShowRegionList,
  }) {
    if (region == null) return false;
    if (forceShowRegionList != null && forceShowRegionList.contains(region))
      return false;
    if (skipRegionList != null && skipRegionList.contains(region)) return true;
    return false;
  }

  static Future<void> setAccepted(
      {String key = 'app_prviacy_accept_data'}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, true);
  }

  /// 決定是否顯示隱私權頁面
  ///
  /// - region: 當前地區代碼（如 'US', 'TW'）
  /// - skipRegionList: 不顯示的地區清單（可選）
  /// - onlyRegionList: 僅顯示的地區清單（可選）
  ///
  /// 規則：
  /// 1. 若 onlyRegionList 有定義，僅在該清單內才顯示
  /// 2. 若 skipRegionList 有定義，該清單內則不顯示
  /// 3. 兩者皆未定義則預設顯示
  static bool shouldShowPrivacyPage({
    required String? region,
    List<String>? skipRegionList,
    List<String>? onlyRegionList,
  }) {
    if (onlyRegionList != null) {
      // 只允許 onlyRegionList 內的地區顯示
      return region != null && onlyRegionList.contains(region);
    }
    if (skipRegionList != null) {
      // 跳過 skipRegionList 內的地區
      return !(region != null && skipRegionList.contains(region));
    }
    // 預設顯示
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // region 可由外部決定傳入，這裡假設外部已判斷
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
                          ...policyItems.map((item) => Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(top: 6.0),
                                    child: Icon(Icons.brightness_1,
                                        size: 10, color: Colors.deepPurple),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(item,
                                          style: TextStyle(fontSize: 16))),
                                ],
                              )),
                          if (privacyLink != null && privacyTitle != null)
                            Padding(
                              padding: const EdgeInsets.only(top: 16.0),
                              child: GestureDetector(
                                onTap: () => _launchUrl(context, privacyLink!),
                                child: Text(
                                  privacyTitle!,
                                  style: TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline),
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
                                      decoration: TextDecoration.underline),
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
              padding:
                  const EdgeInsets.symmetric(vertical: 32.0, horizontal: 32.0),
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
                      await setAccepted(key: sharedPrefKey);
                      if (onAccept != null) {
                        onAccept!();
                      } else {
                        if (Navigator.canPop(context)) {
                          Navigator.of(context).pop(true);
                        }
                        // 若不能 pop，則不做事，交由外部控制
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
    // TODO: 可用 url_launcher 實作
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${snackBarOpenLinkText ?? 'Open link'}: $url')),
    );
  }
}
