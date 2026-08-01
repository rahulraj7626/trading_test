import 'dart:convert';
import '../../../../core/database/database.dart';
import '../models/watchlist_model.dart';
import 'package:drift/drift.dart';

abstract class WatchlistLocalDataSource {
  Future<List<WatchlistModel>> getWatchlists();
  Future<void> saveWatchlists(List<WatchlistModel> watchlists);
}

class WatchlistLocalDataSourceImpl implements WatchlistLocalDataSource {
  final AppDatabase database;

  WatchlistLocalDataSourceImpl({required this.database});

  @override
  Future<List<WatchlistModel>> getWatchlists() async {
    final rows = await database.select(database.watchlists).get();

    if (rows.isNotEmpty) {
      return rows.map((row) {
        final List<dynamic> symbolsJson = json.decode(row.symbols);
        return WatchlistModel(
          id: row.id,
          name: row.name,
          symbols: symbolsJson.map((e) => e as String).toList(),
        );
      }).toList();
    }

    // Default initial watchlist if empty
    return [
      const WatchlistModel(id: 'default_1', name: 'My Watchlist', symbols: []),
    ];
  }

  @override
  Future<void> saveWatchlists(List<WatchlistModel> models) async {
    await database.transaction(() async {
      // Clear existing and replace
      await database.delete(database.watchlists).go();

      for (final model in models) {
        await database
            .into(database.watchlists)
            .insert(
              WatchlistsCompanion.insert(
                id: model.id,
                name: model.name,
                symbols: json.encode(model.symbols),
              ),
            );
      }
    });
  }
}
