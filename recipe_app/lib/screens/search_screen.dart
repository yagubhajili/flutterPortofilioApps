import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/meal.dart';
import '../widgets/meal_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounceTimer;

  bool _isSearchByName = true; // Toggle between name and ingredient search
  bool _isLoading = false;
  List<Meal> _searchResults = [];
  bool _hasSearched = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  // Debouncing to avoid hitting API too frequently on every keystroke
  void _onSearchChanged(String query) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (query.trim().isNotEmpty) {
        _performSearch(query.trim());
      } else {
        setState(() {
          _searchResults = [];
          _hasSearched = false;
        });
      }
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
      _hasSearched = true;
    });

    try {
      List<Meal> results = [];
      if (_isSearchByName) {
        results = await _apiService.searchMealsByName(query);
      } else {
        // Search by ingredient
        results = await _apiService.filterByIngredient(query);
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Axtarış zamanı xəta baş verdi: $e')),
        );
      }
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _searchResults = [];
      _hasSearched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF120E0B),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Text(
                'Axtarış 🔍',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  color: Color(0xFFF7F4F2),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Search Toggle Buttons
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (!_isSearchByName) {
                          setState(() {
                            _isSearchByName = true;
                          });
                          if (_searchController.text.trim().isNotEmpty) {
                            _performSearch(_searchController.text.trim());
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: _isSearchByName ? const Color(0xFFFF7E21) : const Color(0xFF1F1915),
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            bottomLeft: Radius.circular(12),
                          ),
                          border: Border.all(
                            color: _isSearchByName ? const Color(0xFFFF7E21) : const Color(0xFF2C241E),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'Ad ilə axtar',
                          style: TextStyle(
                            color: _isSearchByName ? Colors.white : const Color(0xFFA09890),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        if (_isSearchByName) {
                          setState(() {
                            _isSearchByName = false;
                          });
                          if (_searchController.text.trim().isNotEmpty) {
                            _performSearch(_searchController.text.trim());
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: !_isSearchByName ? const Color(0xFFFF7E21) : const Color(0xFF1F1915),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          border: Border.all(
                            color: !_isSearchByName ? const Color(0xFFFF7E21) : const Color(0xFF2C241E),
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          'İnqrediyent ilə axtar',
                          style: TextStyle(
                            color: !_isSearchByName ? Colors.white : const Color(0xFFA09890),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Search Text Field
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                style: const TextStyle(color: Color(0xFFF7F4F2)),
                cursorColor: const Color(0xFFFF7E21),
                decoration: InputDecoration(
                  hintText: _isSearchByName
                      ? 'Yeməyin adını yazın... (məs. Biryani)'
                      : 'Tərkibində olan inqrediyenti yazın... (məs. chicken)',
                  hintStyle: const TextStyle(color: Color(0xFFA09890), fontSize: 13),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFFFF7E21)),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear, color: Color(0xFFA09890)),
                          onPressed: _clearSearch,
                        )
                      : null,
                  filled: true,
                  fillColor: const Color(0xFF1F1915),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFF2C241E)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xFFFF7E21)),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Results area
              Expanded(
                child: _isLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFF7E21)),
                        ),
                      )
                    : !_hasSearched
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _isSearchByName ? Icons.restaurant : Icons.eco,
                                  size: 60,
                                  color: const Color(0xFF1F1915),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  _isSearchByName
                                      ? 'Ləzzətli yeməklər tapmaq üçün axtarış edin'
                                      : 'İnqrediyent adına görə reseptləri süzün',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Color(0xFFA09890),
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : _searchResults.isEmpty
                            ? const Center(
                                child: Text(
                                  'Heç bir resept tapılmadı 😕\nBaşqa bir söz yazmağa çalışın.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Color(0xFFA09890),
                                    fontSize: 14,
                                  ),
                                ),
                              )
                            : GridView.builder(
                                physics: const BouncingScrollPhysics(),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.76,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 4,
                                ),
                                itemCount: _searchResults.length,
                                itemBuilder: (context, index) {
                                  return MealCard(meal: _searchResults[index]);
                                },
                              ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
