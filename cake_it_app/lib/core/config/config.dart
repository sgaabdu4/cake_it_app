/// Application configuration constants
class AppConfig {
  // API Configuration
  static const String baseUrl = 'https://gist.githubusercontent.com';
  static const String cakesEndpoint = '/hart88/79a65d27f52cbb74db7df1d200c4212b/raw/ebf57198c7490e42581508f4f40da88b16d784ba/cakeList';
  
  // Network Configuration
  static const Duration networkTimeout = Duration(seconds: 30);
  static const Duration retryDelay = Duration(seconds: 2);
  static const int maxRetries = 3;
  
  // UI Configuration
  static const Duration loadingDelay = Duration(seconds: 2); // TODO(Abid): Remove this artificial delay
  
  // App Information
  static const String appName = 'Cake It App';
  static const String version = '1.0.0';
}
