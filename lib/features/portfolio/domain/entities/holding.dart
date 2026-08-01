import 'package:equatable/equatable.dart';

class Holding extends Equatable {
  final String symbol;
  final int quantity;
  final double averageCost;

  const Holding({
    required this.symbol,
    required this.quantity,
    required this.averageCost,
  });

  Holding copyWith({String? symbol, int? quantity, double? averageCost}) {
    return Holding(
      symbol: symbol ?? this.symbol,
      quantity: quantity ?? this.quantity,
      averageCost: averageCost ?? this.averageCost,
    );
  }

  @override
  List<Object?> get props => [symbol, quantity, averageCost];
}
