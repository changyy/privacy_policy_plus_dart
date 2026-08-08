// Locale matching for content maps keyed by `en` / `zh_TW` / `zh_CN` / `ja` …
//
// ## Why this exists
//
// Flutter hands you **script-based** locales, while content maps are almost
// always written with **country-based** keys. A Traditional Chinese device
// resolves to `Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')` —
// note that **`countryCode` is null**.
//
// Code that only looks at `countryCode` produces `'zh'`, which matches no key
// in a `{en, zh_TW, zh_CN, ja}` map, so the whole page silently falls back to
// English. That shipped: Traditional Chinese users saw a Simplified title with
// an English body (reported 2026-08-08).
//
// Two rules fix it:
//
// 1. **Script beats country.** `zh-Hant-CN` is Traditional — the user picked
//    the script; the region only says where they are.
// 2. **Try a chain, not a single key.** `zh_HK` should reach `zh_TW` before it
//    gives up and shows English.

/// Normalize any locale spelling into the canonical key form.
///
/// Accepts BCP 47 (`zh-Hant-TW`), underscore (`zh_TW`), and any casing.
/// Chinese script subtags are folded into the country-based key that content
/// maps actually use: `Hant` → `zh_TW`, `Hans` → `zh_CN`.
String normalizeLocale(String locale) {
  if (locale.isEmpty) return locale;

  final parts =
      locale.split(RegExp(r'[-_]')).where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return locale;

  final language = parts.first.toLowerCase();

  // A script subtag is 4 letters (Hant, Hans, Latn, Cyrl …).
  String? script;
  String? country;
  for (final part in parts.skip(1)) {
    if (part.length == 4 && RegExp(r'^[A-Za-z]{4}$').hasMatch(part)) {
      script = part[0].toUpperCase() + part.substring(1).toLowerCase();
    } else if (part.length == 2 || part.length == 3) {
      country = part.toUpperCase();
    }
  }

  if (language == 'zh') {
    // Rule 1: script wins over country.
    if (script == 'Hant') return 'zh_TW';
    if (script == 'Hans') return 'zh_CN';
    if (country == 'TW' || country == 'HK' || country == 'MO') return 'zh_TW';
    if (country != null) return 'zh_CN';
    // Bare `zh` with no signal at all: keep it as-is so the caller's chain can
    // still try `zh` before falling back.
    return 'zh';
  }

  return country != null ? '${language}_$country' : language;
}

/// Ordered keys to try for [locale], most specific first.
///
/// Always ends with the bare language code, so a map keyed only by `zh` still
/// works. Callers append their own fallback locale after this list.
List<String> localeCandidates(String locale) {
  final normalized = normalizeLocale(locale);
  final language = normalized.split('_').first;

  final candidates = <String>[normalized];

  // Rule 2: Chinese variants reach across to their same-script sibling before
  // giving up — Hong Kong and Macau users should get Traditional, not English.
  if (language == 'zh') {
    if (normalized == 'zh_TW') {
      candidates.addAll(['zh_HK', 'zh_MO', 'zh_Hant']);
    } else if (normalized == 'zh_CN') {
      candidates.addAll(['zh_SG', 'zh_Hans']);
    } else {
      candidates.addAll(['zh_CN', 'zh_TW']);
    }
  }

  candidates.add(language);

  // De-duplicate while preserving order.
  final seen = <String>{};
  return candidates.where(seen.add).toList();
}

/// Pick the first candidate present in [map], else the fallback chain, else null.
T? resolveFromMap<T>(
  Map<String, T> map,
  String locale, {
  String fallbackLocale = 'en',
}) {
  for (final key in localeCandidates(locale)) {
    final hit = map[key];
    if (hit != null) return hit;
  }
  for (final key in localeCandidates(fallbackLocale)) {
    final hit = map[key];
    if (hit != null) return hit;
  }
  return null;
}
