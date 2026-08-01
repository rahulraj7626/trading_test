import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/presentation/widgets/common_stock_list_view.dart';
import '../../domain/repositories/market_repository.dart';
import '../bloc/live_price_cubit.dart';
import '../bloc/market_list_cubit.dart';
import '../bloc/market_list_state.dart';
import '../widgets/stock_row.dart';

class MarketScreen extends StatelessWidget {
  const MarketScreen({super.key});

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
              final sortedStocks = List.of(AppConfig.availableStocks);

              sortedStocks.sort((a, b) {
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
                items: sortedStocks,
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
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
