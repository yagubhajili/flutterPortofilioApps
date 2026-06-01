import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/movie.dart';
import '../../widgets/movie_card.dart';
import '../cubit/watchlist_cubit.dart';
import '../cubit/watchlist_state.dart';

class WatchlistPage extends StatefulWidget {
  const WatchlistPage({super.key});

  @override
  State<WatchlistPage> createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    context.read<WatchlistCubit>().load();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Mənim Siyahım'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.favorite), text: 'Sevimlilər'),
            Tab(icon: Icon(Icons.bookmark), text: 'İzləmə Siyahısı'),
          ],
        ),
      ),
      body: BlocBuilder<WatchlistCubit, WatchlistState>(
        builder: (ctx, state) {
          return TabBarView(
            controller: _tabController,
            children: [
              _MovieGrid(
                movies: state.favorites,
                emptyMessage:
                    'Hələ sevilmiliniz yoxdur.\nFilm detalında ❤️ düyməsinə basın.',
                onTap: (m) => ctx.push('/detail/${m.id}?isTv=${m.mediaType == 'tv'}'),
                onLongPress: (m) => ctx.read<WatchlistCubit>().onToggleFavorite(m),
              ),
              _MovieGrid(
                movies: state.watchlist,
                emptyMessage:
                    'İzləmə siyahınız boşdur.\nFilm detalında 🔖 düyməsinə basın.',
                onTap: (m) => ctx.push('/detail/${m.id}?isTv=${m.mediaType == 'tv'}'),
                onLongPress: (m) => ctx.read<WatchlistCubit>().onToggleWatchlist(m),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  final List<Movie> movies;
  final String emptyMessage;
  final void Function(Movie) onTap;
  final void Function(Movie) onLongPress;

  const _MovieGrid({
    required this.movies,
    required this.emptyMessage,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.movie_filter_outlined,
                  size: 72, color: Color(0xFF2A2A2A)),
              const SizedBox(height: 16),
              Text(
                emptyMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Color(0xFF9E9E9E), fontSize: 14, height: 1.6),
              ),
            ],
          ),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: movies.length,
      itemBuilder: (_, i) {
        final m = movies[i];
        return GestureDetector(
          onLongPress: () {
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                backgroundColor: const Color(0xFF1A1A1A),
                title: Text(m.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
                content: const Text(
                  'Bu filmi siyahıdan silmək istəyirsiniz?',
                  style: TextStyle(color: Color(0xFF9E9E9E)),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Xeyr'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      onLongPress(m);
                    },
                    child: const Text('Sil',
                        style: TextStyle(color: Color(0xFFE50914))),
                  ),
                ],
              ),
            );
          },
          child: MovieGridCard(
            movie: m,
            onTap: () => onTap(m),
          ),
        );
      },
    );
  }
}
