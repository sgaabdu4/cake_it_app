import 'dart:convert';

import 'package:cake_it_app/core/config.dart';
import 'package:cake_it_app/core/errors.dart';
import 'package:cake_it_app/core/network_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// Mock classes for testing
class MockHttpClient extends http.BaseClient {
  final Map<String, http.Response> responses = {};
  final List<String> requests = [];
  Duration? delayResponse;
  Exception? throwException;

  void setResponse(String url, http.Response response) {
    responses[url] = response;
  }

  void setDelayResponse(Duration delay) {
    delayResponse = delay;
  }

  void setThrowException(Exception exception) {
    throwException = exception;
  }

  void clearRequests() {
    requests.clear();
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    requests.add(request.url.toString());

    if (throwException != null) {
      throw throwException!;
    }

    if (delayResponse != null) {
      await Future.delayed(delayResponse!);
    }

    final response = responses[request.url.toString()];
    if (response != null) {
      return http.StreamedResponse(
        Stream.value(response.bodyBytes),
        response.statusCode,
        headers: response.headers,
      );
    }
    throw Exception('No mock response for ${request.url}');
  }
}

void main() {
  group('NetworkService Tests', () {
    late NetworkService networkService;
    late MockHttpClient mockClient;

    setUp(() {
      mockClient = MockHttpClient();
      networkService = NetworkService(client: mockClient);
    });

    tearDown(() {
      networkService.dispose();
    });

    test('should return parsed JSON data on successful request', () async {
      // Given
      const endpoint = '/test';
      final expectedData = {'key': 'value'};
      mockClient.setResponse(
        '${AppConfig.baseUrl}$endpoint',
        http.Response(json.encode(expectedData), 200),
      );

      // When
      final result = await networkService.get(endpoint);

      // Then
      expect(result, expectedData);
      expect(mockClient.requests, contains('${AppConfig.baseUrl}$endpoint'));
    });

    test('should throw ServerError on non-200 status code', () async {
      // Given
      const endpoint = '/test';
      mockClient.setResponse(
        '${AppConfig.baseUrl}$endpoint',
        http.Response('Not Found', 404),
      );

      // When & Then
      expect(
        () => networkService.get(endpoint),
        throwsA(
          isA<ServerError>().having((e) => e.statusCode, 'statusCode', 404),
        ),
      );
    });

    test(
      'should throw NetworkTimeoutError on timeout',
      () async {
        // Given
        const endpoint = '/test';
        mockClient.setDelayResponse(
            const Duration(seconds: 31),); // Longer than timeout

        // When & Then
        expect(
          () => networkService.get(endpoint),
          throwsA(isA<NetworkTimeoutError>()),
        );
      },
      timeout: const Timeout(Duration(seconds: 35)),
    );

    test('should throw NetworkError on other exceptions', () async {
      // Given
      const endpoint = '/test';
      mockClient.setThrowException(Exception('Connection failed'));

      // When & Then
      expect(
        () => networkService.get(endpoint),
        throwsA(isA<NetworkError>()),
      );
    });
  });
}
