class ApiConfig {
  static const String baseUrl = 'http://localhost:3000';
  static const String apiPath = '/api';

  static String get clientesEndpoint => '$baseUrl$apiPath/clientes';

  static const Duration timeout = Duration(seconds: 30);

  static Map<String, String> get headers => {
    'Content-Type': 'application/json; charset=UTF-8',
    'Accept': 'application/json',
  };
}
