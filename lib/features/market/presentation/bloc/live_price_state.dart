import 'package:equatable/equatable.dart';
import '../../domain/entities/stock_tick.dart';

abstract class LivePriceState extends Equatable {
  const LivePriceState();

  @override
  List<Object?> get props => [];
}

class LivePriceInitial extends LivePriceState {}

class LivePriceLoading extends LivePriceState {}

class LivePriceLoaded extends LivePriceState {
  final StockTick tick;
  final bool isUpTick;
  final DateTime flashTimestamp;

  const LivePriceLoaded({
    required this.tick,
    required this.isUpTick,
    required this.flashTimestamp,
  });

  @override
  List<Object?> get props => [tick, isUpTick, flashTimestamp];
}

class LivePriceError extends LivePriceState {
  final String message;

  const LivePriceError(this.message);

  @override
  List<Object?> get props => [message];
}
