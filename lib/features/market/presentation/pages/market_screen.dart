import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/common_stock_list_view.dart';
import '../../domain/repositories/market_repository.dart';
import '../bloc/live_price_cubit.dart';
import '../bloc/market_list_cubit.dart';
import '../bloc/market_list_state.dart';
import '../widgets/stock_row.dart';

class MarketScreen extends StatefulWidget {
  const MarketScreen({super.key});

  @override
  State<MarketScreen> createState() => _MarketScreenState();
}

class _MarketScreenState extends State<MarketScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    getIt<MarketRepository>().startFeed();

    return BlocProvider(
      create: (_) => getIt<MarketListCubit>(),
      child: Scaffold(
        appBar: AppBar(title: const Text(AppStrings.titleLiveMarket)),
        body: BlocBuilder<MarketListCubit, MarketListState>(
          builder: (context, state) {
            if (state is MarketListLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is MarketListLoaded) {
              final query = state.searchQuery.trim().toLowerCase();
              final filteredStocks = AppConfig.availableStocks.where((symbol) {
                if (query.isEmpty) return true;
                final name = (AppConfig.companyNames[symbol] ?? '')
                    .toLowerCase();
                return symbol.toLowerCase().contains(query) ||
                    name.contains(query);
              }).toList();

              filteredStocks.sort((a, b) {
                final tickA = state.ticks[a];
                final tickB = state.ticks[b];

                final pctA = tickA?.changePercent ?? 0.0;
                final pctB = tickB?.changePercent ?? 0.0;

                final volA = AppConfig.companyVolumes[a] ?? 0.0;
                final volB = AppConfig.companyVolumes[b] ?? 0.0;

                int result = 0;
                switch (state.sortOption) {
                  case MarketSortOption.percentage:
                    result = pctA.compareTo(pctB);
                    break;
                  case MarketSortOption.volume:
                    result = volA.compareTo(volB);
                    break;
                  case MarketSortOption.symbol:
                    result = a.compareTo(b);
                    break;
                }

                return state.isAscending ? result : -result;
              });

              return Column(
                children: [
                  // Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.sm,
                      AppSpacing.md,
                      AppSpacing.sm,
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (val) {
                        context.read<MarketListCubit>().updateSearchQuery(val);
                      },
                      decoration: InputDecoration(
                        hintText: AppStrings.searchPlaceholder,
                        hintStyle: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary.withValues(alpha: 0.6),
                        ),
                        prefixIcon: const Icon(
                          Icons.search_rounded,
                          color: AppColors.textSecondary,
                          size: 20,
                        ),
                        suffixIcon: state.searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.clear_rounded,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                                onPressed: () {
                                  _searchController.clear();
                                  context
                                      .read<MarketListCubit>()
                                      .updateSearchQuery('');
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: AppColors.surface,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: 10,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.divider,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Stock List or Empty Search Results
                  Expanded(
                    child: filteredStocks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.search_off_rounded,
                                  size: 48,
                                  color: AppColors.textSecondary.withValues(
                                    alpha: 0.5,
                                  ),
                                ),
                                const SizedBox(height: AppSpacing.md),
                                Text(
                                  '${AppStrings.searchNoResults} "${state.searchQuery}"',
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : CommonStockListView<String>(
                            col1: AppStrings.colCompanyName,
                            col2: AppStrings.colVolumeCr,
                            col3: AppStrings.colLTP,
                            onCol1Tap: () => context
                                .read<MarketListCubit>()
                                .updateSortOption(MarketSortOption.symbol),
                            onCol2Tap: () => context
                                .read<MarketListCubit>()
                                .updateSortOption(MarketSortOption.volume),
                            onCol3Tap: () => context
                                .read<MarketListCubit>()
                                .updateSortOption(MarketSortOption.percentage),
                            items: filteredStocks,
                            itemBuilder: (context, symbol, index) {
                              return BlocProvider(
                                key: ValueKey(symbol),
                                create: (_) => LivePriceCubit(
                                  marketRepository: getIt<MarketRepository>(),
                                  symbol: symbol,
                                ),
                                child: StockRow(
                                  symbol: symbol,
                                  onTap: () {
                                    context.push('/trade/$symbol');
                                  },
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
