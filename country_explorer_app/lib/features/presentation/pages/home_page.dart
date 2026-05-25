import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../app/theme/app_colors.dart';
import '../bloc/country_list/country_list_bloc.dart';
import '../bloc/country_list/country_list_event.dart';
import '../bloc/country_list/country_list_state.dart';
import '../widgets/country_card.dart';
import '../widgets/region_filter_chips.dart';
import '../widgets/sort_bottom_sheet.dart';
import 'detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final bloc = context.read<CountryListBloc>();
    if (bloc.state is CountryListInitial) {
      bloc.add(const LoadCountriesEvent());
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openDetail(BuildContext context, String cca3) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => DetailPage(cca3: cca3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Header(onRandomTap: _onRandomTap),
            const SizedBox(height: 16),
            _SearchBar(controller: _searchController),
            const SizedBox(height: 14),
            BlocBuilder<CountryListBloc, CountryListState>(
              buildWhen: (p, c) =>
                  c is CountryListLoaded || c is CountryListInitial,
              builder: (context, state) {
                final region = state is CountryListLoaded
                    ? state.selectedRegion
                    : 'Hamısı';
                return RegionFilterChips(
                  selected: region,
                  onSelected: (r) => context
                      .read<CountryListBloc>()
                      .add(FilterByRegionEvent(r)),
                );
              },
            ),
            const SizedBox(height: 12),
            _SortBar(),
            const SizedBox(height: 8),
            Expanded(
              child: BlocConsumer<CountryListBloc, CountryListState>(
                listener: (context, state) {
                  if (state is CountryListLoaded &&
                      state.randomCountry != null) {
                    _openDetail(context, state.randomCountry!.cca3);
                  }
                },
                builder: (context, state) {
                  if (state is CountryListLoading) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.primary),
                    );
                  }
                  if (state is CountryListError) {
                    return _ErrorView(
                      message: state.message,
                      onRetry: () => context
                          .read<CountryListBloc>()
                          .add(const LoadCountriesEvent()),
                    );
                  }
                  if (state is CountryListLoaded) {
                    if (state.displayedCountries.isEmpty) {
                      return const _EmptyView();
                    }
                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      itemCount: state.displayedCountries.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: 12),
                      itemBuilder: (context, i) {
                        final country = state.displayedCountries[i];
                        return CountryCard(
                          country: country,
                          onTap: () => _openDetail(context, country.cca3),
                          onFavoriteTap: () => context
                              .read<CountryListBloc>()
                              .add(ToggleFavoriteListEvent(country.cca3)),
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

  void _onRandomTap(BuildContext context) {
    context.read<CountryListBloc>().add(const RandomCountryEvent());
  }
}

class _Header extends StatelessWidget {
  final void Function(BuildContext) onRandomTap;
  const _Header({required this.onRandomTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.public, color: AppColors.primary, size: 22),
              const SizedBox(width: 8),
              const Text(
                'Dünya Kəşfiyyatçısı',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.search,
                    color: AppColors.textSecondary),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Yeni dünyalar kəşf edin',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Planetimizin müxtəlifliyini, mədəniyyətlərini və coğrafi möcüzələrini hər yerdə araşdır.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => onRandomTap(context),
              icon: const Icon(Icons.casino_outlined, size: 18),
              label: const Text('Təsadüfi Ölkə'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        onChanged: (q) =>
            context.read<CountryListBloc>().add(SearchCountriesEvent(q)),
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: const InputDecoration(
          hintText: 'Ölkə və ya paytaxt axtar...',
          prefixIcon: Icon(Icons.search, color: AppColors.textMuted, size: 20),
          suffixIcon: null,
        ),
      ),
    );
  }
}

class _SortBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CountryListBloc, CountryListState>(
      buildWhen: (p, c) => c is CountryListLoaded,
      builder: (context, state) {
        if (state is! CountryListLoaded) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Text(
                '${state.displayedCountries.length} ölkə',
                style: const TextStyle(
                    color: AppColors.textSecondary, fontSize: 13),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () => showModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (_) => SortBottomSheet(
                    current: state.sortType,
                    onSelected: (s) => context
                        .read<CountryListBloc>()
                        .add(SortCountriesEvent(s)),
                  ),
                ),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border:
                        Border.all(color: AppColors.border, width: 0.5),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.sort, color: AppColors.primary, size: 16),
                      SizedBox(width: 6),
                      Text(
                        'Çeşidlə',
                        style: TextStyle(
                            color: AppColors.textSecondary, fontSize: 13),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  const _ErrorView({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off_outlined,
                color: AppColors.textMuted, size: 48),
            const SizedBox(height: 12),
            Text(
              message,
              style: const TextStyle(
                  color: AppColors.textSecondary, fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Yenidən cəhd et'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.search_off, color: AppColors.textMuted, size: 48),
          SizedBox(height: 12),
          Text(
            'Heç bir nəticə tapılmadı.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
