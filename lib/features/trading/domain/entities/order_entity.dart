import 'package:equatable/equatable.dart';

enum OrderSide { buy, sell }

class OrderEntity extends Equatable {
  final String id;
  final String symbol;
  final OrderSide side;
  final int quantity;
  final double price;
  final DateTime timestamp;

  const OrderEntity({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [id, symbol, side, quantity, price, timestamp];
}
