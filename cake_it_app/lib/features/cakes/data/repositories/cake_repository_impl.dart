import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/domain/repositories/cake_repository.dart';

// repository pattern with cache-first strategy - replaces direct api calls from initial repo
class CakeRepositoryImpl implements CakeRepository {
  final CakeRemoteDataSource _remoteDataSource;
  final CakeLocalDataSource _localDataSource;

  CakeRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Cake>> getCakes() async {
    // cache-first strategy for better performance
    try {
      final cachedCakes = await _localDataSource.getCachedCakes();
      if (cachedCakes.isNotEmpty) {
        // return cached data immediately, then update in background
        _updateCacheInBackground();
        return cachedCakes.map((model) => model.toEntity()).toList();
      }
    } catch (e) {
      // could log this error in a real app
      // cache read failed, continue to network
    }

    // no cache or cache failed, fetch from network
    try {
      final cakeModels = await _remoteDataSource.getCakes();
      await _localDataSource.cacheCakes(cakeModels);
      return cakeModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      // network failed, try cache as final fallback
      final cachedCakes = await _localDataSource.getCachedCakes();
      if (cachedCakes.isNotEmpty) {
        return cachedCakes.map((model) => model.toEntity()).toList();
      }
      rethrow; // no cached data available, throw original error
    }
  }

  Future<void> _updateCacheInBackground() async {
    try {
      final cakeModels = await _remoteDataSource.getCakes();
      await _localDataSource.cacheCakes(cakeModels);
    } catch (e) {
      // background update failed - not critical for app functionality
      // could log this error in a real app
    }
  }
}
