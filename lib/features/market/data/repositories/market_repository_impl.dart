import 'dart:async';
import 'dart:math';

import 'package:fpdart/fpdart.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/database/database.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/stock_tick.dart';
import '../../domain/repositories/market_repository.dart';

class MarketRepositoryImpl implements MarketRepository {
  final AppDatabase database;
  Timer? _timer;
  final Random _random = Random();

  // Store base prices in memory to calculate accurate P&L/change
  final Map<String, double> _basePrices = {
    'RELIANCE': 2500.0,
    'TCS': 3500.0,
    'INFY': 1400.0,
    'HDFCBANK': 1600.0,
    'ICICIBANK': 1000.0,
    'SBIN': 600.0,
    'ITC': 450.0,
    'LT': 2700.0,
    'BHARTIARTL': 900.0,
    'AXISBANK': 1000.0,
  };

  MarketRepositoryImpl({required this.database}) {
    _initializeBasePricesInDb();
  }

  Future<void> _initializeBasePricesInDb() async {
    final now = DateTime.now();
    await database.transaction(() async {
      for (var symbol in AppConfig.availableStocks) {
        final existing = await (database.select(
          database.marketTicks,
        )..where((t) => t.symbol.equals(symbol))).getSingleOrNull();

        if (existing == null) {
          final price = _basePrices[symbol] ?? 100.0;
          await database
              .into(database.marketTicks)
              .insert(
                MarketTicksCompanion.insert(
                  symbol: symbol,
                  price: price,
                  change: 0.0,
                  changePercent: 0.0,
                  timestamp: now,
                ),
              );
        }
      }
    });
  }

  @override
  void startFeed() {
    if (_timer != null && _timer!.isActive) return;

    _timer = Timer.periodic(
      const Duration(milliseconds: AppConfig.tickIntervalMs),
      (_) {
        _generateTicks();
      },
    );
  }

  @override
  void stopFeed() {
    _timer?.cancel();
  }

  Future<void> _generateTicks() async {
    final now = DateTime.now();

    // Update 3 to 6 random stocks per tick to simulate realistic market
    final numUpdates = 3 + _random.nextInt(4);
    final stocksToUpdate =
        (AppConfig.availableStocks.toList()..shuffle(_random)).take(numUpdates);

    await database.transaction(() async {
      for (final symbol in stocksToUpdate) {
        final currentTick = await (database.select(
          database.marketTicks,
        )..where((t) => t.symbol.equals(symbol))).getSingleOrNull();

        if (currentTick != null) {
          // New logic: random between 10 and -10
          final priceChange = _random.nextDouble() * 20 - 10;

          final newPrice = currentTick.price + priceChange;
          // Ensure price doesn't go below 0 (edge case)
          final finalPrice = newPrice < 0 ? 0.01 : newPrice;

          final roundedPrice = (finalPrice * 100).roundToDouble() / 100;

          final basePrice = _basePrices[symbol] ?? 100.0;
          final change = roundedPrice - basePrice;
          final changePercent = (change / basePrice) * 100;

          await database
              .update(database.marketTicks)
              .replace(
                MarketTicksCompanion.insert(
                  symbol: symbol,
                  price: roundedPrice,
                  change: (change * 100).roundToDouble() / 100,
                  changePercent: (changePercent * 100).roundToDouble() / 100,
                  timestamp: now,
                ),
              );
        }
      }
    });
  }

  @override
  Stream<StockTick> watchTick(String symbol) {
    return (database.select(
      database.marketTicks,
    )..where((t) => t.symbol.equals(symbol))).watchSingle().map(
      (row) => StockTick(
        symbol: row.symbol,
        price: row.price,
        change: row.change,
        changePercent: row.changePercent,
        timestamp: row.timestamp,
      ),
    );
  }

  @override
  Stream<Map<String, StockTick>> watchAllTicks() {
    return database.select(database.marketTicks).watch().map((rows) {
      return {
        for (var row in rows)
          row.symbol: StockTick(
            symbol: row.symbol,
            price: row.price,
            change: row.change,
            changePercent: row.changePercent,
            timestamp: row.timestamp,
          ),
      };
    });
  }

  @override
  Future<Either<Failure, StockTick>> getLatestTick(String symbol) async {
    try {
      final row = await (database.select(
        database.marketTicks,
      )..where((t) => t.symbol.equals(symbol))).getSingleOrNull();

      if (row != null) {
        return Right(
          StockTick(
            symbol: row.symbol,
            price: row.price,
            change: row.change,
            changePercent: row.changePercent,
            timestamp: row.timestamp,
          ),
        );
      }
      return Left(CacheFailure('Tick not found for $symbol'));
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, Map<String, StockTick>>> getAllLatestTicks() async {
    try {
      final rows = await database.select(database.marketTicks).get();
      final map = {
        for (var row in rows)
          row.symbol: StockTick(
            symbol: row.symbol,
            price: row.price,
            change: row.change,
            changePercent: row.changePercent,
            timestamp: row.timestamp,
          ),
      };
      return Right(map);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
