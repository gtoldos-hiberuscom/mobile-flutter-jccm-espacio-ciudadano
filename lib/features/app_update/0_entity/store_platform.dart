/// Tienda de la que procede la app instalada. Decide en qué «espacio» viven
/// las versiones que se comparan:
///
/// - [ios]: versión de marketing `x.y.z` (`CFBundleShortVersionString`), la
///   misma que publica App Store.
/// - [android]: Google Play solo expone el `versionCode`, así que instalada y
///   publicada se comparan como `AppVersion(0, 0, versionCode)`.
enum StorePlatform { android, ios }
