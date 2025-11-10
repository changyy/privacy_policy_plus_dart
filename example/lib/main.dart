import 'package:flutter/material.dart';
import 'package:privacy_policy_plus/privacy_policy_plus.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Check if privacy policy needs to be shown based on region
  final shouldShowRule =
      !(await PrivacyPolicyPage.shouldSkipPrivacyPageByDevice(
    skipRegionList: const ['US', 'CA'], // Example: Skip for US, Canada
  ));

  // Check if current version has been accepted
  final accepted = await PrivacyPolicyPage.isAcceptedForVersion(
    currentPolicyVersion: '1.0.0',
  );

  runApp(MyApp(showPolicy: shouldShowRule && !accepted));
}

// Global navigator key for navigation
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
              // Version control
              policyVersion: '1.0.0',

              // UI customization
              topIcon: Image.asset(
                'assets/app_icon.png',
                width: 100,
                height: 100,
              ),
              backgroundColor: const Color(0xFFFCF7FF),

              // NEW: Hierarchical and multi-language policy items
              policyItemsHierarchical: [
                PolicyItem({
                  'en':
                      'To provide better services and improve your experience, we use the following services:',
                  'zh_TW': '為了提供更好的服務並改善您的體驗，我們使用以下服務：',
                  'zh_CN': '为了提供更好的服务并改善您的体验，我们使用以下服务：',
                  'ja': 'より良いサービスを提供し、エクスペリエンスを向上させるために、以下のサービスを使用します：',
                }, children: [
                  PolicyItem({
                    'en': 'Data Analytics:',
                    'zh_TW': '資料分析：',
                    'zh_CN': '数据分析：',
                    'ja': 'データ分析：',
                  }, children: [
                    PolicyItem({
                      'en':
                          'We use Firebase Analytics to anonymously track device information',
                      'zh_TW': '我們使用 Firebase Analytics 匿名追蹤裝置資訊',
                      'zh_CN': '我们使用 Firebase Analytics 匿名跟踪设备信息',
                      'ja': 'Firebase Analyticsを使用してデバイス情報を匿名で追跡します',
                    }),
                    PolicyItem({
                      'en':
                          'This helps us optimize app performance and user experience',
                      'zh_TW': '這有助於我們優化應用程式效能和使用者體驗',
                      'zh_CN': '这有助于我们优化应用程序性能和用户体验',
                      'ja': 'これにより、アプリのパフォーマンスとユーザー体験を最適化できます',
                    }),
                    PolicyItem({
                      'en':
                          'For details, see Firebase Privacy: https://firebase.google.com/support/privacy',
                      'zh_TW':
                          '詳情請參閱 Firebase 隱私權政策：https://firebase.google.com/support/privacy',
                      'zh_CN':
                          '详情请参阅 Firebase 隐私政策：https://firebase.google.com/support/privacy',
                      'ja':
                          '詳細については、Firebaseプライバシーをご覧ください：https://firebase.google.com/support/privacy',
                    }),
                  ]),
                  PolicyItem({
                    'en': 'Advertising:',
                    'zh_TW': '廣告：',
                    'zh_CN': '广告：',
                    'ja': '広告：',
                  }, children: [
                    PolicyItem({
                      'en': 'We use Google AdMob to display advertisements',
                      'zh_TW': '我們使用 Google AdMob 顯示廣告',
                      'zh_CN': '我们使用 Google AdMob 显示广告',
                      'ja': 'Google AdMobを使用して広告を表示します',
                    }),
                    PolicyItem({
                      'en': 'Ads help us keep the app free for everyone',
                      'zh_TW': '廣告幫助我們讓所有人都能免費使用此應用程式',
                      'zh_CN': '广告帮助我们让所有人都能免费使用此应用程序',
                      'ja': '広告により、アプリを無料で提供できます',
                    }),
                  ]),
                  PolicyItem({
                    'en': 'Device Permissions:',
                    'zh_TW': '裝置權限：',
                    'zh_CN': '设备权限：',
                    'ja': 'デバイスの権限：',
                  }, children: [
                    PolicyItem({
                      'en': 'Based on app functionality, we may access:',
                      'zh_TW': '根據應用程式功能，我們可能會存取：',
                      'zh_CN': '根据应用程序功能，我们可能会访问：',
                      'ja': 'アプリの機能に基づいて、以下にアクセスする場合があります：',
                    }, children: [
                      PolicyItem({
                        'en': 'Location - for location-based features',
                        'zh_TW': '位置 - 用於基於位置的功能',
                        'zh_CN': '位置 - 用于基于位置的功能',
                        'ja': '位置情報 - 位置ベースの機能用',
                      }),
                      PolicyItem({
                        'en': 'Camera - for scanning QR codes and taking photos',
                        'zh_TW': '相機 - 用於掃描 QR 碼和拍照',
                        'zh_CN': '相机 - 用于扫描二维码和拍照',
                        'ja': 'カメラ - QRコードのスキャンと写真撮影用',
                      }),
                    ]),
                  ]),
                ]),
                PolicyItem({
                  'en':
                      'We do not collect or store personal information without your consent',
                  'zh_TW': '未經您的同意，我們不會收集或儲存個人資訊',
                  'zh_CN': '未经您的同意，我们不会收集或存储个人信息',
                  'ja': 'お客様の同意なしに個人情報を収集または保存することはありません',
                }),
                PolicyItem({
                  'en': 'All data is used solely to improve service quality',
                  'zh_TW': '所有資料僅用於改善服務品質',
                  'zh_CN': '所有数据仅用于改善服务质量',
                  'ja': 'すべてのデータは、サービス品質の向上のためにのみ使用されます',
                }),
              ],

              // Localization settings
              // locale: 'zh_TW', // Uncomment to force specific locale
              fallbackLocale: 'en',

              // Links
              privacyLink: 'https://your.privacy.link',
              termsLink: 'https://your.terms.link',

              // Callbacks
              onAccept: () {
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
      appBar: AppBar(
        title: const Text('Privacy Policy Plus Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'App Home Page',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                final version =
                    await PrivacyPolicyPage.getAcceptedVersion();
                final acceptedAt = await PrivacyPolicyPage.getAcceptedAt();

                if (!context.mounted) return;

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Privacy Policy Info'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Accepted Version: ${version ?? 'None'}'),
                        const SizedBox(height: 8),
                        Text(
                          'Accepted At: ${acceptedAt?.toString() ?? 'None'}',
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Check Privacy Policy Status'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PrivacyPolicyPage(
                      policyVersion: '1.0.0',
                      backgroundColor: const Color(0xFFFCF7FF),
                      policyItemsHierarchical: [
                        PolicyItem({
                          'en': 'Simple example with single language',
                          'zh_TW': '單一語言的簡單範例',
                          'zh_CN': '单一语言的简单示例',
                        }),
                        PolicyItem.single(
                          'You can also use PolicyItem.single() for convenience',
                          children: [
                            PolicyItem.single('Child item 1'),
                            PolicyItem.single('Child item 2'),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Text('Show Privacy Policy Again'),
            ),
          ],
        ),
      ),
    );
  }
}
