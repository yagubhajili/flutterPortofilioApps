import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di/injection.dart';
import '../../../app/theme/app_colors.dart';
import '../bloc/compare/compare_cubit.dart';
import '../bloc/country_list/country_list_cubit.dart';
import '../bloc/favorites/favorites_cubit.dart';
import 'compare_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final CountryListCubit _countryListCubit;
  late final FavoritesCubit _favoritesCubit;
  late final CompareCubit _compareCubit;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _countryListCubit = sl<CountryListCubit>();
    _favoritesCubit = sl<FavoritesCubit>();
    _compareCubit = sl<CompareCubit>();
  }

  @override
  void dispose() {
    _countryListCubit.close();
    _favoritesCubit.close();
    _compareCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _countryListCubit),
        BlocProvider.value(value: _favoritesCubit),
        BlocProvider.value(value: _compareCubit),
      ],
      child: Builder(
        builder: (ctx) => Scaffold(
          body: IndexedStack(
            index: _index,
            children: const [HomePage(), FavoritesPage(), ComparePage()],
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              border: Border(
                  top: BorderSide(color: colors.border, width: 0.5)),
            ),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) {
                if (i == 3) {
                  ctx.read<CountryListCubit>().random();
                  setState(() => _index = 0);
                } else {
                  setState(() => _index = i);
                }
              },
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Ana Səhifə',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.favorite_border),
                  activeIcon: Icon(Icons.favorite),
                  label: 'Sevimlilər',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.compare_arrows),
                  label: 'Müqayisə',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.casino_outlined),
                  label: 'Təsadüf',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
