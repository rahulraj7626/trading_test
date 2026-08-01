import 'package:json_annotation/json_annotation.dart';
import '../../../../features/trading/domain/entities/order_entity.dart';

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel {
  final String id;
  final String symbol;

  @JsonKey(unknownEnumValue: OrderSide.buy)
  final OrderSide side;

  final int quantity;
  final double price;
  final DateTime timestamp;

  const OrderModel({
    required this.id,
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
    required this.timestamp,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);
  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      symbol: entity.symbol,
      side: entity.side,
      quantity: entity.quantity,
      price: entity.price,
      timestamp: entity.timestamp,
    );
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      symbol: symbol,
      side: side,
      quantity: quantity,
      price: price,
      timestamp: timestamp,
    );
  }
}
