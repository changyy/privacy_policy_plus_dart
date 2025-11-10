/// Localization configuration for PrivacyPolicyPage UI elements
class PrivacyPolicyLocalization {
  final String acceptText;
  final String rejectText;
  final String titleText;
  final String snackBarOpenLinkText;
  final String privacyTitle;
  final String termsTitle;

  const PrivacyPolicyLocalization({
    this.acceptText = 'Accept',
    this.rejectText = 'Reject',
    this.titleText = 'Privacy Policy',
    this.snackBarOpenLinkText = 'Open link',
    this.privacyTitle = 'Privacy Policy',
    this.termsTitle = 'Terms of Service',
  });

  /// Built-in localizations for common languages
  static const Map<String, PrivacyPolicyLocalization> builtInLocalizations = {
    'en': PrivacyPolicyLocalization(
      acceptText: 'Accept',
      rejectText: 'Reject',
      titleText: 'Privacy Policy',
      snackBarOpenLinkText: 'Open link',
      privacyTitle: 'Privacy Policy',
      termsTitle: 'Terms of Service',
    ),
    'zh_TW': PrivacyPolicyLocalization(
      acceptText: '接受',
      rejectText: '拒絕',
      titleText: '隱私權政策',
      snackBarOpenLinkText: '開啟連結',
      privacyTitle: '隱私權政策',
      termsTitle: '服務條款',
    ),
    'zh_CN': PrivacyPolicyLocalization(
      acceptText: '接受',
      rejectText: '拒绝',
      titleText: '隐私政策',
      snackBarOpenLinkText: '打开链接',
      privacyTitle: '隐私政策',
      termsTitle: '服务条款',
    ),
    'zh': PrivacyPolicyLocalization(
      acceptText: '接受',
      rejectText: '拒绝',
      titleText: '隐私政策',
      snackBarOpenLinkText: '打开链接',
      privacyTitle: '隐私政策',
      termsTitle: '服务条款',
    ),
    'ja': PrivacyPolicyLocalization(
      acceptText: '同意する',
      rejectText: '拒否',
      titleText: 'プライバシーポリシー',
      snackBarOpenLinkText: 'リンクを開く',
      privacyTitle: 'プライバシーポリシー',
      termsTitle: '利用規約',
    ),
    'ko': PrivacyPolicyLocalization(
      acceptText: '동의',
      rejectText: '거부',
      titleText: '개인정보 보호정책',
      snackBarOpenLinkText: '링크 열기',
      privacyTitle: '개인정보 보호정책',
      termsTitle: '서비스 약관',
    ),
    'es': PrivacyPolicyLocalization(
      acceptText: 'Aceptar',
      rejectText: 'Rechazar',
      titleText: 'Política de Privacidad',
      snackBarOpenLinkText: 'Abrir enlace',
      privacyTitle: 'Política de Privacidad',
      termsTitle: 'Términos de Servicio',
    ),
    'fr': PrivacyPolicyLocalization(
      acceptText: 'Accepter',
      rejectText: 'Refuser',
      titleText: 'Politique de Confidentialité',
      snackBarOpenLinkText: 'Ouvrir le lien',
      privacyTitle: 'Politique de Confidentialité',
      termsTitle: 'Conditions de Service',
    ),
    'de': PrivacyPolicyLocalization(
      acceptText: 'Akzeptieren',
      rejectText: 'Ablehnen',
      titleText: 'Datenschutzrichtlinie',
      snackBarOpenLinkText: 'Link öffnen',
      privacyTitle: 'Datenschutzrichtlinie',
      termsTitle: 'Nutzungsbedingungen',
    ),
    'pt': PrivacyPolicyLocalization(
      acceptText: 'Aceitar',
      rejectText: 'Rejeitar',
      titleText: 'Política de Privacidade',
      snackBarOpenLinkText: 'Abrir link',
      privacyTitle: 'Política de Privacidade',
      termsTitle: 'Termos de Serviço',
    ),
    'ru': PrivacyPolicyLocalization(
      acceptText: 'Принять',
      rejectText: 'Отклонить',
      titleText: 'Политика конфиденциальности',
      snackBarOpenLinkText: 'Открыть ссылку',
      privacyTitle: 'Политика конфиденциальности',
      termsTitle: 'Условия использования',
    ),
    'ar': PrivacyPolicyLocalization(
      acceptText: 'قبول',
      rejectText: 'رفض',
      titleText: 'سياسة الخصوصية',
      snackBarOpenLinkText: 'فتح الرابط',
      privacyTitle: 'سياسة الخصوصية',
      termsTitle: 'شروط الخدمة',
    ),
    'vi': PrivacyPolicyLocalization(
      acceptText: 'Chấp nhận',
      rejectText: 'Từ chối',
      titleText: 'Chính sách Bảo mật',
      snackBarOpenLinkText: 'Mở liên kết',
      privacyTitle: 'Chính sách Bảo mật',
      termsTitle: 'Điều khoản Dịch vụ',
    ),
    'th': PrivacyPolicyLocalization(
      acceptText: 'ยอมรับ',
      rejectText: 'ปฏิเสธ',
      titleText: 'นโยบายความเป็นส่วนตัว',
      snackBarOpenLinkText: 'เปิดลิงก์',
      privacyTitle: 'นโยบายความเป็นส่วนตัว',
      termsTitle: 'ข้อกำหนดการใช้บริการ',
    ),
    'id': PrivacyPolicyLocalization(
      acceptText: 'Terima',
      rejectText: 'Tolak',
      titleText: 'Kebijakan Privasi',
      snackBarOpenLinkText: 'Buka tautan',
      privacyTitle: 'Kebijakan Privasi',
      termsTitle: 'Ketentuan Layanan',
    ),
    'it': PrivacyPolicyLocalization(
      acceptText: 'Accetta',
      rejectText: 'Rifiuta',
      titleText: 'Informativa sulla Privacy',
      snackBarOpenLinkText: 'Apri link',
      privacyTitle: 'Informativa sulla Privacy',
      termsTitle: 'Termini di Servizio',
    ),
    'nl': PrivacyPolicyLocalization(
      acceptText: 'Accepteren',
      rejectText: 'Weigeren',
      titleText: 'Privacybeleid',
      snackBarOpenLinkText: 'Link openen',
      privacyTitle: 'Privacybeleid',
      termsTitle: 'Servicevoorwaarden',
    ),
    'pl': PrivacyPolicyLocalization(
      acceptText: 'Akceptuj',
      rejectText: 'Odrzuć',
      titleText: 'Polityka Prywatności',
      snackBarOpenLinkText: 'Otwórz link',
      privacyTitle: 'Polityka Prywatności',
      termsTitle: 'Warunki Usługi',
    ),
    'tr': PrivacyPolicyLocalization(
      acceptText: 'Kabul Et',
      rejectText: 'Reddet',
      titleText: 'Gizlilik Politikası',
      snackBarOpenLinkText: 'Bağlantıyı aç',
      privacyTitle: 'Gizlilik Politikası',
      termsTitle: 'Hizmet Şartları',
    ),
    'hi': PrivacyPolicyLocalization(
      acceptText: 'स्वीकार करें',
      rejectText: 'अस्वीकार करें',
      titleText: 'गोपनीयता नीति',
      snackBarOpenLinkText: 'लिंक खोलें',
      privacyTitle: 'गोपनीयता नीति',
      termsTitle: 'सेवा की शर्तें',
    ),
  };

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

  /// Get localization for a specific locale with fallback support
  ///
  /// - [locale]: Target locale string (e.g., 'en', 'zh_TW', 'zh_CN', 'zh-TW', 'zh-tw')
  /// - [fallbackLocale]: Fallback locale if target not found (default: 'en')
  ///
  /// Returns the localization object, defaults to English if not found
  ///
  /// Supports various locale formats including BCP 47 (zh-TW) and underscore (zh_TW)
  static PrivacyPolicyLocalization getLocalization(
    String locale, {
    String fallbackLocale = 'en',
  }) {
    // Normalize the input locale
    final normalizedLocale = _normalizeLocale(locale);

    // Try exact match first with normalized locale
    if (builtInLocalizations.containsKey(normalizedLocale)) {
      return builtInLocalizations[normalizedLocale]!;
    }

    // Try language code only (e.g., 'zh' from 'zh_TW')
    final languageCode = normalizedLocale.split('_').first;
    if (builtInLocalizations.containsKey(languageCode)) {
      return builtInLocalizations[languageCode]!;
    }

    // Try fallback locale (also normalize it)
    final normalizedFallback = _normalizeLocale(fallbackLocale);
    if (builtInLocalizations.containsKey(normalizedFallback)) {
      return builtInLocalizations[normalizedFallback]!;
    }

    // Try fallback language code only
    final fallbackLanguageCode = normalizedFallback.split('_').first;
    if (builtInLocalizations.containsKey(fallbackLanguageCode)) {
      return builtInLocalizations[fallbackLanguageCode]!;
    }

    // Default to English
    return builtInLocalizations['en']!;
  }
}
