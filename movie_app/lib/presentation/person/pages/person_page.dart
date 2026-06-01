import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/widgets/app_error_widget.dart';
import '../../../core/widgets/app_image.dart';
import '../../../core/widgets/shimmer_box.dart';
import '../../widgets/horizontal_movie_list.dart';
import '../cubit/person_cubit.dart';
import '../cubit/person_state.dart';

class PersonPage extends StatefulWidget {
  final int id;
  const PersonPage({super.key, required this.id});

  @override
  State<PersonPage> createState() => _PersonPageState();
}

class _PersonPageState extends State<PersonPage> {
  @override
  void initState() {
    super.initState();
    context.read<PersonCubit>().load(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F0F0F),
      body: BlocBuilder<PersonCubit, PersonState>(
        builder: (ctx, state) {
          if (state is PersonLoading || state is PersonInitial) {
            return _buildShimmer();
          }
          if (state is PersonError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => ctx.read<PersonCubit>().load(widget.id),
            );
          }
          if (state is PersonLoaded) {
            final p = state.person;
            return CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  pinned: true,
                  backgroundColor: const Color(0xFF0F0F0F),
                  title: Text(p.name),
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => ctx.pop(),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: AppImage(
                            path: p.profilePath,
                            baseUrl: ApiConstants.profileW185,
                            width: 110,
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                p.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              if (p.knownForDepartment.isNotEmpty)
                                _InfoRow(
                                  icon: Icons.work_outline,
                                  value: p.knownForDepartment,
                                ),
                              if (p.birthday != null)
                                _InfoRow(
                                  icon: Icons.cake_outlined,
                                  value: '${p.birthday}  ${p.age}',
                                ),
                              if (p.placeOfBirth != null)
                                _InfoRow(
                                  icon: Icons.location_on_outlined,
                                  value: p.placeOfBirth!,
                                ),
                              if (p.deathday != null)
                                _InfoRow(
                                  icon: Icons.date_range_outlined,
                                  value: 'Vəfat: ${p.deathday}',
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Biography
                if (p.biography != null && p.biography!.trim().isNotEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Bioqrafiya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          _ExpandableBio(bio: p.biography!),
                        ],
                      ),
                    ),
                  ),

                // Filmography
                if (p.movieCredits.isNotEmpty) ...[
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 8, 20, 12),
                      child: Text(
                        'Filmoqrafiya 🎬',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: HorizontalMovieList(
                      movies: p.movieCredits,
                      onMovieTap: (m) =>
                          ctx.push('/detail/${m.id}?isTv=false'),
                    ),
                  ),
                ],

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildShimmer() => CustomScrollView(slivers: [
        const SliverAppBar(
          pinned: true,
          backgroundColor: Color(0xFF0F0F0F),
          leading: BackButton(color: Colors.white),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(20),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              Row(
                children: const [
                  ShimmerBox(width: 110, height: 160, borderRadius: 12),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerBox(width: 180, height: 24, borderRadius: 4),
                        SizedBox(height: 10),
                        ShimmerBox(width: 120, height: 14, borderRadius: 4),
                        SizedBox(height: 6),
                        ShimmerBox(width: 150, height: 14, borderRadius: 4),
                      ],
                    ),
                  ),
                ],
              ),
            ]),
          ),
        ),
      ]);
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String value;
  const _InfoRow({required this.icon, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF9E9E9E), size: 14),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableBio extends StatefulWidget {
  final String bio;
  const _ExpandableBio({required this.bio});

  @override
  State<_ExpandableBio> createState() => _ExpandableBioState();
}

class _ExpandableBioState extends State<_ExpandableBio> {
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
            widget.bio,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                color: Color(0xFFCCCCCC), height: 1.6, fontSize: 13),
          ),
          secondChild: Text(
            widget.bio,
            style: const TextStyle(
                color: Color(0xFFCCCCCC), height: 1.6, fontSize: 13),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Text(
            _expanded ? 'Azalt' : 'Daha çox',
            style: const TextStyle(
              color: Color(0xFFE50914),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
