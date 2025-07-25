import 'dart:convert';
import 'package:cake_it_app/core/config/config.dart';
import 'package:cake_it_app/core/error/failures.dart';
import 'package:http/http.dart' as http;


/// Network service for handling HTTP requests
class NetworkService {
  final http.Client _client;
  
  NetworkService({http.Client? client}) : _client = client ?? http.Client();
  
  /// Makes a GET request to the specified endpoint
  Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
      
      final response = await _client.get(url).timeout(
        AppConfig.networkTimeout,
        onTimeout: () => throw NetworkFailure('Request timeout'),
      );
      
      if (response.statusCode == 200) {
        final decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        } else if (decodedResponse is List) {
          return {'data': decodedResponse};
        } else {
          throw ParsingFailure('Unexpected response format');
        }
      } else {
        throw ServerFailure('Server returned ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (e is Failure) {
        rethrow;
      } else {
        throw NetworkFailure('Network error: ${e.toString()}');
      }
    }
  }
  
  /// Disposes the HTTP client
  void dispose() {
    _client.close();
  }
}
