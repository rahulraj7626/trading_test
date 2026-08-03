import 'package:flutter/foundation.dart';
import '../../features/market/domain/entities/stock_tick.dart';
import '../../features/market/presentation/bloc/market_list_state.dart';

class StockSortInput {
  final List<String> symbols;
  final String query;
  final Map<String, StockTick> ticks;
  final MarketSortOption sortOption;
  final bool isAscending;
  final Map<String, String> companyNames;
  final Map<String, double> companyVolumes;

  StockSortInput({
    required this.symbols,
    required this.query,
    required this.ticks,
    required this.sortOption,
    required this.isAscending,
    required this.companyNames,
    required this.companyVolumes,
  });
}

List<String> sortAndFilterStocksIsolate(StockSortInput input) {
  final query = input.query.trim().toLowerCase();
  final filtered = input.symbols.where((symbol) {
    if (query.isEmpty) return true;
    final name = (input.companyNames[symbol] ?? '').toLowerCase();
    return symbol.toLowerCase().contains(query) || name.contains(query);
  }).toList();

  if (input.sortOption == MarketSortOption.none) {
    return filtered;
  }

  filtered.sort((a, b) {
    final tickA = input.ticks[a];
    final tickB = input.ticks[b];

    final pctA = tickA?.changePercent ?? 0.0;
    final pctB = tickB?.changePercent ?? 0.0;

    final volA = input.companyVolumes[a] ?? 0.0;
    final volB = input.companyVolumes[b] ?? 0.0;

    int result = 0;
    switch (input.sortOption) {
      case MarketSortOption.percentage:
        result = pctA.compareTo(pctB);
        break;
      case MarketSortOption.volume:
        result = volA.compareTo(volB);
        break;
      case MarketSortOption.symbol:
      case MarketSortOption.none:
        result = a.compareTo(b);
        break;
    }

    return input.isAscending ? result : -result;
  });

  return filtered;
}

class StockSortUtil {
  static Future<List<String>> sortAndFilter(StockSortInput input) async {
    // Offload to background isolate using compute for smooth UI execution
    return compute(sortAndFilterStocksIsolate, input);
  }
}
