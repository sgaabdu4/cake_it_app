import 'package:cake_it_app/core/network_service.dart';
import 'package:cake_it_app/core/config.dart';
import 'package:cake_it_app/features/cakes/data/models/cake_model.dart';
import 'package:flutter/widgets.dart';

// remote data layer - replaces direct api calls in ui from initial repo
class CakeRemoteDataSource {
  final NetworkService _networkService;

  CakeRemoteDataSource(this._networkService);

  Future<List<CakeModel>> getCakes() async {
    final response = await _networkService.get(AppConfig.cakesEndpoint);

    final List<dynamic> cakesJson =
        response is List ? response : (response['data'] as List? ?? []);

    try {
      return cakesJson
          .map((json) => CakeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      debugPrint('Failed to parse cakes: $e');
      // json parsing failed so return empty list
      return [];
    }
  }
}
