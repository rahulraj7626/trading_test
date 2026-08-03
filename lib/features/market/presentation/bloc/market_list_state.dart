import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_tick.dart';

enum MarketSortOption { none, symbol, percentage, volume }

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
  final String searchQuery;

  const MarketListLoaded({
    required this.ticks,
    this.sortOption = MarketSortOption.none,
    this.isAscending = true,
    this.searchQuery = '',
  });

  MarketListLoaded copyWith({
    Map<String, StockTick>? ticks,
    MarketSortOption? sortOption,
    bool? isAscending,
    String? searchQuery,
  }) {
    return MarketListLoaded(
      ticks: ticks ?? this.ticks,
      sortOption: sortOption ?? this.sortOption,
      isAscending: isAscending ?? this.isAscending,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [ticks, sortOption, isAscending, searchQuery];
}
