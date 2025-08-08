class ApiConstants {
  // Base Configuration
  static const String baseUrl = 'http://testapi.flightsmojo.in';
  static const String apiVersion = '/MobApp';
  static const String apiBaseUrl = '$baseUrl$apiVersion';
  static const String authCode = 'Mobfl1asdfghasdftmoasdfjado2oApp';
  
  // Endpoints (relative paths since we're using baseUrl in Dio)
  static const String getCityEndpoint = '/getcity/';
  static const String getAirportsEndpoint = '/getairports/';
  static const String searchFlightsEndpoint = '/searchflights/';
  
  // Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  
  // Headers
  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Common parameters
  static const String authCodeKey = 'authcode';
  static const String idKey = 'id';
}
