import 'package:cake_it_app/core/network/network_service.dart';
import 'package:cake_it_app/core/config/config.dart';
import 'package:cake_it_app/core/error/failures.dart';
import '../models/cake_model.dart';

/// Remote data source for cake data
class CakeRemoteDataSource {
  final NetworkService _networkService;
  
  CakeRemoteDataSource(this._networkService);
  
  /// Fetches cakes from the remote API
  Future<List<CakeModel>> getCakes() async {
    try {
      final response = await _networkService.get(AppConfig.cakesEndpoint);
      
      // Use Dart 3.0 pattern matching to handle different response types
      final List<dynamic> cakesJson = switch (response) {
        {'data': List<dynamic> data} => data,  // NetworkService wrapped response
        List<dynamic> array => array,          // Direct array response
        _ => throw ParsingFailure('Expected array of cakes, got: ${response.runtimeType}'),
      };
      
      return cakesJson.map((json) => CakeModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      if (e is Failure) rethrow;
      throw NetworkFailure('Failed to fetch cakes: $e');
    }
  }
}
