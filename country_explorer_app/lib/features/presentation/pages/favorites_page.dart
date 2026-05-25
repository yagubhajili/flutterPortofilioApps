import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_colors.dart';
import '../bloc/favorites/favorites_cubit.dart';
import '../bloc/favorites/favorites_state.dart';
import '../widgets/country_card.dart';
import 'detail_page.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                children: [
                  const Icon(Icons.favorite,
                      color: AppColors.primary, size: 22),
                  const SizedBox(width: 8),
                  Text(
                    'Sevimlilər',
                    style: TextStyle(
                      color: colors.textPrimary,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  if (state is FavoritesLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is FavoritesError) {
                    return Center(
                      child: Text(state.message,
                          style: TextStyle(color: colors.textSecondary)),
                    );
                  }
                  if (state is FavoritesLoaded) {
                    if (state.countries.isEmpty) {
                      return const _EmptyFavorites();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      itemCount: state.countries.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final country = state.countries[i];
                        return CountryCard(
                          country: country,
                          onTap: () {
                            final cubit = context.read<FavoritesCubit>();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    DetailPage(cca3: country.cca3),
                              ),
                            ).then((_) => cubit.load());
                          },
                          onFavoriteTap: () => context
                              .read<FavoritesCubit>()
                              .toggleFavorite(country.cca3),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyFavorites extends StatelessWidget {
  const _EmptyFavorites();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite_border, color: colors.textMuted, size: 56),
          const SizedBox(height: 16),
          Text(
            'Hələ sevimli ölkəniz yoxdur.',
            style: TextStyle(
                color: colors.textSecondary,
                fontSize: 15,
                fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Text(
            'Ölkə kartında ♥ düyməsinə toxunun.',
            style: TextStyle(color: colors.textMuted, fontSize: 13),
          ),
        ],
      ),
    );
  }
}
