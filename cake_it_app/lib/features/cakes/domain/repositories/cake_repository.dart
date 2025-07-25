
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';

/// Repository for cake data operations
abstract interface class CakeRepository {
  /// Fetches all cakes from the data source
  Future<List<Cake>> getCakes();

  /// Refreshes the cake list - for pull to refresh
  Future<List<Cake>> refreshCakes();
}
