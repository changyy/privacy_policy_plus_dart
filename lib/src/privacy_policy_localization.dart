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

  /// Get localization for a specific locale with fallback support
  ///
  /// - [locale]: Target locale string (e.g., 'en', 'zh_TW', 'zh_CN')
  /// - [fallbackLocale]: Fallback locale if target not found (default: 'en')
  ///
  /// Returns the localization object, defaults to English if not found
  static PrivacyPolicyLocalization getLocalization(
    String locale, {
    String fallbackLocale = 'en',
  }) {
    // Try exact match first
    if (builtInLocalizations.containsKey(locale)) {
      return builtInLocalizations[locale]!;
    }

    // Try language code only (e.g., 'zh' from 'zh_TW')
    final languageCode = locale.split('_').first;
    if (builtInLocalizations.containsKey(languageCode)) {
      return builtInLocalizations[languageCode]!;
    }

    // Try fallback locale
    if (builtInLocalizations.containsKey(fallbackLocale)) {
      return builtInLocalizations[fallbackLocale]!;
    }

    // Default to English
    return builtInLocalizations['en']!;
  }
}
