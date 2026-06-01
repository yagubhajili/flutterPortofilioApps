import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';
import '../widgets/category_pills.dart';
import '../widgets/area_selector.dart';
import 'meal_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback navigateToSearch;

  const HomeScreen({
    super.key,
    required this.navigateToSearch,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  List<MealCategory> _categories = [];
  List<String> _areas = [];
  List<Meal> _meals = [];

  String _selectedCategory = 'Hamısı';
  String _selectedArea = 'Hamısı';

  bool _isLoadingCategories = true;
  bool _isLoadingMeals = true;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isLoadingCategories = true;
    });

    try {
      final categoriesList = await _apiService.getCategories();
      final areasList = await _apiService.getAreas();

      setState(() {
        _categories = categoriesList;
        _areas = areasList;
        _isLoadingCategories = false;
      });

      // Load default meals
      _fetchFilteredMeals();
    } catch (e) {
      setState(() {
        _isLoadingCategories = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xəta baş verdi: $e')),
        );
      }
    }
  }

  Future<void> _fetchFilteredMeals() async {
    setState(() {
      _isLoadingMeals = true;
    });

    try {
      List<Meal> mealsList = [];
      if (_selectedCategory != 'Hamısı') {
        mealsList = await _apiService.filterByCategory(_selectedCategory);
      } else if (_selectedArea != 'Hamısı') {
        mealsList = await _apiService.filterByArea(_selectedArea);
      } else {
        // Default meals list: search by letter "s" to get plenty of meals
        mealsList = await _apiService.searchMealsByName('s');
      }

      setState(() {
        _meals = mealsList;
        _isLoadingMeals = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingMeals = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reseptləri yükləmək mümkün olmadı: $e')),
        );
      }
    }
  }

  void _handleCategorySelect(String category) {
    setState(() {
      _selectedCategory = category;
      _selectedArea = 'Hamısı'; // Reset area when category is selected
    });
    _fetchFilteredMeals();
  }

  void _handleAreaSelect(String area) {
    setState(() {
      _selectedArea = area;
      _selectedCategory = 'Hamısı'; // Reset category when area is selected
    });
    _fetchFilteredMeals();
  }

  // Opens detail screen of a random meal
  Future<void> _showRandomMeal() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
        ),
      ),
    );

    try {
      final meal = await _apiService.getRandomMeal();
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        if (meal != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MealDetailScreen(
                mealId: meal.idMeal,
                heroTag: 'meal-img-${meal.idMeal}',
              ),
            ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Təsadüfi resept tapılmadı.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Xəta baş verdi: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120E0B), // Deep coffee dark background
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // App Bar Header
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Salam, Xoş Gəldin! 👋',
                          style: TextStyle(
                            color: Color(0xFFA09890),
                            fontSize: 14,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Bu gün nə bişiririk?',
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            color: Color(0xFFF7F4F2),
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF1F1915),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF2C241E)),
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search, color: Color(0xFFFF7E21)),
                        onPressed: widget.navigateToSearch,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Search Bar Widget
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: widget.navigateToSearch,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1F1915),
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(color: const Color(0xFF2C241E)),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search, color: Color(0xFFA09890), size: 20),
                        SizedBox(width: 12),
                        Text(
                          'Resept və ya ingredient axtar...',
                          style: TextStyle(color: Color(0xFFA09890), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // "Bu gün nə bişirim?" Random Meal Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFF9E59), Color(0xFFFF7E21)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF7E21).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20),
                      onTap: _showRandomMeal,
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: const Icon(
                                Icons.casino,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Fikrin yoxdur?',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    'Şansımı yoxla 🎲',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'Bu gün nə bişirim? düyməsi ilə təsadüfi resept tap.',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // Categories Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Kateqoriyalar',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: const Color(0xFFF7F4F2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Categories list (Horizontal scroll)
            SliverToBoxAdapter(
              child: _isLoadingCategories
                  ? const SizedBox(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
                        ),
                      ),
                    )
                  : CategoryPills(
                      categories: _categories,
                      selectedCategory: _selectedCategory,
                      onSelectCategory: _handleCategorySelect,
                    ),
            ),

            // Areas/Cuisine Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'Mətbəx Ölkələri',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    color: const Color(0xFFF7F4F2),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Areas list (Horizontal scroll)
            SliverToBoxAdapter(
              child: _isLoadingCategories
                  ? const SizedBox(
                      height: 38,
                      child: Center(),
                    )
                  : AreaSelector(
                      areas: _areas,
                      selectedArea: _selectedArea,
                      onSelectArea: _handleAreaSelect,
                    ),
            ),

            // Recipes Section Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCategory != 'Hamısı'
                          ? '$_selectedCategory Reseptləri'
                          : _selectedArea != 'Hamısı'
                              ? '$_selectedArea Mətbəxi'
                              : 'Seçilmiş Reseptlər',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        color: Color(0xFFF7F4F2),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_meals.length} tapıldı',
                      style: const TextStyle(
                        color: Color(0xFFA09890),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Recipes Grid
            _isLoadingMeals
                ? const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 60),
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
                        ),
                      ),
                    ),
                  )
                : _meals.isEmpty
                    ? const SliverToBoxAdapter(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 60),
                          child: Center(
                            child: Text(
                              'Heç bir resept tapılmadı 😕',
                              style: TextStyle(
                                color: Color(0xFFA09890),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        sliver: SliverGrid(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.76,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 4,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return MealCard(meal: _meals[index]);
                            },
                            childCount: _meals.length,
                          ),
                        ),
                      ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
          ],
        ),
      ),
    );
  }
}
