import 'dart:io';

/// Utility class to verify actual internet access.
///
/// Connectivity alone does not guarantee internet availability,
/// so this performs a lightweight DNS lookup.
class InternetHelper {
  static Future<bool> hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(seconds: 3));
      return result.isNotEmpty && result.first.rawAddress.isNotEmpty;
    } catch (_) {
      return false;
    }
  }
}
