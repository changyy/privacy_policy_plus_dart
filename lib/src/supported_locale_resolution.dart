import 'dart:ui' show Locale;

import 'locale_resolver.dart';

/// Pick the right `supportedLocales` entry for a Chinese device that reports a
/// **region but no script**.
///
/// ## Why this exists (and why [normalizeLocale] alone is not enough)
///
/// [normalizeLocale] runs on the locale this package is *given*. But by the
/// time a widget calls `Localizations.localeOf(context)`, Flutter has already
/// resolved the device locale against the app's `supportedLocales` — and that
/// step can **throw the script away before this package ever sees it**.
///
/// Concretely, with a script-based ARB set:
///
/// ```dart
/// supportedLocales: [
///   Locale('en'),
///   Locale('zh'),                                              // app_zh.arb
///   Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
///   Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
/// ]
/// ```
///
/// a device reporting `zh_TW` (region, **no script**) has no exact match, so
/// Flutter's default resolution falls back to matching on the language code
/// alone and lands on `Locale('zh')`. If `app_zh.arb` happens to be Simplified,
/// **every Traditional Chinese user gets a Simplified UI** — and this package
/// then faithfully resolves the bare `zh` it was handed to Simplified too.
/// Nothing is broken downstream; the information was already gone.
///
/// iOS usually reports `zh-Hant-TW` (script present), so this hides on iPhone
/// and shows up on **Android**, which commonly reports `zh_TW`.
///
/// ## Usage
///
/// ```dart
/// MaterialApp(
///   supportedLocales: AppLocalizations.supportedLocales,
///   localeResolutionCallback: resolveSupportedLocale,
///   // …
/// )
/// ```
///
/// Returns `null` for everything it has no opinion about, which tells Flutter
/// to run its normal resolution. It only speaks up for the one case it can
/// genuinely improve.
///
/// Works with either ARB style: it prefers a script-based entry
/// (`zh` + `Hant`) and falls back to a region-based one (`zh_TW`).
Locale? resolveSupportedLocale(Locale? device, Iterable<Locale> supported) {
  if (device == null) return null;
  if (device.languageCode.toLowerCase() != 'zh') return null;

  // Script already present: nothing was lost, let Flutter match it normally.
  if (device.scriptCode != null) return null;

  final country = device.countryCode;
  if (country == null || country.isEmpty) {
    // Bare `zh` carries no signal. Guessing here would be worse than the
    // default — the caller's `fallbackLocale` chain is the right place for it.
    return null;
  }

  // Single source of truth: the same rule the string resolver uses.
  final key = normalizeLocale('zh_$country'); // zh_TW | zh_CN
  final wantedScript = key == 'zh_TW' ? 'Hant' : 'Hans';
  final wantedCountry = key.split('_').last; // TW | CN

  for (final locale in supported) {
    if (locale.languageCode.toLowerCase() == 'zh' &&
        locale.scriptCode == wantedScript) {
      return locale;
    }
  }
  for (final locale in supported) {
    if (locale.languageCode.toLowerCase() == 'zh' &&
        locale.countryCode?.toUpperCase() == wantedCountry) {
      return locale;
    }
  }

  // The app does not ship that variant. Say nothing rather than pick the wrong
  // one — Flutter's fallback is at least predictable.
  return null;
}
