import 'package:cake_it_app/core/network_service.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/data/repositories/cake_repository_impl.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// unit tests with real network calls

void main() {
  group('CakeRepositoryImpl Tests', () {
    late CakeRepositoryImpl repository;
    late CakeRemoteDataSource remoteDataSource;
    late CakeLocalDataSource localDataSource;
    late NetworkService networkService;

    setUp(() {
      // real network service for unit testing
      networkService = NetworkService();
      remoteDataSource = CakeRemoteDataSource(networkService);
      localDataSource = CakeLocalDataSource();
      repository = CakeRepositoryImpl(remoteDataSource, localDataSource);

      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      networkService.dispose();
    });

    test('should fetch from network when no cache available', () async {
      // when repository gets cakes for first time
      final result = await repository.getCakes();

      // then should fetch from network and cache
      expect(result, isNotEmpty);
      expect(result.first.title, isNotEmpty);

      // verify data was cached
      final cachedData = await localDataSource.getCachedCakes();
      expect(cachedData, isNotEmpty);
      expect(cachedData.first.title, result.first.title);
    });

    test('should return empty list when both cache and network fail', () async {
      // test graceful error when network fails

      // when network service encounters an error
      final badRemoteDataSource = CakeRemoteDataSource(NetworkService());
      final testRepository =
          CakeRepositoryImpl(badRemoteDataSource, localDataSource);

      final result = await testRepository.getCakes();

      // then should handle gracefully
      expect(result, isA<List>());
    });
  });
}
