import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/cake_model.dart';

// local caching layer - new functionality not present in initial repo
class CakeLocalDataSource {
  static const String _cakesKey = 'cached_cakes';

  Future<List<CakeModel>> getCachedCakes() async {
    final prefs = await SharedPreferences.getInstance();
    final cachedData = prefs.getString(_cakesKey);

    if (cachedData == null) return [];

    try {
      final List<dynamic> jsonList = json.decode(cachedData);
      return jsonList
          .map((json) => CakeModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // handle corrupted cache data (JSON parsing errors)
      return [];
    }
  }

  Future<void> cacheCakes(List<CakeModel> cakes) async {
    final prefs = await SharedPreferences.getInstance();

    final jsonList = cakes
        .map((cake) => {
              'title': cake.title,
              'desc': cake.description,
              'image': cake.image,
            },)
        .toList();

    final jsonString = json.encode(jsonList);
    await prefs.setString(_cakesKey, jsonString);
  }

  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cakesKey);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cakesKey);
  }
}
