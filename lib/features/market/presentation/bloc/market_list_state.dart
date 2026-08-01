import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_tick.dart';

enum MarketSortOption { symbol, percentage, volume }

abstract class MarketListState extends Equatable {
  const MarketListState();

  @override
  List<Object?> get props => [];
}

class MarketListLoading extends MarketListState {}

class MarketListLoaded extends MarketListState {
  final Map<String, StockTick> ticks;
  final MarketSortOption sortOption;
  final bool isAscending;

  const MarketListLoaded({
    required this.ticks,
    this.sortOption = MarketSortOption.symbol,
    this.isAscending = true,
  });

  MarketListLoaded copyWith({
    Map<String, StockTick>? ticks,
    MarketSortOption? sortOption,
    bool? isAscending,
  }) {
    return MarketListLoaded(
      ticks: ticks ?? this.ticks,
      sortOption: sortOption ?? this.sortOption,
      isAscending: isAscending ?? this.isAscending,
    );
  }

  @override
  List<Object?> get props => [ticks, sortOption, isAscending];
}
