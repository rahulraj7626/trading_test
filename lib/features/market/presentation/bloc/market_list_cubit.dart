import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/market_repository.dart';
import 'market_list_state.dart';

class MarketListCubit extends Cubit<MarketListState> {
  final MarketRepository marketRepository;
  StreamSubscription? _subscription;

  MarketListCubit({required this.marketRepository})
    : super(MarketListLoading()) {
    _subscription = marketRepository.watchAllTicks().listen((ticks) {
      if (state is MarketListLoaded) {
        emit((state as MarketListLoaded).copyWith(ticks: ticks));
      } else {
        emit(MarketListLoaded(ticks: ticks));
      }
    });
  }

  void updateSearchQuery(String query) {
    if (state is MarketListLoaded) {
      emit((state as MarketListLoaded).copyWith(searchQuery: query));
    }
  }

  void updateSortOption(MarketSortOption option) {
    if (state is MarketListLoaded) {
      final currentState = state as MarketListLoaded;
      if (currentState.sortOption == option) {
        // Toggle ascending/descending
        emit(currentState.copyWith(isAscending: !currentState.isAscending));
      } else {
        // Change option, default to descending for volume/percent, ascending for symbol
        final defaultAscending = option == MarketSortOption.symbol;
        emit(
          currentState.copyWith(
            sortOption: option,
            isAscending: defaultAscending,
          ),
        );
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
