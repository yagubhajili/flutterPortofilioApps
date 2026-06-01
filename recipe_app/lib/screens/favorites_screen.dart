import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/favorites_provider.dart';
import '../providers/shopping_provider.dart';
import '../widgets/meal_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _measureController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _measureController.dispose();
    super.dispose();
  }

  void _addCustomShoppingItem(ShoppingProvider shoppingProvider) {
    final name = _nameController.text.trim();
    final measure = _measureController.text.trim();

    if (name.isNotEmpty) {
      shoppingProvider.addCustomItem(name, measure);
      _nameController.clear();
      _measureController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFF120E0B),
        appBar: AppBar(
          backgroundColor: const Color(0xFF120E0B),
          elevation: 0,
          title: const Text(
            'Mənim Mətbəxim 🍳',
            style: TextStyle(
              fontFamily: 'Outfit',
              color: Color(0xFFF7F4F2),
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: const TabBar(
            indicatorColor: Color(0xFFFF7E21),
            labelColor: Color(0xFFFF7E21),
            unselectedLabelColor: Color(0xFFA09890),
            tabs: [
              Tab(
                icon: Icon(Icons.favorite),
                text: 'Sevimli Reseptlər',
              ),
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: 'Alış-veriş Siyahısı',
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: [
              // Tab 1: Favorites Grid
              _buildFavoritesTab(),

              // Tab 2: Shopping List Manager
              _buildShoppingListTab(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFavoritesTab() {
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, child) {
        final favorites = favProvider.favorites;

        if (favorites.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.favorite_border, size: 60, color: Color(0xFF1F1915)),
                SizedBox(height: 16),
                Text(
                  'Hələ heç bir sevimli reseptiniz yoxdur.\nYeməkləri bəyənərək buraya əlavə edin! ❤️',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFFA09890),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(12),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.76,
              crossAxisSpacing: 10,
              mainAxisSpacing: 4,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              return MealCard(meal: favorites[index]);
            },
          ),
        );
      },
    );
  }

  Widget _buildShoppingListTab() {
    return Consumer<ShoppingProvider>(
      builder: (context, shoppingProvider, child) {
        final list = shoppingProvider.shoppingList;

        return Column(
          children: [
            // Custom item creator card
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1F1915),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF2C241E)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text(
                    'Siyahıya ərzaq əlavə et 🛒',
                    style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextField(
                          controller: _nameController,
                          cursorColor: const Color(0xFFFF7E21),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Ərzaq adı (məs. Süd)',
                            hintStyle: const TextStyle(color: Color(0xFFA09890), fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF120E0B),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF2C241E)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFFF7E21)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: TextField(
                          controller: _measureController,
                          cursorColor: const Color(0xFFFF7E21),
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                          decoration: InputDecoration(
                            hintText: 'Miqdar (məs. 1 litr)',
                            hintStyle: const TextStyle(color: Color(0xFFA09890), fontSize: 12),
                            filled: true,
                            fillColor: const Color(0xFF120E0B),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFF2C241E)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(color: Color(0xFFFF7E21)),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF7E21),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.add, color: Colors.white),
                          onPressed: () => _addCustomShoppingItem(shoppingProvider),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Header info & clear buttons
            if (list.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Cəmi: ${list.length} məhsul',
                      style: const TextStyle(color: Color(0xFFA09890), fontSize: 12),
                    ),
                    Row(
                      children: [
                        TextButton(
                          onPressed: shoppingProvider.clearCompleted,
                          style: TextButton.styleFrom(foregroundColor: const Color(0xFFA09890)),
                          child: const Text('Alınanları təmizlə', style: TextStyle(fontSize: 12)),
                        ),
                        TextButton(
                          onPressed: shoppingProvider.clearAll,
                          style: TextButton.styleFrom(foregroundColor: const Color(0xFFE53E3E)),
                          child: const Text('Hamısını sil', style: TextStyle(fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

            // List of items
            Expanded(
              child: list.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          Icon(Icons.shopping_basket, size: 60, color: Color(0xFF1F1915)),
                          SizedBox(height: 16),
                          Text(
                            'Alış-veriş siyahınız boşdur.\nReseptlərdən ərzaqları bura əlavə edə bilərsiniz!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(0xFFA09890),
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        final item = list[index];
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1F1915),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: item.isChecked ? Colors.transparent : const Color(0xFF2C241E),
                            ),
                          ),
                          child: ListTile(
                            leading: Checkbox(
                              activeColor: const Color(0xFFFF7E21),
                              checkColor: Colors.white,
                              side: const BorderSide(color: Color(0xFFA09890), width: 1.5),
                              value: item.isChecked,
                              onChanged: (val) {
                                shoppingProvider.toggleItemChecked(item.id);
                              },
                            ),
                            title: Text(
                              item.name,
                              style: TextStyle(
                                color: item.isChecked ? const Color(0xFFA09890) : Colors.white,
                                fontWeight: FontWeight.w500,
                                decoration: item.isChecked ? TextDecoration.lineThrough : null,
                              ),
                            ),
                            subtitle: item.measure.isNotEmpty
                                ? Text(
                                    item.measure,
                                    style: TextStyle(
                                      color: item.isChecked ? const Color(0xFF2C241E) : const Color(0xFFFF7E21),
                                      fontSize: 12,
                                    ),
                                  )
                                : null,
                            trailing: IconButton(
                              icon: const Icon(Icons.delete_outline, color: Color(0xFFE53E3E), size: 20),
                              onPressed: () {
                                shoppingProvider.removeItem(item.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      },
    );
  }
}
