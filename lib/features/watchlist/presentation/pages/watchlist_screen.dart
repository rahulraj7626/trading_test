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
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../../market/presentation/bloc/market_list_cubit.dart';
import '../../../market/presentation/bloc/market_list_state.dart';
import '../../../market/presentation/widgets/stock_row.dart';
import '../../domain/entities/watchlist.dart';
import '../bloc/watchlist_cubit.dart';
import '../bloc/watchlist_state.dart';
import '../widgets/stock_picker_dialog.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<MarketListCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: BlocBuilder<WatchlistCubit, WatchlistState>(
            builder: (context, state) {
              if (state is WatchlistLoaded) {
                final selected = state.selectedWatchlist;
                if (selected == null) {
                  return const Text(AppStrings.titleWatchlist);
                }
                return DropdownButtonHideUnderline(
                  child: DropdownButton<int>(
                    value: state.selectedIndex,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.primary,
                      size: 22,
                    ),
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    onChanged: (int? newValue) {
                      if (newValue != null) {
                        context.read<WatchlistCubit>().selectWatchlist(
                          newValue,
                        );
                      }
                    },
                    items: state.watchlists.asMap().entries.map((entry) {
                      return DropdownMenuItem<int>(
                        value: entry.key,
                        child: Text(
                          entry.value.name,
                          style: AppTextStyles.titleMedium.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                );
              }
              return const Text(AppStrings.titleWatchlist);
            },
          ),
          actions: [
            // Create Watchlist Action Button
            BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, state) {
                final isMaxReached =
                    state is WatchlistLoaded && state.watchlists.length >= 10;
                return Container(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isMaxReached
                        ? AppColors.textSecondary.withValues(alpha: 0.08)
                        : AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: IconButton(
                    icon: Icon(
                      Icons.playlist_add_rounded,
                      color: isMaxReached
                          ? AppColors.textSecondary.withValues(alpha: 0.5)
                          : AppColors.primary,
                      size: 22,
                    ),
                    tooltip: isMaxReached
                        ? AppStrings.errorMaxWatchlistsReached
                        : AppStrings.dialogNewWatchlist,
                    onPressed: () {
                      if (isMaxReached) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(AppStrings.errorMaxWatchlistsReached),
                          ),
                        );
                      } else {
                        _showAddWatchlistDialog(context);
                      }
                    },
                  ),
                );
              },
            ),

            // Delete Watchlist Action Button
            BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoaded && state.watchlists.length > 1) {
                  return Container(
                    margin: const EdgeInsets.only(
                      top: 8,
                      bottom: 8,
                      right: 12,
                      left: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: IconButton(
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                        size: 20,
                      ),
                      tooltip: AppStrings.dialogDeleteWatchlist,
                      onPressed: () {
                        final selected = state.selectedWatchlist;
                        if (selected != null) {
                          _showDeleteWatchlistDialog(context, selected);
                        }
                      },
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
        body: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is WatchlistError) {
              return Center(child: Text(state.message));
            }
            if (state is WatchlistLoaded) {
              final selected = state.selectedWatchlist;
              if (selected == null) {
                return const Center(child: Text(AppStrings.errorNoWatchlists));
              }

              if (selected.symbols.isEmpty) {
                return const Center(
                  child: Text(AppStrings.errorEmptyWatchlist),
                );
              }

              return BlocBuilder<MarketListCubit, MarketListState>(
                builder: (context, marketState) {
                  final sortedSymbols = List.of(selected.symbols);

                  if (marketState is MarketListLoaded) {
                    sortedSymbols.sort((a, b) {
                      final tickA = marketState.ticks[a];
                      final tickB = marketState.ticks[b];

                      final pctA = tickA?.changePercent ?? 0.0;
                      final pctB = tickB?.changePercent ?? 0.0;

                      final volA = AppConfig.companyVolumes[a] ?? 0.0;
                      final volB = AppConfig.companyVolumes[b] ?? 0.0;

                      int result = 0;
                      switch (marketState.sortOption) {
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

                      return marketState.isAscending ? result : -result;
                    });
                  }

                  return CommonStockListView<String>(
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
                    items: sortedSymbols,
                    onReorder: (oldIndex, newIndex) {
                      context.read<WatchlistCubit>().reorderStocks(
                        selected.id,
                        oldIndex,
                        newIndex,
                      );
                    },
                    dismissibleBuilder: (context, symbol, index, child) {
                      return Dismissible(
                        key: ValueKey('dismiss_$symbol'),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: AppColors.error,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete_outline_rounded,
                            color: Colors.white,
                          ),
                        ),
                        onDismissed: (_) {
                          context
                              .read<WatchlistCubit>()
                              .removeStockFromWatchlist(selected.id, symbol);
                        },
                        child: child,
                      );
                    },
                    itemBuilder: (context, symbol, index) {
                      return BlocProvider(
                        key: ValueKey('provider_$symbol'),
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
                  );
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
        floatingActionButton: BlocBuilder<WatchlistCubit, WatchlistState>(
          builder: (context, state) {
            if (state is WatchlistLoaded && state.watchlists.isNotEmpty) {
              return FloatingActionButton(
                elevation: 3,
                backgroundColor: AppColors.primary,
                tooltip: AppStrings.dialogAddStock,
                onPressed: () async {
                  final selected = state.selectedWatchlist;
                  if (selected != null) {
                    final symbol = await StockPickerDialog.show(
                      context,
                      currentSymbols: selected.symbols,
                    );
                    if (symbol != null && context.mounted) {
                      context.read<WatchlistCubit>().addStockToWatchlist(
                        selected.id,
                        symbol,
                      );
                    }
                  }
                },
                child: const Icon(
                  Icons.add_rounded,
                  color: Colors.white,
                  size: 28,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  void _showAddWatchlistDialog(BuildContext context) {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            left: AppSpacing.md,
            right: AppSpacing.md,
            top: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              const Text(
                AppStrings.dialogNewWatchlist,
                style: AppTextStyles.titleLarge,
              ),
              const SizedBox(height: AppSpacing.md),
              TextField(
                controller: controller,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: AppStrings.titleWatchlist,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: AppColors.divider),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(AppStrings.dialogCancel),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      if (controller.text.trim().isNotEmpty) {
                        context.read<WatchlistCubit>().addWatchlist(
                          controller.text.trim(),
                        );
                        Navigator.pop(context);
                      }
                    },
                    child: const Text(
                      AppStrings.dialogAdd,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  void _showDeleteWatchlistDialog(BuildContext context, Watchlist selected) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text(
            AppStrings.dialogDeleteWatchlist,
            style: AppTextStyles.titleLarge,
          ),
          content: const Text(
            AppStrings.dialogDeleteWatchlistConfirm,
            style: AppTextStyles.bodyMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(AppStrings.dialogCancel),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                context.read<WatchlistCubit>().deleteWatchlist(selected.id);
                Navigator.pop(dialogContext);
              },
              child: const Text(
                AppStrings.dialogDelete,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
