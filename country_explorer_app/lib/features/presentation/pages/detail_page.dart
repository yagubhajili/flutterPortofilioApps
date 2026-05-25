import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../app/di/injection.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/number_formatter.dart';
import '../bloc/country_detail/country_detail_cubit.dart';
import '../bloc/country_detail/country_detail_state.dart';
import '../widgets/border_country_card.dart';
import '../widgets/info_row_widget.dart';

class DetailPage extends StatelessWidget {
  final String cca3;
  const DetailPage({super.key, required this.cca3});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CountryDetailCubit>()..load(cca3),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Scaffold(
      backgroundColor: colors.background,
      body: BlocBuilder<CountryDetailCubit, CountryDetailState>(
        builder: (context, state) {
          if (state is CountryDetailLoading) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.primary));
          }
          if (state is CountryDetailError) {
            return Scaffold(
              appBar: AppBar(title: const Text('Dünya Kəşfiyyatçısı')),
              body: Center(
                child: Text(state.message,
                    style: TextStyle(color: colors.textSecondary)),
              ),
            );
          }
          if (state is CountryDetailLoaded) {
            return _CountryDetail(state: state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _CountryDetail extends StatelessWidget {
  final CountryDetailLoaded state;
  const _CountryDetail({required this.state});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final country = state.country;
    final currencies = country.currencies
        .map((c) => '${c.name}${c.symbol != null ? ' (${c.symbol})' : ''}')
        .join(', ');
    final languages = country.languages.values.join(', ');
    final timezones = country.timezones.take(2).join(', ');
    final tld = country.tld?.join(', ') ?? '—';

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 220,
          pinned: true,
          backgroundColor: colors.background,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: colors.textPrimary),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text('Dünya Kəşfiyyatçısı'),
          actions: [
            BlocBuilder<CountryDetailCubit, CountryDetailState>(
              builder: (ctx, s) {
                final fav =
                    s is CountryDetailLoaded && s.country.isFavorite;
                return IconButton(
                  icon: Icon(
                    fav ? Icons.favorite : Icons.favorite_border,
                    color: fav ? Colors.redAccent : colors.textSecondary,
                  ),
                  onPressed: () => ctx
                      .read<CountryDetailCubit>()
                      .toggleFavorite(country.cca3),
                );
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                CachedNetworkImage(
                  imageUrl: country.flagPng,
                  fit: BoxFit.cover,
                  placeholder: (_, _) =>
                      Container(color: colors.surfaceVariant),
                  errorWidget: (_, _, _) =>
                      Container(color: colors.surfaceVariant),
                ),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        colors.background.withValues(alpha: 0.8),
                        colors.background,
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.regionColor(country.region)
                              .withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          AppConstants.regionAz(country.region),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        country.commonName,
                        style: TextStyle(
                          color: colors.textPrimary,
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                _SectionHeader(
                    icon: Icons.info_outline, title: 'Ətraflı Məlumat'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border, width: 0.5),
                  ),
                  child: Column(
                    children: [
                      InfoRowWidget(
                        icon: Icons.location_city_outlined,
                        label: 'PAYTAXT',
                        value: country.capital ?? '—',
                      ),
                      Divider(height: 1, color: colors.border),
                      InfoRowWidget(
                        icon: Icons.people_outline,
                        label: 'ƏHALİ',
                        value: NumberFormatter.formatPopulation(
                            country.population),
                      ),
                      Divider(height: 1, color: colors.border),
                      InfoRowWidget(
                        icon: Icons.translate,
                        label: 'RƏSMİ DİLLƏR',
                        value: languages.isEmpty ? '—' : languages,
                      ),
                      Divider(height: 1, color: colors.border),
                      InfoRowWidget(
                        icon: Icons.currency_exchange,
                        label: 'VALYUTA',
                        value: currencies.isEmpty ? '—' : currencies,
                      ),
                      Divider(height: 1, color: colors.border),
                      InfoRowWidget(
                        icon: Icons.schedule,
                        label: 'VAXT ZONASI',
                        value: timezones.isEmpty ? '—' : timezones,
                      ),
                      Divider(height: 1, color: colors.border),
                      InfoRowWidget(
                        icon: Icons.language,
                        label: 'İNTERNET DOMENİ',
                        value: tld,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _SectionHeader(
                    icon: Icons.flag_outlined, title: 'Milli Bayraq'),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colors.border, width: 0.5),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: country.flagPng,
                        width: double.infinity,
                        height: 160,
                        fit: BoxFit.cover,
                        placeholder: (_, _) =>
                            Container(height: 160, color: colors.surface),
                        errorWidget: (_, _, _) =>
                            Container(height: 160, color: colors.surface),
                      ),
                      if (country.flagAlt != null &&
                          country.flagAlt!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            '"${country.flagAlt}"',
                            style: TextStyle(
                              color: colors.textSecondary,
                              fontSize: 12,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                    ],
                  ),
                ),
                if (state.borderCountries.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(
                      icon: Icons.near_me_outlined,
                      title: 'Qonşu Ölkələr'),
                  const SizedBox(height: 8),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1.1,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: state.borderCountries.length,
                    itemBuilder: (context, i) {
                      final border = state.borderCountries[i];
                      return BorderCountryCard(
                        country: border,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetailPage(cca3: border.cca3),
                          ),
                        ),
                      );
                    },
                  ),
                ],
                if (country.latlng != null &&
                    country.latlng!.length >= 2) ...[
                  const SizedBox(height: 24),
                  _SectionHeader(
                      icon: Icons.map_outlined,
                      title: 'Coğrafi Yerləşmə'),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: SizedBox(
                      height: 200,
                      child: FlutterMap(
                        options: MapOptions(
                          initialCenter: LatLng(country.latlng![0],
                              country.latlng![1]),
                          initialZoom: 4,
                        ),
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
                                point: LatLng(country.latlng![0],
                                    country.latlng![1]),
                                child: const Icon(
                                  Icons.location_pin,
                                  color: AppColors.primary,
                                  size: 32,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                if (country.flagAlt != null &&
                    country.flagAlt!.isNotEmpty) ...[
                  const SizedBox(height: 24),
                  _FunFactCard(fact: country.flagAlt!),
                ],
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const _SectionHeader({required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _FunFactCard extends StatelessWidget {
  final String fact;
  const _FunFactCard({required this.fact});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withValues(alpha: 0.15),
            AppColors.primaryDark.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.3), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: AppColors.primary, size: 18),
              SizedBox(width: 8),
              Text(
                'Maraqlı Fakt',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            fact,
            style: TextStyle(
              color: colors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: ['#Bayraq', '#Məlumat'].map((tag) {
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: colors.surfaceVariant,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tag,
                  style: const TextStyle(
                      color: AppColors.primary, fontSize: 11),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
