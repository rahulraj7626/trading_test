// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'holding_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HoldingModel _$HoldingModelFromJson(Map<String, dynamic> json) => HoldingModel(
  symbol: json['symbol'] as String,
  quantity: (json['quantity'] as num).toInt(),
  averageCost: (json['averageCost'] as num).toDouble(),
);

Map<String, dynamic> _$HoldingModelToJson(HoldingModel instance) =>
    <String, dynamic>{
      'symbol': instance.symbol,
      'quantity': instance.quantity,
      'averageCost': instance.averageCost,
    };
