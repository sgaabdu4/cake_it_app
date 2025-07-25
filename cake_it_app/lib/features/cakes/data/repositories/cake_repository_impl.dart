import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/domain/repositories/cake_repository.dart';

/// Implementation of CakeRepository
class CakeRepositoryImpl implements CakeRepository {
  final CakeRemoteDataSource _remoteDataSource;
  
  CakeRepositoryImpl(this._remoteDataSource);
  
  @override
  Future<List<Cake>> getCakes() async {
    final cakeModels = await _remoteDataSource.getCakes();
    return cakeModels.map((model) => model.toEntity()).toList();
  }
  
  @override
  Future<List<Cake>> refreshCakes() async {
    // TODO(Abid): This should clear cache if we're saving locally or refresh data from the source
    // For now, refresh just calls getCakes again
    return await getCakes();
  }
}
