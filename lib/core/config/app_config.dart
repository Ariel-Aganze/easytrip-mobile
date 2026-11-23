/// App-wide configuration read from the build environment.
///
/// The API base URL defaults to the local Django dev server as seen from the
/// Android emulator (`10.0.2.2` is the host machine's `localhost`). Override it
/// for a real device or a deployed backend without touching code:
///
///   flutter run --dart-define=API_BASE_URL=https://api.easytrip.app/api/v1
///
/// On the iOS simulator use http://localhost:8000/api/v1; on a physical phone
/// use your computer's LAN IP, e.g. http://192.168.1.20:8000/api/v1
class AppConfig {
  const AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000/api/v1',
  );

  static const Duration connectTimeout = Duration(seconds: 20);
  static const Duration receiveTimeout = Duration(seconds: 20);
}
