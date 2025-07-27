import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';
import 'package:cake_it_app/features/cakes/presentation/views/cake_details_view.dart';
import 'package:cake_it_app/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CakeDetailsView Widget Tests', () {
    testWidgets('should display error message when no cake provided', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: CakeDetailsView(),
        ),
      );

      // Assert
      expect(find.text('Cake Details'), findsOneWidget);
      expect(find.text('No cake data provided'), findsOneWidget);
    });

    testWidgets('should display cake details when cake provided through route', (WidgetTester tester) async {
      // Arrange
      const testCake = Cake(
        title: 'Test Cake',
        description: 'This is a test cake description',
        imageUrl: 'https://example.com/test.jpg',
      );

      // Create a custom route with the cake as arguments
      final route = MaterialPageRoute(
        settings: const RouteSettings(arguments: testCake),
        builder: (context) => const CakeDetailsView(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Builder(
              builder: (context) => Navigator(
                onGenerateRoute: (settings) => route,
                initialRoute: '/',
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Test Cake'), findsWidgets);
      expect(find.text('This is a test cake description'), findsOneWidget);
      expect(find.text('Description'), findsOneWidget);
    });

    testWidgets('should display content in a scrollable view with cake data', (WidgetTester tester) async {
      // Arrange
      const testCake = Cake(
        title: 'Scrollable Test Cake',
        description: 'This cake should be in a scrollable view',
        imageUrl: 'https://example.com/scrollable.jpg',
      );

      final route = MaterialPageRoute(
        settings: const RouteSettings(arguments: testCake),
        builder: (context) => const CakeDetailsView(),
      );

      // Act
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Navigator(
            onGenerateRoute: (settings) => route,
            initialRoute: '/',
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.text('Scrollable Test Cake'), findsWidgets);
    });
  });
}
