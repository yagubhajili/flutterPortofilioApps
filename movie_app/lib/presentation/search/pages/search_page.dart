import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/utils/debouncer.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../domain/entities/genre.dart';
import '../../widgets/genre_chip.dart';
import '../../widgets/movie_card.dart';
import '../cubit/search_cubit.dart';
import '../cubit/search_state.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _debouncer = Debouncer();
  late final TabController _tabController;

  Genre? _selectedGenre;
  bool _isTv = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(_onTabChanged);
    _scrollController.addListener(_onScroll);
    context.read<SearchCubit>().loadGenres();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) return;
    setState(() {
      _isTv = _tabController.index == 1;
      _selectedGenre = null;
    });
    context.read<SearchCubit>().setTvMode(_isTv);
    if (_controller.text.trim().isNotEmpty) {
      context.read<SearchCubit>().search(_controller.text.trim());
    } else {
      context.read<SearchCubit>().clear();
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 400) {
      context.read<SearchCubit>().loadMore();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _debouncer.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _goToDetail(BuildContext context, movie) {
    context.push('/detail/${movie.id}?isTv=${movie.mediaType == 'tv'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      appBar: AppBar(
        title: const Text('Axtarış'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Filmlər 🎬'),
            Tab(text: 'TV Seriallar 📺'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search field
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _controller,
              autofocus: false,
              onChanged: (q) {
                _debouncer.run(() {
                  setState(() => _selectedGenre = null);
                  context.read<SearchCubit>().search(q);
                });
              },
              decoration: InputDecoration(
                hintText: _isTv
                    ? 'Serial adını axtarın...'
                    : 'Film adını axtarın...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          context.read<SearchCubit>().clear();
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Genre chips
          BlocBuilder<SearchCubit, SearchState>(
            builder: (ctx, state) {
              final genres = state is SearchInitial ? state.genres : [];
              if (genres.isEmpty) return const SizedBox(height: 8);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 12),
                  GenreChipList(
                    genres: genres as List<Genre>,
                    selectedId: _selectedGenre?.id,
                    onSelect: (g) {
                      setState(() => _selectedGenre = g);
                      _controller.clear();
                      ctx.read<SearchCubit>().filterByGenre(g.id);
                    },
                  ),
                  const SizedBox(height: 8),
                ],
              );
            },
          ),

          // Results
          Expanded(
            child: BlocBuilder<SearchCubit, SearchState>(
              builder: (ctx, state) {
                if (state is SearchInitial && state.genres.isEmpty) {
                  return _buildEmpty();
                }
                if (state is SearchInitial) {
                  return _buildEmpty();
                }
                if (state is SearchLoading) {
                  return _buildGridShimmer();
                }
                if (state is SearchEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.search_off,
                            size: 64, color: Color(0xFF3A3A3A)),
                        const SizedBox(height: 12),
                        Text(
                          '"${state.query}" üçün nəticə tapılmadı',
                          style: const TextStyle(color: Color(0xFF9E9E9E)),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }
                if (state is SearchError) {
                  return AppErrorWidget(
                    message: state.message,
                    onRetry: () =>
                        ctx.read<SearchCubit>().search(_controller.text),
                  );
                }
                if (state is SearchLoaded) {
                  return _buildGrid(ctx, state);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, SearchLoaded state) {
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: state.results.length + (state.isLoadingMore ? 3 : 0),
      itemBuilder: (_, i) {
        if (i >= state.results.length) {
          return const ShimmerBox(
              width: double.infinity, height: double.infinity, borderRadius: 10);
        }
        final movie = state.results[i];
        return MovieGridCard(
          movie: movie,
          onTap: () => _goToDetail(context, movie),
        );
      },
    );
  }

  Widget _buildGridShimmer() {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.55,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: 12,
      itemBuilder: (_, _) => const ShimmerBox(
          width: double.infinity, height: double.infinity, borderRadius: 10),
    );
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Icon(Icons.local_movies_outlined, size: 72, color: Color(0xFF2A2A2A)),
          SizedBox(height: 16),
          Text(
            'Film və ya serial axtarın\nyaxud janra görə süzün',
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF9E9E9E), fontSize: 14),
          ),
        ],
      ),
    );
  }
}
