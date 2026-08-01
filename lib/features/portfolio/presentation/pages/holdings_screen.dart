import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/list_header_row.dart';
import '../../../../core/presentation/widgets/metric_text.dart';
import '../../../../core/utils/formatters.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../bloc/holdings_cubit.dart';
import '../bloc/holdings_state.dart';
import '../bloc/portfolio_summary_cubit.dart';
import '../widgets/holding_row.dart';

class HoldingsScreen extends StatelessWidget {
  const HoldingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.titlePortfolio)),
      body: Column(
        children: [
          // Aggregate Summary Card
          BlocBuilder<PortfolioSummaryCubit, PortfolioSummaryState>(
            builder: (context, state) {
              final isPositive = state.totalPnL >= 0;
              final pnlColor = isPositive ? AppColors.profit : AppColors.loss;

              // Mock 1D change data
              final mock1dChange = state.totalPnL * 0.1;
              final mock1dPercent = state.totalPnLPercent * 0.1;
              final is1dPositive = mock1dChange >= 0;
              final oneDColor = is1dPositive
                  ? AppColors.profit
                  : AppColors.loss;

              return Padding(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.portfolioCurrentValue,
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.formatPrice(
                                  state.currentValue,
                                ).replaceAll('₹', ''),
                                style: AppTextStyles.displayLarge,
                              ),
                            ],
                          ),
                          Container(
                            height: 40,
                            width: 1,
                            color: AppColors.divider,
                            margin: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                AppStrings.portfolioInvested,
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                Formatters.formatPrice(
                                  state.totalInvested,
                                ).replaceAll('₹', ''),
                                style: AppTextStyles.titleMedium,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      const Divider(color: AppColors.divider, height: 1),
                      const SizedBox(height: AppSpacing.lg),
                      MetricText(
                        label: AppStrings.portfolioProfitLoss,
                        value: Formatters.formatChange(
                          state.totalPnL,
                          state.totalPnLPercent,
                        ),
                        valueColor: pnlColor,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      MetricText(
                        label: AppStrings.portfolio1DChange,
                        value: Formatters.formatChange(
                          mock1dChange,
                          mock1dPercent,
                        ),
                        valueColor: oneDColor,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),

          // Toggles Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Row(
              children: [
                BlocBuilder<HoldingsCubit, HoldingsState>(
                  builder: (context, state) {
                    if (state is HoldingsLoaded) {
                      String sortLabel = 'P&L';
                      if (state.sortOption == HoldingsSortOption.value)
                        sortLabel = 'Value';
                      if (state.sortOption == HoldingsSortOption.symbol)
                        sortLabel = 'Name';

                      return InkWell(
                        onTap: () {
                          // Cycle through sort options
                          var nextSort = HoldingsSortOption.pnl;
                          if (state.sortOption == HoldingsSortOption.pnl)
                            nextSort = HoldingsSortOption.value;
                          else if (state.sortOption == HoldingsSortOption.value)
                            nextSort = HoldingsSortOption.symbol;

                          context.read<HoldingsCubit>().updateSortOption(
                            nextSort,
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.divider),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            children: [
                              Text(
                                '${AppStrings.sortPrefix} $sortLabel',
                                style: AppTextStyles.labelMedium,
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_downward,
                                size: 14,
                                color: AppColors.textSecondary,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(width: AppSpacing.md),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.divider),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        AppStrings.openOrders,
                        style: AppTextStyles.labelMedium,
                      ),
                      const SizedBox(width: 4),
                      Switch(
                        value: false,
                        onChanged: (val) {
                          // Dummy switch for now
                        },
                        activeColor: Colors.white,
                        activeTrackColor: AppColors.primary,
                        inactiveThumbColor: AppColors.textSecondary,
                        inactiveTrackColor: AppColors.background,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.md),
          const Divider(height: 1),
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: ListHeaderRow(
              col1: AppStrings.colNameQty,
              col2: AppStrings.colValLtp,
              col3: AppStrings.colPnl1d,
            ),
          ),
          const Divider(height: 1),

          // Holdings List
          Expanded(
            child: BlocBuilder<HoldingsCubit, HoldingsState>(
              builder: (context, state) {
                if (state is HoldingsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is HoldingsError) {
                  return Center(child: Text(state.message));
                }
                if (state is HoldingsLoaded) {
                  if (state.holdings.isEmpty) {
                    return const Center(
                      child: Text(AppStrings.portfolioNoHoldings),
                    );
                  }

                  return BlocBuilder<
                    PortfolioSummaryCubit,
                    PortfolioSummaryState
                  >(
                    builder: (context, summaryState) {
                      final ticks = summaryState.ticks;
                      final sortedHoldings = List.of(state.holdings);
                      sortedHoldings.sort((a, b) {
                        final tickA = ticks[a.symbol];
                        final tickB = ticks[b.symbol];

                        final priceA = tickA?.price ?? a.averageCost;
                        final priceB = tickB?.price ?? b.averageCost;

                        switch (state.sortOption) {
                          case HoldingsSortOption.pnl:
                            final pnlA =
                                (a.quantity * priceA) -
                                (a.quantity * a.averageCost);
                            final pnlB =
                                (b.quantity * priceB) -
                                (b.quantity * b.averageCost);
                            return pnlB.compareTo(pnlA);
                          case HoldingsSortOption.value:
                            final valA = a.quantity * priceA;
                            final valB = b.quantity * priceB;
                            return valB.compareTo(valA);
                          case HoldingsSortOption.symbol:
                            return a.symbol.compareTo(b.symbol);
                        }
                      });

                      return ListView.separated(
                        itemCount: sortedHoldings.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final holding = sortedHoldings[index];
                          return BlocProvider(
                            key: ValueKey(holding.symbol),
                            create: (_) => LivePriceCubit(
                              marketRepository: getIt<MarketRepository>(),
                              symbol: holding.symbol,
                            ),
                            child: HoldingRow(
                              holding: holding,
                              onTap: () {
                                context.push('/trade/${holding.symbol}');
                              },
                            ),
                          );
                        },
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
    );
  }
}
