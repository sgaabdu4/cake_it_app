import 'dart:convert';
import 'package:cake_it_app/core/config.dart';
import 'package:cake_it_app/core/failures.dart';
import 'package:http/http.dart' as http;

class NetworkService {
  final http.Client _client;

  NetworkService({http.Client? client}) : _client = client ?? http.Client();

  Future<dynamic> get(String endpoint) async {
    try {
      final url = Uri.parse('${AppConfig.baseUrl}$endpoint');

      final response = await _client.get(url).timeout(
            AppConfig.networkTimeout,
            onTimeout: () => throw const Failure('Request timeout'),
          );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Failure('Server error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Network error: $e');
    }
  }

  void dispose() => _client.close();
}
