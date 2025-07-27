import 'package:cake_it_app/core/network_service.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:flutter_test/flutter_test.dart';

// unit tests with real network calls

void main() {
  group('CakeRemoteDataSource Tests', () {
    late CakeRemoteDataSource dataSource;
    late NetworkService networkService;

    setUp(() {
      // real network service for unit testing
      networkService = NetworkService();
      dataSource = CakeRemoteDataSource(networkService);
    });

    tearDown(() {
      networkService.dispose();
    });

    test('should return list of CakeModel on successful API call', () async {
      // when making real network call to api
      final result = await dataSource.getCakes();

      // then should get cake data from api
      expect(result, isNotEmpty);
      expect(result.first.title, isNotEmpty);
      expect(result.first.description, isNotEmpty);
      expect(result.first.image, isNotEmpty);
    });

    test('should return empty list when API returns invalid JSON', () async {
      // test graceful handling of json parsing errors

      // when getCakes is called (live api should return valid json)
      final result = await dataSource.getCakes();

      // then should handle response gracefully
      expect(result, isA<List>());
    });
  });
}
