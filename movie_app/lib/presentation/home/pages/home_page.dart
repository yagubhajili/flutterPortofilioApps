import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../domain/entities/movie.dart';
import '../../widgets/horizontal_movie_list.dart';
import '../../widgets/section_header.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().load();
  }

  void _goToDetail(BuildContext context, Movie movie) {
    context.push('/detail/${movie.id}?isTv=${movie.mediaType == 'tv'}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading || state is HomeInitial) {
            return _buildShimmer();
          }
          if (state is HomeError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<HomeCubit>().load(),
            );
          }
          if (state is HomeLoaded) {
            return _buildLoaded(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildLoaded(BuildContext context, HomeLoaded state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── App Bar ──────────────────────────────────────────────────────
        SliverAppBar(
          floating: true,
          backgroundColor: const Color(0xFF0F0F0F),
          title: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: const Color(0xFFE50914),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Icon(Icons.movie, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              const Text(
                'CinéApp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          actions: [
            IconButton(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search, color: Colors.white),
            ),
            IconButton(
              onPressed: () => context.push('/watchlist'),
              icon: const Icon(Icons.bookmark_outline, color: Colors.white),
            ),
          ],
        ),

        // ── Featured Banner (top trending) ───────────────────────────────
        if (state.trending.isNotEmpty)
          SliverToBoxAdapter(
            child: _FeaturedBanner(
              movies: state.trending.take(5).toList(),
              onTap: (m) => _goToDetail(context, m),
            ),
          ),

        // ── Trending ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Trending Bu Həftə 🔥',
            onSeeAll: () => context.push('/list?type=trending'),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalMovieList(
            movies: state.trending,
            onMovieTap: (m) => _goToDetail(context, m),
          ),
        ),

        // ── Popular ──────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Populyar Filmlər',
            onSeeAll: () => context.push('/list?type=popular'),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalMovieList(
            movies: state.popular,
            onMovieTap: (m) => _goToDetail(context, m),
          ),
        ),

        // ── Top Rated ────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Ən Yüksək Reytinqli ⭐',
            onSeeAll: () => context.push('/list?type=top_rated'),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalMovieList(
            movies: state.topRated,
            onMovieTap: (m) => _goToDetail(context, m),
          ),
        ),

        // ── Upcoming ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: SectionHeader(
            title: 'Tezliklə Gələcək 🎬',
            onSeeAll: () => context.push('/list?type=upcoming'),
          ),
        ),
        SliverToBoxAdapter(
          child: HorizontalMovieList(
            movies: state.upcoming,
            onMovieTap: (m) => _goToDetail(context, m),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 32)),
      ],
    );
  }

  Widget _buildShimmer() {
    return CustomScrollView(
      slivers: [
        SliverAppBar(
          floating: true,
          backgroundColor: const Color(0xFF0F0F0F),
          title: const Text('CinéApp',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
        ),
        SliverToBoxAdapter(
          child: ShimmerBox(
            width: double.infinity,
            height: 240,
            borderRadius: 0,
          ),
        ),
        for (int i = 0; i < 3; i++) ...[
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              child: ShimmerBox(width: 160, height: 20, borderRadius: 4),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 200,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: 5,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, _) =>
                    const ShimmerBox(width: 130, height: 200, borderRadius: 12),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Featured Banner ────────────────────────────────────────────────────────

class _FeaturedBanner extends StatefulWidget {
  final List<Movie> movies;
  final void Function(Movie) onTap;

  const _FeaturedBanner({required this.movies, required this.onTap});

  @override
  State<_FeaturedBanner> createState() => _FeaturedBannerState();
}

class _FeaturedBannerState extends State<_FeaturedBanner> {
  final _controller = PageController();
  int _current = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 240,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.movies.length,
            onPageChanged: (i) => setState(() => _current = i),
            itemBuilder: (_, i) {
              final m = widget.movies[i];
              return GestureDetector(
                onTap: () => widget.onTap(m),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    AppImage(
                      path: m.backdropPath ?? m.posterPath,
                      baseUrl: ApiConstants.backdropW1280,
                      fit: BoxFit.cover,
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.85),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      right: 16,
                      bottom: 20,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            m.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded,
                                  color: Color(0xFFFFB800), size: 14),
                              const SizedBox(width: 4),
                              Text(
                                m.ratingFormatted,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                              if (m.year.isNotEmpty) ...[
                                const SizedBox(width: 12),
                                const Icon(Icons.calendar_today_outlined,
                                    color: Colors.white54, size: 12),
                                const SizedBox(width: 4),
                                Text(m.year,
                                    style: const TextStyle(
                                        color: Colors.white70, fontSize: 13)),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        // Dots
        Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.movies.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: _current == i ? 20 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: _current == i
                      ? const Color(0xFFE50914)
                      : const Color(0xFF555555),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}
