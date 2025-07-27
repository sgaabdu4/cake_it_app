import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/domain/repositories/cake_repository.dart';
import 'package:flutter/foundation.dart';

// repository pattern with cache-first strategy - replaces direct api calls from initial repo
class CakeRepositoryImpl implements CakeRepository {
  final CakeRemoteDataSource _remoteDataSource;
  final CakeLocalDataSource _localDataSource;

  CakeRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<List<Cake>> getCakes() async {
    // try cache first
    final cachedCakes = await _getCachedCakes();
    if (cachedCakes.isNotEmpty) {
      // return cached data immediately, update in background
      _updateCacheInBackground();
      return cachedCakes;
    }

    // no cache, fetch from network
    final cakeModels = await _remoteDataSource.getCakes();
    await _localDataSource.cacheCakes(cakeModels);
    return cakeModels.map((model) => model.toEntity()).toList();
  }

  Future<List<Cake>> _getCachedCakes() async {
    try {
      final cachedModels = await _localDataSource.getCachedCakes();
      return cachedModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      debugPrint('Failed to load cached cakes: $e');
      return []; // cache read failed, return empty
    }
  }

  Future<void> _updateCacheInBackground() async {
    try {
      final cakeModels = await _remoteDataSource.getCakes();
      await _localDataSource.cacheCakes(cakeModels);
    } catch (e) {
      // log background cache update failures for debugging
      debugPrint('Background cache update failed: $e');
      // silent failure - don't propagate as this is background operation
    }
  }
}
