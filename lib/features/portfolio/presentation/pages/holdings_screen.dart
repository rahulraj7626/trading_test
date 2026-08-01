import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/common_stock_list_view.dart';
import '../../../../core/presentation/widgets/metric_text.dart';
import '../../../../core/utils/formatters.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../domain/entities/holding.dart';
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
                    ],
                  ),
                ),
              );
            },
          ),

          // Holdings List using CommonStockListView
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

                        int result = 0;
                        switch (state.sortOption) {
                          case HoldingsSortOption.pnl:
                            final pnlA =
                                (a.quantity * priceA) -
                                (a.quantity * a.averageCost);
                            final pnlB =
                                (b.quantity * priceB) -
                                (b.quantity * b.averageCost);
                            result = pnlA.compareTo(pnlB);
                            break;
                          case HoldingsSortOption.value:
                            final valA = a.quantity * priceA;
                            final valB = b.quantity * priceB;
                            result = valA.compareTo(valB);
                            break;
                          case HoldingsSortOption.symbol:
                            result = a.symbol.compareTo(b.symbol);
                            break;
                        }
                        return state.isAscending ? result : -result;
                      });

                      return CommonStockListView<Holding>(
                        col1: AppStrings.colCompanyName,
                        col2: AppStrings.sortLabelValue,
                        col3: AppStrings.colPnl1d,
                        onCol1Tap: () => context
                            .read<HoldingsCubit>()
                            .updateSortOption(HoldingsSortOption.symbol),
                        onCol2Tap: () => context
                            .read<HoldingsCubit>()
                            .updateSortOption(HoldingsSortOption.value),
                        onCol3Tap: () => context
                            .read<HoldingsCubit>()
                            .updateSortOption(HoldingsSortOption.pnl),
                        items: sortedHoldings,
                        itemBuilder: (context, holding, index) {
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
