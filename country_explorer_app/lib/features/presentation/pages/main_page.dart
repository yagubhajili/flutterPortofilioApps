import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/di/injection.dart';
import '../../../app/theme/app_colors.dart';
import '../bloc/compare/compare_bloc.dart';
import '../bloc/country_list/country_list_bloc.dart';
import '../bloc/country_list/country_list_event.dart';
import '../bloc/favorites/favorites_bloc.dart';
import 'compare_page.dart';
import 'favorites_page.dart';
import 'home_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late final CountryListBloc _countryListBloc;
  late final FavoritesBloc _favoritesBloc;
  late final CompareBloc _compareBloc;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _countryListBloc = sl<CountryListBloc>();
    _favoritesBloc = sl<FavoritesBloc>();
    _compareBloc = sl<CompareBloc>();
  }

  @override
  void dispose() {
    _countryListBloc.close();
    _favoritesBloc.close();
    _compareBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _countryListBloc),
        BlocProvider.value(value: _favoritesBloc),
        BlocProvider.value(value: _compareBloc),
      ],
      child: Builder(
        builder: (ctx) => Scaffold(
          body: IndexedStack(
            index: _index,
            children: const [HomePage(), FavoritesPage(), ComparePage()],
          ),
          bottomNavigationBar: Container(
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(
                  top: BorderSide(color: AppColors.border, width: 0.5)),
            ),
            child: BottomNavigationBar(
              currentIndex: _index,
              onTap: (i) {
                if (i == 3) {
                  ctx
                      .read<CountryListBloc>()
                      .add(const RandomCountryEvent());
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
