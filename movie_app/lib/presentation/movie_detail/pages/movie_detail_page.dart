import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../../domain/entities/movie.dart';
import '../../../domain/entities/movie_detail.dart';
import '../../watchlist/cubit/watchlist_cubit.dart';
import '../../watchlist/cubit/watchlist_state.dart';
import '../../widgets/cast_card.dart';
import '../../widgets/horizontal_movie_list.dart';
import '../../widgets/section_header.dart';
import '../cubit/detail_cubit.dart';
import '../cubit/detail_state.dart';

class MovieDetailPage extends StatefulWidget {
  final int id;
  final bool isTv;

  const MovieDetailPage({super.key, required this.id, this.isTv = false});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  YoutubePlayerController? _ytController;

  @override
  void initState() {
    super.initState();
    context.read<DetailCubit>().load(widget.id, isTv: widget.isTv);
    context.read<WatchlistCubit>().load();
  }

  @override
  void dispose() {
    _ytController?.dispose();
    super.dispose();
  }

  void _initYoutube(String key) {
    _ytController ??= YoutubePlayerController(
      initialVideoId: key,
      flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: BlocBuilder<DetailCubit, DetailState>(
        builder: (ctx, state) {
              if (state is DetailLoading || state is DetailInitial) {
                return _buildShimmer();
              }
              if (state is DetailError) {
                return AppErrorWidget(
                  message: state.message,
                  onRetry: () =>
                      ctx.read<DetailCubit>().load(widget.id, isTv: widget.isTv),
                );
              }
              if (state is DetailLoaded) return _buildLoaded(ctx, state);
              return const SizedBox.shrink();
            },
          ),
        );
  }

  Widget _buildLoaded(BuildContext context, DetailLoaded state) {
    final detail = state.detail;
    final trailer = state.trailer;

    if (trailer != null) _initYoutube(trailer.key);

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Backdrop SliverAppBar ────────────────────────────────────────
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: const Color(0xFF0F0F0F),
          leading: Padding(
            padding: const EdgeInsets.all(8),
            child: CircleAvatar(
              backgroundColor: Colors.black54,
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                onPressed: () => context.pop(),
              ),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share_outlined, color: Colors.white),
              onPressed: () => Share.share(
                '${detail.title} filmini CinéApp ilə kəşf edin!\n${detail.tmdbUrl}',
              ),
            ),
            const SizedBox(width: 8),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                AppImage(
                  path: detail.backdropPath ?? detail.posterPath,
                  baseUrl: ApiConstants.backdropW1280,
                  fit: BoxFit.cover,
                ),
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withValues(alpha: 0.3),
                        Colors.black.withValues(alpha: 0.9),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // ── Content ─────────────────────────────────────────────────────
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  detail.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    height: 1.2,
                  ),
                ),
                if (detail.tagline != null && detail.tagline!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '"${detail.tagline}"',
                    style: const TextStyle(
                      color: Color(0xFF9E9E9E),
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 12),

                // Meta chips
                Wrap(
                  spacing: 8,
                  runSpacing: 6,
                  children: [
                    _MetaChip(
                      icon: Icons.star_rounded,
                      label: detail.ratingFormatted,
                      iconColor: const Color(0xFFFFB800),
                    ),
                    if (detail.year.isNotEmpty)
                      _MetaChip(icon: Icons.calendar_today_outlined, label: detail.year),
                    if (detail.runtimeFormatted.isNotEmpty)
                      _MetaChip(icon: Icons.schedule_outlined, label: detail.runtimeFormatted),
                    if (detail.status != null)
                      _MetaChip(icon: Icons.info_outline, label: detail.status!),
                  ],
                ),
                const SizedBox(height: 12),

                // Genres
                if (detail.genres.isNotEmpty)
                  Wrap(
                    spacing: 6,
                    children: detail.genres
                        .map((g) => Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE50914).withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFE50914).withValues(alpha: 0.4)),
                              ),
                              child: Text(
                                g.name,
                                style: const TextStyle(
                                  color: Color(0xFFE50914),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                const SizedBox(height: 16),

                // Watchlist / Favorite buttons
                BlocBuilder<WatchlistCubit, WatchlistState>(
                  builder: (ctx, wState) {
                    final movie = _detailToMovie(detail);
                    final isFav = wState.isFavorite(detail.id);
                    final isWatch = wState.isInWatchlist(detail.id);
                    return Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: isFav ? Icons.favorite : Icons.favorite_border,
                            label: isFav ? 'Sevimlilər' : 'Sevimlilərə əlavə et',
                            color: const Color(0xFFE50914),
                            isActive: isFav,
                            onTap: () =>
                                ctx.read<WatchlistCubit>().onToggleFavorite(movie),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _ActionButton(
                            icon: isWatch
                                ? Icons.bookmark
                                : Icons.bookmark_border,
                            label: isWatch ? 'İzləmə siyahısı' : 'Siyahıya əlavə et',
                            color: const Color(0xFF564AF7),
                            isActive: isWatch,
                            onTap: () =>
                                ctx.read<WatchlistCubit>().onToggleWatchlist(movie),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Overview
                const Text(
                  'Haqqında',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _ExpandableText(text: detail.overview),
              ],
            ),
          ),
        ),

        // ── Trailer ─────────────────────────────────────────────────────
        if (_ytController != null) ...[
          const SliverToBoxAdapter(
            child: SectionHeader(title: 'Treyler 🎥'),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: YoutubePlayer(
                  controller: _ytController!,
                  showVideoProgressIndicator: true,
                  progressIndicatorColor: const Color(0xFFE50914),
                ),
              ),
            ),
          ),
        ],

        // ── Cast ────────────────────────────────────────────────────────
        if (state.cast.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SectionHeader(title: 'Aktyorlar 🎭')),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 120,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: state.cast.length,
                separatorBuilder: (_, _) => const SizedBox(width: 12),
                itemBuilder: (_, i) => CastCard(
                  member: state.cast[i],
                  onTap: () =>
                      context.push('/person/${state.cast[i].id}'),
                ),
              ),
            ),
          ),
        ],

        // ── Similar ─────────────────────────────────────────────────────
        if (state.similar.isNotEmpty) ...[
          const SliverToBoxAdapter(child: SectionHeader(title: 'Oxşar Filmlər')),
          SliverToBoxAdapter(
            child: HorizontalMovieList(
              movies: state.similar,
              onMovieTap: (m) => context.push(
                  '/detail/${m.id}?isTv=${m.mediaType == 'tv'}'),
            ),
          ),
        ],

        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Movie _detailToMovie(MovieDetail d) => Movie(
        id: d.id,
        title: d.title,
        posterPath: d.posterPath,
        backdropPath: d.backdropPath,
        voteAverage: d.voteAverage,
        overview: d.overview,
        releaseDate: d.releaseDate,
        mediaType: d.mediaType,
      );

  Widget _buildShimmer() => CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 280,
          pinned: true,
          backgroundColor: const Color(0xFF0F0F0F),
          leading: const BackButton(color: Colors.white),
          flexibleSpace: const FlexibleSpaceBar(
            background: ShimmerBox(
              width: double.infinity,
              height: 280,
              borderRadius: 0,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              const ShimmerBox(width: 250, height: 28, borderRadius: 4),
              const SizedBox(height: 12),
              const ShimmerBox(width: double.infinity, height: 14, borderRadius: 4),
              const SizedBox(height: 6),
              const ShimmerBox(width: 200, height: 14, borderRadius: 4),
            ]),
          ),
        ),
      ]);
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;

  const _MetaChip({required this.icon, required this.label, this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFF252525),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: iconColor ?? const Color(0xFF9E9E9E), size: 13),
          const SizedBox(width: 4),
          Text(label,
              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 12)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isActive;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        decoration: BoxDecoration(
          color: isActive ? color.withValues(alpha: 0.2) : const Color(0xFF252525),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isActive ? color : const Color(0xFF3A3A3A),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? color : const Color(0xFF9E9E9E), size: 18),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isActive ? color : const Color(0xFF9E9E9E),
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableText extends StatefulWidget {
  final String text;
  const _ExpandableText({required this.text});

  @override
  State<_ExpandableText> createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<_ExpandableText> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedCrossFade(
          duration: const Duration(milliseconds: 250),
          crossFadeState:
              _expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          firstChild: Text(
            widget.text,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFFCCCCCC), height: 1.6),
          ),
          secondChild: Text(
            widget.text,
            style: const TextStyle(color: Color(0xFFCCCCCC), height: 1.6),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Azalt' : 'Daha çox',
            style: const TextStyle(
              color: Color(0xFFE50914),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
