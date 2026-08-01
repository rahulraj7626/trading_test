import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/stock_tick.dart';
import '../../domain/repositories/market_repository.dart';
import 'live_price_state.dart';

class LivePriceCubit extends Cubit<LivePriceState> {
  final MarketRepository _marketRepository;
  final String symbol;
  StreamSubscription<StockTick>? _subscription;

  LivePriceCubit({
    required MarketRepository marketRepository,
    required this.symbol,
  }) : _marketRepository = marketRepository,
       super(LivePriceInitial()) {
    _init();
  }

  Future<void> _init() async {
    emit(LivePriceLoading());

    // Subscribe to Drift watch stream for live updates
    _subscription = _marketRepository.watchTick(symbol).listen((newTick) {
      if (isClosed) return;

      if (state is LivePriceLoaded) {
        final currentState = state as LivePriceLoaded;
        if (currentState.tick.price != newTick.price) {
          final isUpTick = newTick.price > currentState.tick.price;
          emit(
            LivePriceLoaded(
              tick: newTick,
              isUpTick: isUpTick,
              flashTimestamp: DateTime.now(),
            ),
          );
        }
      } else {
        emit(
          LivePriceLoaded(
            tick: newTick,
            isUpTick: true,
            flashTimestamp: DateTime.now(),
          ),
        );
      }
    });
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
