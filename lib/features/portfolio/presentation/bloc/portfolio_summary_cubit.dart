import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../market/domain/entities/stock_tick.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../domain/entities/holding.dart';
import 'holdings_cubit.dart';
import 'holdings_state.dart';

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
           ticks: const {},
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
    }

    // Initial ticks sync
    marketRepository.getAllLatestTicks().then((result) {
      result.fold((_) {}, (ticks) {
        _currentTicks = ticks;
        _calculateSummary();
      });
    });
  }

  void _calculateSummary() {
    if (isClosed) return;

    double invested = 0;
    double currentVal = 0;

    for (final holding in _currentHoldings) {
      invested += holding.quantity * holding.averageCost;
      final tick = _currentTicks[holding.symbol];
      if (tick != null) {
        currentVal += holding.quantity * tick.price;
      } else {
        // Fallback if no tick available yet
        currentVal += holding.quantity * holding.averageCost;
      }
    }

    final pnl = currentVal - invested;
    final pnlPercent = invested > 0 ? (pnl / invested) * 100 : 0.0;

    emit(
      PortfolioSummaryState(
        totalInvested: invested,
        currentValue: currentVal,
        totalPnL: pnl,
        totalPnLPercent: pnlPercent,
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
