import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../app/di/injection.dart' show sl;
import '../../presentation/home/cubit/home_cubit.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/movie_detail/cubit/detail_cubit.dart';
import '../../presentation/movie_detail/pages/movie_detail_page.dart';
import '../../presentation/person/cubit/person_cubit.dart';
import '../../presentation/person/pages/person_page.dart';
import '../../presentation/search/cubit/search_cubit.dart';
import '../../presentation/search/pages/search_page.dart';
import '../../presentation/watchlist/cubit/watchlist_cubit.dart';
import '../../presentation/watchlist/pages/watchlist_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    // ── Home ──────────────────────────────────────────────────────────────
    GoRoute(
      path: '/',
      builder: (_, _) => BlocProvider(
        create: (_) => sl<HomeCubit>(),
        child: const HomePage(),
      ),
    ),

    // ── Movie / TV Detail ─────────────────────────────────────────────────
    GoRoute(
      path: '/detail/:id',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        final isTv = state.uri.queryParameters['isTv'] == 'true';
        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => sl<DetailCubit>()),
            BlocProvider.value(value: sl<WatchlistCubit>()),
          ],
          child: MovieDetailPage(id: id, isTv: isTv),
        );
      },
    ),

    // ── Search ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/search',
      builder: (_, _) => BlocProvider(
        create: (_) => sl<SearchCubit>(),
        child: const SearchPage(),
      ),
    ),

    // ── Watchlist ─────────────────────────────────────────────────────────
    GoRoute(
      path: '/watchlist',
      builder: (_, _) => BlocProvider.value(
        value: sl<WatchlistCubit>(),
        child: const WatchlistPage(),
      ),
    ),

    // ── Person ────────────────────────────────────────────────────────────
    GoRoute(
      path: '/person/:id',
      builder: (_, state) {
        final id = int.parse(state.pathParameters['id']!);
        return BlocProvider(
          create: (_) => sl<PersonCubit>(),
          child: PersonPage(id: id),
        );
      },
    ),
  ],
);
