import 'package:flutter/material.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // 假設你有一個取得 country code 的方法
  String? countryCode = await getUserCountryCode();
  final shouldShow = PrivacyPolicyPage.shouldShowPrivacyPage(
    region: countryCode,
    skipRegionList: const ['US', 'CA'], // 範例：美國、加拿大不顯示
    onlyRegionList: const ['TW', 'JP'], // 範例：僅台灣、日本顯示
  );
  final accepted = await PrivacyPolicyPage.isAccepted();
  runApp(MyApp(showPolicy: shouldShow && !accepted));
}

Future<String?> getUserCountryCode() async {
  // TODO: 實際專案請用 geolocator、device_info_plus、ip api 等取得
  return null; // 預設 null 代表未知
}

// 在檔案最上方加上 navigatorKey
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final bool showPolicy;
  const MyApp({super.key, required this.showPolicy});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: showPolicy
          ? PrivacyPolicyPage(
              topIcon:
                  Image.asset('assets/app_icon.png', width: 100, height: 100),
              backgroundColor: const Color(0xFFFCF7FF),
              policyItems: const [
                'This app does not collect your personal data.',
                'This app uses Firebase for anonymous usage analytics.',
                'This app uses Admob for advertising services.',
              ],
              privacyLink: 'https://your.privacy.link',
              privacyTitle: 'Privacy Policy Link',
              termsLink: 'https://your.terms.link',
              termsTitle: 'Terms of Service Link',
              acceptText: 'Accept',
              rejectText: 'Exit',
              titleText: 'Privacy Policy',
              snackBarOpenLinkText: 'Open link',
              skipRegionList: const ['US', 'CA'],
              onlyRegionList: const ['TW', 'JP'],
              onAccept: () {
                // 預設跳轉到 Home 頁面
                // 需使用 navigatorKey 來取得 context
                navigatorKey.currentState?.pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
              onReject: () {
                // Custom reject action
              },
            )
          : const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('App Home Page')),
    );
  }
}
