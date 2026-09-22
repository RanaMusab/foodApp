import Foundation

/// Native-side keys.
///
/// The Google Maps SDK needs its key before Flutter starts, so it cannot come
/// from `.env` (which is loaded in Dart). The value flows:
///
///   ios/Flutter/Secrets.xcconfig   (gitignored)
///     → GOOGLE_MAPS_API_KEY build setting
///     → GoogleMapsApiKey in Info.plist
///     → here
///
/// Copy `Secrets.example.xcconfig` to `Secrets.xcconfig` and add your key.
enum AppSecrets {
  static var googleMapsApiKey: String {
    let key = Bundle.main.object(forInfoDictionaryKey: "GoogleMapsApiKey") as? String
    guard let key, !key.isEmpty, !key.hasPrefix("ADD_YOUR") else {
      assertionFailure(
        "Missing Google Maps API key. Copy ios/Flutter/Secrets.example.xcconfig "
          + "to Secrets.xcconfig and set GOOGLE_MAPS_API_KEY."
      )
      return ""
    }
    return key
  }
}
