import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../providers/favorites_provider.dart';
import '../providers/shopping_provider.dart';
import 'cooking_mode_screen.dart';

class MealDetailScreen extends StatefulWidget {
  final String mealId;
  final String heroTag;

  const MealDetailScreen({
    super.key,
    required this.mealId,
    required this.heroTag,
  });

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  final ApiService _apiService = ApiService();
  Meal? _meal;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadMealDetails();
  }

  Future<void> _loadMealDetails() async {
    try {
      final mealDetails = await _apiService.getMealDetails(widget.mealId);
      setState(() {
        _meal = mealDetails;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // Action: Launch YouTube URL
  Future<void> _launchYoutube(String url) async {
    final uri = Uri.parse(url);
    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('YouTube açılmadı: $e')),
        );
      }
    }
  }

  // Action: Share Recipe
  void _shareRecipe() {
    if (_meal == null) return;

    final String ingredientsText = _meal!.ingredients
        .map((ing) => '• ${ing.ingredient} - ${ing.measure}')
        .join('\n');

    final String textToShare = '''
🍴 ${_meal!.strMeal} 🍴
Kateqoriya: ${_meal!.strCategory ?? ''}
Ölkə: ${_meal!.strArea ?? ''}

İnqrediyentlər:
$ingredientsText

Hazırlanma Təlimatı:
${_meal!.strInstructions ?? ''}

${_meal!.strYoutube != null && _meal!.strYoutube!.isNotEmpty ? '\nVideo izləyin: ${_meal!.strYoutube}' : ''}

Yemək Resept Appindən paylaşıldı 📱
''';

    Share.share(textToShare, subject: '${_meal!.strMeal} Resepti');
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoritesProvider>(context);
    final isFav = _meal != null && favProvider.isFavorite(_meal!.idMeal);

    return Scaffold(
      backgroundColor: const Color(0xFF120E0B),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
              ),
            )
          : _errorMessage != null
              ? Center(
                  child: Text(
                    'Xəta baş verdi: $_errorMessage',
                    style: const TextStyle(color: Colors.red),
                  ),
                )
              : _meal == null
                  ? const Center(
                      child: Text(
                        'Resept tapılmadı.',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  : CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        // Glassy Collapsible Header / Hero Image
                        SliverAppBar(
                          expandedHeight: 320,
                          pinned: true,
                          stretch: true,
                          backgroundColor: const Color(0xFF120E0B),
                          elevation: 0,
                          leading: Padding(
                            padding: const EdgeInsets.only(left: 12),
                            child: CircleAvatar(
                              backgroundColor: const Color(0xFF120E0B).withOpacity(0.6),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back, color: Colors.white),
                                onPressed: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          actions: [
                            CircleAvatar(
                              backgroundColor: const Color(0xFF120E0B).withOpacity(0.6),
                              child: IconButton(
                                icon: const Icon(Icons.share, color: Colors.white),
                                onPressed: _shareRecipe,
                              ),
                            ),
                            const SizedBox(width: 8),
                            CircleAvatar(
                              backgroundColor: const Color(0xFF120E0B).withOpacity(0.6),
                              child: IconButton(
                                icon: Icon(
                                  isFav ? Icons.favorite : Icons.favorite_border,
                                  color: isFav ? const Color(0xFFE53E3E) : Colors.white,
                                ),
                                onPressed: () => favProvider.toggleFavorite(_meal!),
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          flexibleSpace: FlexibleSpaceBar(
                            background: Stack(
                              fit: StackFit.expand,
                              children: [
                                Hero(
                                  tag: widget.heroTag,
                                  child: CachedNetworkImage(
                                    imageUrl: _meal!.strMealThumb ?? '',
                                    fit: BoxFit.cover,
                                    errorWidget: (context, url, error) => const Center(
                                      child: Icon(Icons.restaurant, color: Color(0xFFFF7E21), size: 100),
                                    ),
                                  ),
                                ),
                                // Gradient shading
                                Positioned.fill(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.black.withOpacity(0.4),
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            stretchModes: const [
                              StretchMode.zoomBackground,
                              StretchMode.blurBackground,
                            ],
                          ),
                        ),

                        // Detail Contents
                        SliverList(
                          delegate: SliverChildListDelegate([
                            Padding(
                              padding: const EdgeInsets.all(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Meal Title
                                  Text(
                                    _meal!.strMeal,
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF7F4F2),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Category & Area Pills
                                  Row(
                                    children: [
                                      if (_meal!.strCategory != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1F1915),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: const Color(0xFF2C241E)),
                                          ),
                                          child: Text(
                                            _meal!.strCategory!,
                                            style: const TextStyle(
                                              color: Color(0xFFFF7E21),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                      ],
                                      if (_meal!.strArea != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF1F1915),
                                            borderRadius: BorderRadius.circular(20),
                                            border: Border.all(color: const Color(0xFF2C241E)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(Icons.public, color: Color(0xFFA09890), size: 12),
                                              const SizedBox(width: 4),
                                              Text(
                                                _meal!.strArea!,
                                                style: const TextStyle(
                                                  color: Color(0xFFA09890),
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 24),

                                  // YouTube Video Button (if present)
                                  if (_meal!.strYoutube != null && _meal!.strYoutube!.isNotEmpty) ...[
                                    ElevatedButton.icon(
                                      onPressed: () => _launchYoutube(_meal!.strYoutube!),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFE53E3E), // Red YouTube button
                                        foregroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        minimumSize: const Size.fromHeight(50),
                                        elevation: 2,
                                      ),
                                      icon: const Icon(Icons.play_circle_fill),
                                      label: const Text(
                                        'Hazırlanma Videosunu İzlə (YouTube) 📺',
                                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                  ],

                                  // Ingredients list Header
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        'Tərkibi / İnqrediyentlər',
                                        style: TextStyle(
                                          fontFamily: 'Outfit',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFFF7F4F2),
                                        ),
                                      ),
                                      // Add to Shopping List Button
                                      Consumer<ShoppingProvider>(
                                        builder: (context, shopProvider, child) {
                                          return TextButton.icon(
                                            onPressed: () {
                                              shopProvider.addMealIngredients(_meal!);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  content: Text('Bütün inqrediyentlər alış-veriş siyahısına əlavə olundu! 🛒'),
                                                  duration: Duration(seconds: 2),
                                                ),
                                              );
                                            },
                                            style: TextButton.styleFrom(
                                              foregroundColor: const Color(0xFFFF7E21),
                                            ),
                                            icon: const Icon(Icons.add_shopping_cart, size: 18),
                                            label: const Text(
                                              'Siyahıya əlavə et',
                                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),

                                  // Ingredients items cards
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F1915),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFF2C241E)),
                                    ),
                                    child: ListView.separated(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      itemCount: _meal!.ingredients.length,
                                      separatorBuilder: (context, index) => const Divider(
                                        color: Color(0xFF2C241E),
                                        height: 1,
                                        indent: 16,
                                        endIndent: 16,
                                      ),
                                      itemBuilder: (context, index) {
                                        final ing = _meal!.ingredients[index];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 8,
                                                height: 8,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFFFF7E21),
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  ing.ingredient,
                                                  style: const TextStyle(
                                                    color: Color(0xFFF7F4F2),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                              Text(
                                                ing.measure,
                                                style: const TextStyle(
                                                  color: Color(0xFFA09890),
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 24),

                                  // Instructions Header
                                  const Text(
                                    'Hazırlanma Təlimatı',
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFF7F4F2),
                                    ),
                                  ),
                                  const SizedBox(height: 12),

                                  // Instructions Text Card
                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1F1915),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(color: const Color(0xFF2C241E)),
                                    ),
                                    child: Text(
                                      _meal!.strInstructions ?? 'Təlimat yoxdur.',
                                      style: const TextStyle(
                                        color: Color(0xFFF7F4F2),
                                        fontSize: 14,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 100), // Space for bottom button
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
      // Sticky Bottom "Cooking Mode" Button
      bottomSheet: _meal != null
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              color: const Color(0xFF120E0B),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CookingModeScreen(meal: _meal!),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF7E21),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  minimumSize: const Size.fromHeight(55),
                  elevation: 5,
                ),
                child: const Text(
                  'Bişirməyə Başla 🍳 (Cooking Mode)',
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          : null,
    );
  }
}
