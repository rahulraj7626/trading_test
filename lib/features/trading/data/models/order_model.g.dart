// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
  id: json['id'] as String,
  symbol: json['symbol'] as String,
  side: $enumDecode(
    _$OrderSideEnumMap,
    json['side'],
    unknownValue: OrderSide.buy,
  ),
  quantity: (json['quantity'] as num).toInt(),
  price: (json['price'] as num).toDouble(),
  timestamp: DateTime.parse(json['timestamp'] as String),
);

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'symbol': instance.symbol,
      'side': _$OrderSideEnumMap[instance.side]!,
      'quantity': instance.quantity,
      'price': instance.price,
      'timestamp': instance.timestamp.toIso8601String(),
    };

const _$OrderSideEnumMap = {OrderSide.buy: 'buy', OrderSide.sell: 'sell'};
