import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/stock_tick.dart';

abstract class MarketRepository {
  /// Start the background mock feed that writes to DB.
  void startFeed();

  /// Stop the feed.
  void stopFeed();

  /// Stream a specific stock tick from the database.
  Stream<StockTick> watchTick(String symbol);

  /// Stream all latest ticks from the database.
  Stream<Map<String, StockTick>> watchAllTicks();

  /// Get the latest tick synchronously (for initial load if needed).
  Future<Either<Failure, StockTick>> getLatestTick(String symbol);

  /// Get all latest ticks synchronously.
  Future<Either<Failure, Map<String, StockTick>>> getAllLatestTicks();
}
