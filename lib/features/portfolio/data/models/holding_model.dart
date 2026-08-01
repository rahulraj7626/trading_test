import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/holding.dart';

part 'holding_model.g.dart';

@JsonSerializable()
class HoldingModel {
  final String symbol;
  final int quantity;
  final double averageCost;

  const HoldingModel({
    required this.symbol,
    required this.quantity,
    required this.averageCost,
  });

  factory HoldingModel.fromJson(Map<String, dynamic> json) =>
      _$HoldingModelFromJson(json);
  Map<String, dynamic> toJson() => _$HoldingModelToJson(this);

  factory HoldingModel.fromEntity(Holding entity) {
    return HoldingModel(
      symbol: entity.symbol,
      quantity: entity.quantity,
      averageCost: entity.averageCost,
    );
  }

  Holding toEntity() {
    return Holding(
      symbol: symbol,
      quantity: quantity,
      averageCost: averageCost,
    );
  }
}
