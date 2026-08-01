// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WatchlistModel _$WatchlistModelFromJson(Map<String, dynamic> json) =>
    WatchlistModel(
      id: json['id'] as String,
      name: json['name'] as String,
      symbols: (json['symbols'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$WatchlistModelToJson(WatchlistModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'symbols': instance.symbols,
    };
