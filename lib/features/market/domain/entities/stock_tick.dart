import 'package:equatable/equatable.dart';

class StockTick extends Equatable {
  final String symbol;
  final double price;
  final double change;
  final double changePercent;
  final DateTime timestamp;

  const StockTick({
    required this.symbol,
    required this.price,
    required this.change,
    required this.changePercent,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [symbol, price, change, changePercent, timestamp];
}
