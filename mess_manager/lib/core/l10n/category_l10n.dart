import 'app_localizations.dart';

/// Resolves a seeded category's [defaultKey] to a localized display name.
/// User-created categories have no defaultKey and are shown as stored.
String resolveCategoryName(AppLocalizations l10n, String? defaultKey, String fallback) {
  switch (defaultKey) {
    case 'bazar':
      return l10n.categoryBazar;
    case 'rent':
      return l10n.categoryRent;
    case 'utility':
      return l10n.categoryUtility;
    case 'wifi':
      return l10n.categoryWifi;
    case 'maid':
      return l10n.categoryMaid;
    case 'gas':
      return l10n.categoryGas;
    case 'repairs':
      return l10n.categoryRepairs;
    case 'misc':
      return l10n.categoryMisc;
    default:
      return fallback;
  }
}
