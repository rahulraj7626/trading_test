import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/common_stock_list_view.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../../market/presentation/bloc/market_list_cubit.dart';
import '../../../market/presentation/bloc/market_list_state.dart';
import '../../../market/presentation/widgets/stock_row.dart';
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
                      Icons.arrow_drop_down,
                      color: Colors.white,
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
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
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
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: () => _showAddWatchlistDialog(context),
            ),
            BlocBuilder<WatchlistCubit, WatchlistState>(
              builder: (context, state) {
                if (state is WatchlistLoaded && state.watchlists.isNotEmpty) {
                  return IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      final selected = state.selectedWatchlist;
                      if (selected != null) {
                        context.read<WatchlistCubit>().deleteWatchlist(
                          selected.id,
                        );
                      }
                    },
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
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
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
                onPressed: () async {
                  final selected = state.selectedWatchlist;
                  if (selected != null) {
                    final symbol = await showDialog<String>(
                      context: context,
                      builder: (context) =>
                          StockPickerDialog(currentSymbols: selected.symbols),
                    );
                    if (symbol != null && context.mounted) {
                      context.read<WatchlistCubit>().addStockToWatchlist(
                        selected.id,
                        symbol,
                      );
                    }
                  }
                },
                child: const Icon(Icons.add),
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(AppStrings.dialogNewWatchlist),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: AppStrings.titleWatchlist,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(AppStrings.dialogCancel),
            ),
            TextButton(
              onPressed: () {
                if (controller.text.trim().isNotEmpty) {
                  context.read<WatchlistCubit>().addWatchlist(
                    controller.text.trim(),
                  );
                  Navigator.pop(context);
                }
              },
              child: const Text(AppStrings.dialogAdd),
            ),
          ],
        );
      },
    );
  }
}
