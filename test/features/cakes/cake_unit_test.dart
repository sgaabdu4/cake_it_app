import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/models/cake_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CakeLocalDataSource Tests', () {
    late CakeLocalDataSource dataSource;

    setUp(() {
      dataSource = CakeLocalDataSource();
      SharedPreferences.setMockInitialValues({});
    });

    test('should cache and retrieve cakes successfully', () async {
      // Given
      const testCakes = [
        CakeModel(
          title: 'Test Cake 1',
          description: 'Test Description 1',
          image: 'https://example.com/test1.jpg',
        ),
        CakeModel(
          title: 'Test Cake 2',
          description: 'Test Description 2',
          image: 'https://example.com/test2.jpg',
        ),
      ];

      // When
      await dataSource.cacheCakes(testCakes);
      final result = await dataSource.getCachedCakes();

      // Then
      expect(result, hasLength(2));
      expect(result[0].title, 'Test Cake 1');
      expect(result[0].description, 'Test Description 1');
      expect(result[0].image, 'https://example.com/test1.jpg');
      expect(result[1].title, 'Test Cake 2');
      expect(result[1].description, 'Test Description 2');
      expect(result[1].image, 'https://example.com/test2.jpg');
    });

    test('should handle corrupted cache data gracefully', () async {
      // Given - manually corrupt the cache
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_cakes', 'invalid json data');

      // When
      final result = await dataSource.getCachedCakes();

      // Then - should return empty list and clear corrupted cache
      expect(result, isEmpty);
      expect(await dataSource.hasCachedData(), isFalse);
    });
  });
}
