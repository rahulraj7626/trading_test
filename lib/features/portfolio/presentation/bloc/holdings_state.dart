import 'package:equatable/equatable.dart';
import '../../domain/entities/holding.dart';

enum HoldingsSortOption { pnl, symbol, value }

abstract class HoldingsState extends Equatable {
  const HoldingsState();

  @override
  List<Object?> get props => [];
}

class HoldingsInitial extends HoldingsState {}

class HoldingsLoading extends HoldingsState {}

class HoldingsLoaded extends HoldingsState {
  final List<Holding> holdings;
  final HoldingsSortOption sortOption;

  const HoldingsLoaded({
    required this.holdings,
    this.sortOption = HoldingsSortOption.pnl,
  });

  HoldingsLoaded copyWith({
    List<Holding>? holdings,
    HoldingsSortOption? sortOption,
  }) {
    return HoldingsLoaded(
      holdings: holdings ?? this.holdings,
      sortOption: sortOption ?? this.sortOption,
    );
  }

  @override
  List<Object?> get props => [holdings, sortOption];
}

class HoldingsError extends HoldingsState {
  final String message;

  const HoldingsError(this.message);

  @override
  List<Object?> get props => [message];
}
