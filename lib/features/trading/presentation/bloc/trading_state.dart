import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet.dart';

abstract class TradingState extends Equatable {
  const TradingState();

  @override
  List<Object?> get props => [];
}

class TradingInitial extends TradingState {}

class TradingLoading extends TradingState {}

class TradingLoaded extends TradingState {
  final Wallet wallet;

  const TradingLoaded({required this.wallet});

  @override
  List<Object?> get props => [wallet];
}

class TradingOrderSubmitting extends TradingState {}

class TradingOrderSuccess extends TradingState {
  final String message;

  const TradingOrderSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class TradingError extends TradingState {
  final String message;

  const TradingError(this.message);

  @override
  List<Object?> get props => [message];
}
