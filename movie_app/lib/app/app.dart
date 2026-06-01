import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app/di/injection.dart';
import '../core/router/app_router.dart';
import '../core/theme/app_theme.dart';
import '../presentation/watchlist/cubit/watchlist_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // WatchlistCubit is app-wide (singleton) so favourites stay in sync
        BlocProvider.value(value: sl<WatchlistCubit>()),
      ],
      child: MaterialApp.router(
        title: 'CinéApp',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.dark,
        routerConfig: appRouter,
      ),
    );
  }
}
