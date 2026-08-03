import 'package:flutter_test/flutter_test.dart';
import 'package:trading/core/utils/stock_sort_util.dart';
import 'package:trading/features/market/domain/entities/stock_tick.dart';
import 'package:trading/features/market/presentation/bloc/market_list_state.dart';

void main() {
  group('StockSortUtil', () {
    test('sortAndFilter via compute isolates filters and sorts by symbol', () async {
      final input = StockSortInput(
        symbols: ['TCS', 'RELIANCE', 'INFY'],
        query: '',
        ticks: {},
        sortOption: MarketSortOption.symbol,
        isAscending: true,
        companyNames: {'RELIANCE': 'Reliance', 'TCS': 'TCS', 'INFY': 'Infosys'},
        companyVolumes: {},
      );

      final result = await StockSortUtil.sortAndFilter(input);
      expect(result, ['INFY', 'RELIANCE', 'TCS']);
    });

    test('sortAndFilter filters query correctly in isolate', () async {
      final input = StockSortInput(
        symbols: ['TCS', 'RELIANCE', 'INFY'],
        query: 'info',
        ticks: {},
        sortOption: MarketSortOption.none,
        isAscending: true,
        companyNames: {'RELIANCE': 'Reliance', 'TCS': 'TCS', 'INFY': 'Infosys'},
        companyVolumes: {},
      );

      final result = await StockSortUtil.sortAndFilter(input);
      expect(result, ['INFY']);
    });

    test('sortAndFilter sorts by percentage in isolate', () async {
      final ticks = {
        'RELIANCE': StockTick(
          symbol: 'RELIANCE',
          price: 2500,
          change: 50,
          changePercent: 2.0,
          timestamp: DateTime.now(),
        ),
        'TCS': StockTick(
          symbol: 'TCS',
          price: 3500,
          change: 175,
          changePercent: 5.0,
          timestamp: DateTime.now(),
        ),
        'INFY': StockTick(
          symbol: 'INFY',
          price: 1400,
          change: -14,
          changePercent: -1.0,
          timestamp: DateTime.now(),
        ),
      };

      final input = StockSortInput(
        symbols: ['TCS', 'RELIANCE', 'INFY'],
        query: '',
        ticks: ticks,
        sortOption: MarketSortOption.percentage,
        isAscending: false,
        companyNames: {},
        companyVolumes: {},
      );

      final result = await StockSortUtil.sortAndFilter(input);
      expect(result, ['TCS', 'RELIANCE', 'INFY']);
    });
  });
}
