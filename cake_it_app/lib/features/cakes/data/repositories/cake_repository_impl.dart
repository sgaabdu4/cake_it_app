import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/domain/repositories/cake_repository.dart';

class CakeRepositoryImpl implements CakeRepository {
  final CakeRemoteDataSource _remoteDataSource;

  CakeRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Cake>> getCakes() async {
    final cakeModels = await _remoteDataSource.getCakes();
    return cakeModels.map((model) => model.toEntity()).toList();
  }
}
