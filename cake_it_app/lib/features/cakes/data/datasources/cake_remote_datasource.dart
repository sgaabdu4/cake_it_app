import 'package:cake_it_app/core/network_service.dart';
import 'package:cake_it_app/core/config.dart';
import 'package:cake_it_app/core/failures.dart';
import '../models/cake_model.dart';

class CakeRemoteDataSource {
  final NetworkService _networkService;

  CakeRemoteDataSource(this._networkService);

  Future<List<CakeModel>> getCakes() async {
    try {
      final response = await _networkService.get(AppConfig.cakesEndpoint);

      final List<dynamic> cakesJson = response is List ? response : (response['data'] as List? ?? []);

      return cakesJson.map((json) => CakeModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw Failure('Failed to fetch cakes: $e');
    }
  }
}
