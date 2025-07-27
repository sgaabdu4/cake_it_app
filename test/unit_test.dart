import 'package:cake_it_app/core/failures.dart';
import 'package:cake_it_app/features/cakes/data/datasources/cake_local_datasource.dart';
import 'package:cake_it_app/features/cakes/data/models/cake_model.dart';
import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('CakeModel Tests', () {
    test('fromJson should create CakeModel with valid data', () {
      // Arrange
      final json = {
        'title': 'Chocolate Cake',
        'desc': 'Delicious chocolate cake',
        'image': 'https://example.com/cake.jpg',
      };

      // Act
      final cakeModel = CakeModel.fromJson(json);

      // Assert
      expect(cakeModel.title, 'Chocolate Cake');
      expect(cakeModel.description, 'Delicious chocolate cake');
      expect(cakeModel.image, 'https://example.com/cake.jpg');
    });

    test('fromJson should handle null values gracefully', () {
      // Arrange
      final json = <String, dynamic>{};

      // Act
      final cakeModel = CakeModel.fromJson(json);

      // Assert
      expect(cakeModel.title, '');
      expect(cakeModel.description, '');
      expect(cakeModel.image, '');
    });

    test('toEntity should convert CakeModel to Cake entity', () {
      // Arrange
      const cakeModel = CakeModel(
        title: 'Vanilla Cake',
        description: 'Sweet vanilla cake',
        image: 'https://example.com/vanilla.jpg',
      );

      // Act
      final cake = cakeModel.toEntity();

      // Assert
      expect(cake, isA<Cake>());
      expect(cake.title, 'Vanilla Cake');
      expect(cake.description, 'Sweet vanilla cake');
      expect(cake.imageUrl, 'https://example.com/vanilla.jpg');
    });

    test('toEntity should handle null values in model', () {
      // Arrange
      const cakeModel = CakeModel(title: null, description: null, image: null);

      // Act
      final cake = cakeModel.toEntity();

      // Assert
      expect(cake.title, '');
      expect(cake.description, '');
      expect(cake.imageUrl, '');
    });
  });

  group('Cake Entity Tests', () {
    test('should create Cake with all properties', () {
      // Arrange & Act
      const cake = Cake(
        title: 'Red Velvet Cake',
        description: 'Delicious red velvet with cream cheese frosting',
        imageUrl: 'https://example.com/red-velvet.jpg',
      );

      // Assert
      expect(cake.title, 'Red Velvet Cake');
      expect(
        cake.description,
        'Delicious red velvet with cream cheese frosting',
      );
      expect(cake.imageUrl, 'https://example.com/red-velvet.jpg');
    });

    test('toString should return formatted string', () {
      // Arrange
      const cake = Cake(
        title: 'Test Cake',
        description: 'Test Description',
        imageUrl: 'https://example.com/test.jpg',
      );

      // Act
      final result = cake.toString();

      // Assert
      expect(
        result,
        'Cake(title: Test Cake, description: Test Description, imageUrl: https://example.com/test.jpg)',
      );
    });
  });

  group('CakeLocalDataSource Tests', () {
    late CakeLocalDataSource dataSource;

    setUp(() {
      dataSource = CakeLocalDataSource();
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should return empty list when no cached data exists', () async {
      // Act
      final result = await dataSource.getCachedCakes();

      // Assert
      expect(result, isEmpty);
    });

    test('should cache and retrieve cakes successfully', () async {
      // Arrange
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

      // Act
      await dataSource.cacheCakes(testCakes);
      final result = await dataSource.getCachedCakes();

      // Assert
      expect(result, hasLength(2));
      expect(result[0].title, 'Test Cake 1');
      expect(result[0].description, 'Test Description 1');
      expect(result[0].image, 'https://example.com/test1.jpg');
      expect(result[1].title, 'Test Cake 2');
      expect(result[1].description, 'Test Description 2');
      expect(result[1].image, 'https://example.com/test2.jpg');
    });

    test('should return true when cached data exists', () async {
      // Arrange
      const testCakes = [
        CakeModel(
          title: 'Test Cake',
          description: 'Test Description',
          image: 'https://example.com/test.jpg',
        ),
      ];

      // Act
      await dataSource.cacheCakes(testCakes);
      final result = await dataSource.hasCachedData();

      // Assert
      expect(result, isTrue);
    });

    test('should return false when no cached data exists', () async {
      // Act
      final result = await dataSource.hasCachedData();

      // Assert
      expect(result, isFalse);
    });

    test('should clear cached data successfully', () async {
      // Arrange
      const testCakes = [
        CakeModel(
          title: 'Test Cake',
          description: 'Test Description',
          image: 'https://example.com/test.jpg',
        ),
      ];
      await dataSource.cacheCakes(testCakes);

      // Act
      await dataSource.clearCache();
      final hasData = await dataSource.hasCachedData();
      final cachedCakes = await dataSource.getCachedCakes();

      // Assert
      expect(hasData, isFalse);
      expect(cachedCakes, isEmpty);
    });

    test('should handle empty cake list', () async {
      // Arrange
      const List<CakeModel> emptyCakes = [];

      // Act
      await dataSource.cacheCakes(emptyCakes);
      final result = await dataSource.getCachedCakes();

      // Assert
      expect(result, isEmpty);
    });

    test('should handle cakes with null values', () async {
      // Arrange
      const testCakes = [
        CakeModel(title: null, description: null, image: null),
      ];

      // Act
      await dataSource.cacheCakes(testCakes);
      final result = await dataSource.getCachedCakes();

      // Assert
      expect(result, hasLength(1));
      expect(result[0].title, '');
      expect(result[0].description, '');
      expect(result[0].image, '');
    });
  });

  group('Failure Tests', () {
    test('should create Failure with message', () {
      // Arrange
      const message = 'Network error occurred';

      // Act
      const failure = Failure(message);

      // Assert
      expect(failure.message, message);
      expect(failure.toString(), 'Failure: Network error occurred');
    });

    test('should handle empty failure message', () {
      // Arrange
      const message = '';

      // Act
      const failure = Failure(message);

      // Assert
      expect(failure.message, '');
      expect(failure.toString(), 'Failure: ');
    });

    test('should be properly identified as Failure type', () {
      // Arrange
      const failure = Failure('Test error');

      // Act & Assert
      expect(failure, isA<Failure>());
    });
  });

  group('CakeLocalDataSource Integration Tests', () {
    late CakeLocalDataSource dataSource;

    setUp(() {
      dataSource = CakeLocalDataSource();
      // Clear shared preferences before each test
      SharedPreferences.setMockInitialValues({});
    });

    test('should perform complete cache cycle correctly', () async {
      // Arrange
      const testCakes = [
        CakeModel(
          title: 'Integration Test Cake 1',
          description: 'Test Description 1',
          image: 'https://example.com/integration1.jpg',
        ),
        CakeModel(
          title: 'Integration Test Cake 2',
          description: 'Test Description 2',
          image: 'https://example.com/integration2.jpg',
        ),
      ];

      // Act & Assert - Initially no cache
      expect(await dataSource.hasCachedData(), isFalse);
      expect(await dataSource.getCachedCakes(), isEmpty);

      // Act & Assert - Cache data
      await dataSource.cacheCakes(testCakes);
      expect(await dataSource.hasCachedData(), isTrue);

      final cachedCakes = await dataSource.getCachedCakes();
      expect(cachedCakes, hasLength(2));
      expect(cachedCakes[0].title, 'Integration Test Cake 1');
      expect(cachedCakes[1].title, 'Integration Test Cake 2');

      // Act & Assert - Clear cache
      await dataSource.clearCache();
      expect(await dataSource.hasCachedData(), isFalse);
      expect(await dataSource.getCachedCakes(), isEmpty);
    });

    test('should handle concurrent cache operations', () async {
      // Arrange
      const testCakes1 = [
        CakeModel(
          title: 'Concurrent Cake 1',
          description: 'Description 1',
          image: 'https://example.com/concurrent1.jpg',
        ),
      ];

      const testCakes2 = [
        CakeModel(
          title: 'Concurrent Cake 2',
          description: 'Description 2',
          image: 'https://example.com/concurrent2.jpg',
        ),
      ];

      // Act - Cache multiple sets of data
      await Future.wait([
        dataSource.cacheCakes(testCakes1),
        dataSource.cacheCakes(testCakes2),
      ]);

      // Assert - Last write should win
      final cachedCakes = await dataSource.getCachedCakes();
      expect(cachedCakes, hasLength(1));
      // Either result is acceptable since concurrent writes are race conditions
      expect(
        ['Concurrent Cake 1', 'Concurrent Cake 2'],
        contains(cachedCakes[0].title),
      );
    });

    test('should persist data across multiple instance creations', () async {
      // Arrange
      const testCakes = [
        CakeModel(
          title: 'Persistent Cake',
          description: 'Should persist',
          image: 'https://example.com/persistent.jpg',
        ),
      ];

      // Act - Cache with first instance
      await dataSource.cacheCakes(testCakes);

      // Create new instance and verify data persists
      final newDataSource = CakeLocalDataSource();
      final cachedCakes = await newDataSource.getCachedCakes();

      // Assert
      expect(cachedCakes, hasLength(1));
      expect(cachedCakes[0].title, 'Persistent Cake');
    });

    test('should handle large amounts of data', () async {
      // Arrange - Generate a large list of cakes
      final largeCakeList = List.generate(
        100,
        (index) => CakeModel(
          title: 'Cake Number $index',
          description: 'Description for cake $index',
          image: 'https://example.com/cake$index.jpg',
        ),
      );

      // Act
      await dataSource.cacheCakes(largeCakeList);
      final cachedCakes = await dataSource.getCachedCakes();

      // Assert
      expect(cachedCakes, hasLength(100));
      expect(cachedCakes[0].title, 'Cake Number 0');
      expect(cachedCakes[99].title, 'Cake Number 99');
    });

    test('should handle special characters in cake data', () async {
      // Arrange
      const specialCakes = [
        CakeModel(
          title: 'Café Crème & "Special" Cake 🍰',
          description: 'Contains émojis, "quotes", and spéciál characters',
          image: 'https://example.com/spëcial-cäke.jpg',
        ),
      ];

      // Act
      await dataSource.cacheCakes(specialCakes);
      final cachedCakes = await dataSource.getCachedCakes();

      // Assert
      expect(cachedCakes, hasLength(1));
      expect(cachedCakes[0].title, 'Café Crème & "Special" Cake 🍰');
      expect(
        cachedCakes[0].description,
        'Contains émojis, "quotes", and spéciál characters',
      );
    });
  });
}
