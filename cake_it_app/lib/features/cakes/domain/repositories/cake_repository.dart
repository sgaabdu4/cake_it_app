import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';

abstract interface class CakeRepository {
  Future<List<Cake>> getCakes();
}
