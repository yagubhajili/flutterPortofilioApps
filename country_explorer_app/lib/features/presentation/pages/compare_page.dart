import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../../domain/entities/country_entity.dart';
import '../bloc/compare/compare_bloc.dart';
import '../bloc/compare/compare_event.dart';
import '../bloc/compare/compare_state.dart';
import '../widgets/compare_row_widget.dart';

class ComparePage extends StatefulWidget {
  const ComparePage({super.key});

  @override
  State<ComparePage> createState() => _ComparePageState();
}

class _ComparePageState extends State<ComparePage> {
  @override
  void initState() {
    super.initState();
    context.read<CompareBloc>().add(const LoadCompareCountriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocBuilder<CompareBloc, CompareState>(
          builder: (context, state) {
            if (state is CompareLoading) {
              return const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.primary));
            }
            if (state is CompareError) {
              return Center(
                child: Text(state.message,
                    style: const TextStyle(
                        color: AppColors.textSecondary)),
              );
            }
            if (state is CompareReady) {
              return _CompareBody(state: state);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}

class _CompareBody extends StatelessWidget {
  final CompareReady state;
  const _CompareBody({required this.state});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          const Row(
            children: [
              Icon(Icons.compare_arrows, color: AppColors.primary, size: 22),
              SizedBox(width: 8),
              Text(
                'Müqayisə Paneli',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            'İki ölkəni seçin və əsas göstəriciləri müqayisə edin.',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
          ),
          const SizedBox(height: 20),
          _CountrySelector(
            label: 'Birinci Ölkə',
            selected: state.country1,
            countries: state.allCountries,
            onSelected: (c) =>
                context.read<CompareBloc>().add(SelectCountry1Event(c)),
          ),
          const SizedBox(height: 12),
          _CountrySelector(
            label: 'İkinci Ölkə',
            selected: state.country2,
            countries: state.allCountries,
            onSelected: (c) =>
                context.read<CompareBloc>().add(SelectCountry2Event(c)),
          ),
          const SizedBox(height: 16),
          if (state.country1 != null && state.country2 != null) ...[
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                icon: const Icon(Icons.bar_chart, size: 18),
                label: const Text('GÖSTƏRİCİLƏRİ MÜQAYİSƏ ET'),
                onPressed: () => context
                    .read<CompareBloc>()
                    .add(const ShowComparisonEvent()),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  context.read<CompareBloc>().add(const ClearCompareEvent()),
              child: const Text('Sıfırla',
                  style: TextStyle(color: AppColors.textSecondary)),
            ),
          ],
          if (state.showComparison &&
              state.country1 != null &&
              state.country2 != null) ...[
            const SizedBox(height: 20),
            _ComparisonSection(
                country1: state.country1!, country2: state.country2!),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _CountrySelector extends StatelessWidget {
  final String label;
  final CountryEntity? selected;
  final List<CountryEntity> countries;
  final ValueChanged<CountryEntity> onSelected;

  const _CountrySelector({
    required this.label,
    required this.selected,
    required this.countries,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: () => _showPicker(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: selected != null
                    ? AppColors.primary
                    : AppColors.border,
                width: selected != null ? 1.5 : 0.5,
              ),
            ),
            child: Row(
              children: [
                if (selected != null) ...[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: selected!.flagPng,
                      width: 32,
                      height: 22,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => Container(
                          width: 32,
                          height: 22,
                          color: AppColors.surfaceVariant),
                      errorWidget: (_, _, _) =>
                          const Icon(Icons.flag_outlined, size: 22),
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    selected?.commonName ?? 'Ölkə seçin...',
                    style: TextStyle(
                      color: selected != null
                          ? AppColors.textPrimary
                          : AppColors.textMuted,
                      fontSize: 14,
                      fontWeight: selected != null
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ),
                const Icon(Icons.keyboard_arrow_down,
                    color: AppColors.textMuted, size: 20),
              ],
            ),
          ),
        ),
        if (selected != null) ...[
          const SizedBox(height: 8),
          _MiniCountryCard(country: selected!),
        ],
      ],
    );
  }

  void _showPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        builder: (ctx, scrollController) => _CountryPickerSheet(
          countries: countries,
          onSelected: (c) {
            onSelected(c);
            Navigator.pop(ctx);
          },
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _MiniCountryCard extends StatelessWidget {
  final CountryEntity country;
  const _MiniCountryCard({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 0.5),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: CachedNetworkImage(
              imageUrl: country.flagPng,
              width: 52,
              height: 36,
              fit: BoxFit.cover,
              placeholder: (_, _) =>
                  Container(width: 52, height: 36, color: AppColors.surface),
              errorWidget: (_, _, _) => const Icon(Icons.flag_outlined),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  country.commonName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  AppConstants.regionAz(country.region),
                  style: const TextStyle(
                      color: AppColors.textSecondary, fontSize: 12),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CountryPickerSheet extends StatefulWidget {
  final List<CountryEntity> countries;
  final ValueChanged<CountryEntity> onSelected;
  final ScrollController scrollController;

  const _CountryPickerSheet({
    required this.countries,
    required this.onSelected,
    required this.scrollController,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late List<CountryEntity> _filtered;
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filtered = widget.countries;
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    setState(() {
      _filtered = q.isEmpty
          ? widget.countries
          : widget.countries
              .where((c) =>
                  c.commonName.toLowerCase().contains(q.toLowerCase()))
              .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 12),
        Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: AppColors.border,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            controller: _searchCtrl,
            onChanged: _onSearch,
            autofocus: true,
            style: const TextStyle(color: AppColors.textPrimary),
            decoration: const InputDecoration(
              hintText: 'Ölkə axtar...',
              prefixIcon:
                  Icon(Icons.search, color: AppColors.textMuted, size: 20),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.builder(
            controller: widget.scrollController,
            itemCount: _filtered.length,
            itemBuilder: (context, i) {
              final c = _filtered[i];
              return ListTile(
                onTap: () => widget.onSelected(c),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: CachedNetworkImage(
                    imageUrl: c.flagPng,
                    width: 40,
                    height: 28,
                    fit: BoxFit.cover,
                    placeholder: (_, _) => Container(
                        width: 40,
                        height: 28,
                        color: AppColors.surfaceVariant),
                    errorWidget: (_, _, _) =>
                        const Icon(Icons.flag_outlined),
                  ),
                ),
                title: Text(c.commonName,
                    style: const TextStyle(color: AppColors.textPrimary)),
                subtitle: Text(AppConstants.regionAz(c.region),
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _ComparisonSection extends StatelessWidget {
  final CountryEntity country1;
  final CountryEntity country2;

  const _ComparisonSection({
    required this.country1,
    required this.country2,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _CountryHeaders(country1: country1, country2: country2),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border, width: 0.5),
          ),
          child: Column(
            children: [
              CompareRowWidget(
                icon: Icons.people_outline,
                label: 'Əhali',
                value1: NumberFormatter.formatPopulation(country1.population),
                value2: NumberFormatter.formatPopulation(country2.population),
                value1Better: country1.population > country2.population,
              ),
              const Divider(height: 16),
              CompareRowWidget(
                icon: Icons.map_outlined,
                label: 'Ərazi',
                value1: country1.area != null
                    ? NumberFormatter.formatArea(country1.area!)
                    : '—',
                value2: country2.area != null
                    ? NumberFormatter.formatArea(country2.area!)
                    : '—',
                value1Better:
                    (country1.area ?? 0) > (country2.area ?? 0),
              ),
              const Divider(height: 16),
              CompareRowWidget(
                icon: Icons.language,
                label: 'Dillər',
                value1: country1.languages.values
                    .take(2)
                    .join(', '),
                value2: country2.languages.values
                    .take(2)
                    .join(', '),
              ),
              const Divider(height: 16),
              CompareRowWidget(
                icon: Icons.schedule,
                label: 'Vaxt Zonası',
                value1: country1.timezones.first,
                value2: country2.timezones.first,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Coğrafi Yerləşmə',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: _MiniMap(country: country1)),
            const SizedBox(width: 8),
            Expanded(child: _MiniMap(country: country2)),
          ],
        ),
      ],
    );
  }
}

class _CountryHeaders extends StatelessWidget {
  final CountryEntity country1;
  final CountryEntity country2;
  const _CountryHeaders(
      {required this.country1, required this.country2});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _Header(country: country1)),
        const SizedBox(width: 8),
        Expanded(child: _Header(country: country2)),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  final CountryEntity country;
  const _Header({required this.country});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          CachedNetworkImage(
            imageUrl: country.flagPng,
            height: 60,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 6),
          Text(
            country.commonName,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _MiniMap extends StatelessWidget {
  final CountryEntity country;
  const _MiniMap({required this.country});

  @override
  Widget build(BuildContext context) {
    if (country.latlng == null || country.latlng!.length < 2) {
      return Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Center(
          child: Icon(Icons.map_outlined,
              color: AppColors.textMuted, size: 32),
        ),
      );
    }
    final lat = country.latlng![0];
    final lng = country.latlng![1];
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: SizedBox(
        height: 120,
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 3),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName:
                      'com.example.country_explorer_app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: LatLng(lat, lng),
                      child: const Icon(
                        Icons.location_pin,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                color: AppColors.background.withValues(alpha: 0.75),
                child: Text(
                  country.commonName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
