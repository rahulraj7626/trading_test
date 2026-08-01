import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/watchlist.dart';

part 'watchlist_model.g.dart';

@JsonSerializable()
class WatchlistModel {
  final String id;
  final String name;
  final List<String> symbols;

  const WatchlistModel({
    required this.id,
    required this.name,
    required this.symbols,
  });

  factory WatchlistModel.fromJson(Map<String, dynamic> json) =>
      _$WatchlistModelFromJson(json);
  Map<String, dynamic> toJson() => _$WatchlistModelToJson(this);

  factory WatchlistModel.fromEntity(Watchlist entity) {
    return WatchlistModel(
      id: entity.id,
      name: entity.name,
      symbols: entity.symbols,
    );
  }

  Watchlist toEntity() {
    return Watchlist(id: id, name: name, symbols: symbols);
  }
}
