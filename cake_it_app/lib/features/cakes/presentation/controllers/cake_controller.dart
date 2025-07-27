import 'package:flutter/material.dart';
import 'package:cake_it_app/core/failures.dart';
import 'package:cake_it_app/core/network_service.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_remote_datasource.dart';
import 'package:cake_it_app/features/cakes/data/repositories/cake_repository_impl.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/domain/repositories/cake_repository.dart';

// state management for cake list with caching and offline support
class CakeController with ChangeNotifier {
  late final CakeRepository _cakeRepository;
  late final NetworkService _networkService;

  CakeController() {
    _networkService = NetworkService();
    final remoteDataSource = CakeRemoteDataSource(_networkService);
    final localDataSource = CakeLocalDataSource();
    _cakeRepository = CakeRepositoryImpl(remoteDataSource, localDataSource);
  }

  List<Cake> _cakes = [];
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastLoadTime;
  static const Duration _cacheValidDuration = Duration(minutes: 5);

  List<Cake> get cakes => _cakes;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasError => _errorMessage != null;
  bool get isEmpty => _cakes.isEmpty && !_isLoading;

  bool get _shouldRefreshCache {
    if (_lastLoadTime == null) return true;
    return DateTime.now().difference(_lastLoadTime!) > _cacheValidDuration;
  }

  Future<void> loadCakes() async {
    // caching - don't reload if we have recent data
    if (_cakes.isNotEmpty && !_shouldRefreshCache) {
      return;
    }

    _setLoading(true);
    _clearError();

    try {
      final cakes = await _cakeRepository.getCakes();
      _setCakes(cakes);
      _lastLoadTime = DateTime.now();
    } catch (e) {
      _setError(e is Failure ? e.message : 'An unexpected error occurred');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> refreshCakes() async {
    // force refresh for pull-to-refresh - ignores cache timing
    _lastLoadTime = null;
    try {
      final cakes = await _cakeRepository.getCakes();
      _setCakes(cakes);
      _lastLoadTime = DateTime.now();
      _clearError();
    } catch (e) {
      _setError(e is Failure ? e.message : 'Failed to refresh cakes');
      rethrow;
    }
  }

  Future<void> retry() async {
    await loadCakes();
  }

  void _setCakes(List<Cake> cakes) {
    _cakes = cakes;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _networkService.dispose();
    super.dispose();
  }
}
