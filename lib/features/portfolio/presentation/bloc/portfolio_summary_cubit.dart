import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../market/domain/entities/stock_tick.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../domain/entities/holding.dart';
import 'holdings_cubit.dart';
import 'holdings_state.dart';

class _PortfolioCalculationInput {
  final List<Holding> holdings;
  final Map<String, StockTick> ticks;

  _PortfolioCalculationInput(this.holdings, this.ticks);
}

class _PortfolioCalculationResult {
  final double totalInvested;
  final double currentValue;
  final double totalPnL;
  final double totalPnLPercent;

  _PortfolioCalculationResult({
    required this.totalInvested,
    required this.currentValue,
    required this.totalPnL,
    required this.totalPnLPercent,
  });
}

_PortfolioCalculationResult _calculatePortfolioSummaryInIsolate(
  _PortfolioCalculationInput input,
) {
  double invested = 0;
  double currentVal = 0;

  for (final holding in input.holdings) {
    invested += holding.quantity * holding.averageCost;
    final tick = input.ticks[holding.symbol];
    if (tick != null) {
      currentVal += holding.quantity * tick.price;
    } else {
      // Fallback if no tick available yet
      currentVal += holding.quantity * holding.averageCost;
    }
  }

  final pnl = currentVal - invested;
  final pnlPercent = invested > 0 ? (pnl / invested) * 100 : 0.0;

  return _PortfolioCalculationResult(
    totalInvested: invested,
    currentValue: currentVal,
    totalPnL: pnl,
    totalPnLPercent: pnlPercent,
  );
}

class PortfolioSummaryState extends Equatable {
  final double totalInvested;
  final double currentValue;
  final double totalPnL;
  final double totalPnLPercent;
  final Map<String, StockTick> ticks;

  const PortfolioSummaryState({
    required this.totalInvested,
    required this.currentValue,
    required this.totalPnL,
    required this.totalPnLPercent,
    required this.ticks,
  });

  @override
  List<Object?> get props => [
    totalInvested,
    currentValue,
    totalPnL,
    totalPnLPercent,
    ticks,
  ];
}

class PortfolioSummaryCubit extends Cubit<PortfolioSummaryState> {
  final MarketRepository marketRepository;
  final HoldingsCubit holdingsCubit;

  StreamSubscription<Map<String, StockTick>>? _marketSub;
  StreamSubscription<HoldingsState>? _holdingsSub;

  List<Holding> _currentHoldings = [];
  Map<String, StockTick> _currentTicks = {};

  PortfolioSummaryCubit({
    required this.marketRepository,
    required this.holdingsCubit,
  }) : super(
         const PortfolioSummaryState(
           totalInvested: 0,
           currentValue: 0,
           totalPnL: 0,
           totalPnLPercent: 0,
           ticks: {},
         ),
       ) {
    _init();
  }

  void _init() {
    _holdingsSub = holdingsCubit.stream.listen((state) {
      if (state is HoldingsLoaded) {
        _currentHoldings = state.holdings;
        _calculateSummary();
      }
    });

    _marketSub = marketRepository.watchAllTicks().listen((ticks) {
      _currentTicks = ticks;
      _calculateSummary();
    });

    // Handle initial state if already loaded
    if (holdingsCubit.state is HoldingsLoaded) {
      _currentHoldings = (holdingsCubit.state as HoldingsLoaded).holdings;
      _calculateSummary();
    }

    // Initial ticks sync
    marketRepository.getAllLatestTicks().then((result) {
      result.fold((_) {}, (ticks) {
        _currentTicks = ticks;
        _calculateSummary();
      });
    });
  }

  Future<void> _calculateSummary() async {
    if (isClosed) return;

    final result = await compute(
      _calculatePortfolioSummaryInIsolate,
      _PortfolioCalculationInput(_currentHoldings, _currentTicks),
    );

    if (isClosed) return;

    emit(
      PortfolioSummaryState(
        totalInvested: result.totalInvested,
        currentValue: result.currentValue,
        totalPnL: result.totalPnL,
        totalPnLPercent: result.totalPnLPercent,
        ticks: _currentTicks,
      ),
    );
  }

  @override
  Future<void> close() {
    _marketSub?.cancel();
    _holdingsSub?.cancel();
    return super.close();
  }
}
