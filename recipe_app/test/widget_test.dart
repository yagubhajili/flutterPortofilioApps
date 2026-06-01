import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:recipe_app/main.dart';
import 'package:recipe_app/providers/favorites_provider.dart';
import 'package:recipe_app/providers/shopping_provider.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => FavoritesProvider()),
          ChangeNotifierProvider(create: (_) => ShoppingProvider()),
        ],
        child: const RecipeApp(),
      ),
    );

    expect(find.byType(RecipeApp), findsOneWidget);
  });
}
