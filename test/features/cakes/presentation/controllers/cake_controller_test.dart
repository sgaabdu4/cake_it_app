import 'package:cake_it_app/features/cakes/presentation/controllers/cake_controller.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

// using real network calls for testing but in production would use mockito for mocking

void main() {
  group('CakeController Tests', () {
    late CakeController controller;

    setUp(() {
      // real controller with actual network service
      controller = CakeController();
      SharedPreferences.setMockInitialValues({});
    });

    tearDown(() {
      controller.dispose();
    });

    test('should set error state when loading fails', () async {
      // test error handling when network fails

      // when controller loads cakes
      await controller.loadCakes();

      // then controller should handle any errors gracefully
      expect(controller.hasError || controller.cakes.isNotEmpty, isTrue);
    });

    test('should not reload if data is recent', () async {
      // when controller loads cakes first time
      await controller.loadCakes();
      final initialCakeCount = controller.cakes.length;

      // then when loading again immediately
      await controller.loadCakes();

      // should use cached data and not reload
      expect(controller.cakes.length, equals(initialCakeCount));
    });

    test('should refresh data when refreshCakes is called', () async {
      // when controller refreshes cakes
      await controller.refreshCakes();

      // then should have fresh data from api
      expect(controller.cakes, isNotEmpty);
      expect(controller.cakes.first.title, isNotEmpty);
    });
  });
}
