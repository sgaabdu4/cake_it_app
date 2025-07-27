import 'dart:convert';
import 'package:flutter/material.dart';
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
      return jsonList.map((json) => CakeModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      debugPrint('Failed to parse cached cakes: $e');
      // corrupted cache detected - clear it and return empty list
      await clearCache();
      return [];
    }
  }

  Future<void> cacheCakes(List<CakeModel> cakes) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = cakes.map((cake) => cake.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString(_cakesKey, jsonString);
    } catch (e) {
      debugPrint('Failed to cache cakes: $e');
      // silent failure for cache write - app can continue without cache
      return;
    }
  }

  // unused but only used in tests
  Future<bool> hasCachedData() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_cakesKey);
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cakesKey);
  }
}
