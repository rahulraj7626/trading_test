import '../../../../core/database/database.dart';
import '../../../../core/config/app_config.dart';
import '../../../portfolio/data/models/holding_model.dart';
import '../models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import 'package:drift/drift.dart';

abstract class TradingLocalDataSource {
  Future<double> getWalletBalance();
  Future<void> saveWalletBalance(double balance);

  Future<List<OrderModel>> getOrders();
  Future<void> saveOrder(OrderModel order);

  Future<List<HoldingModel>> getHoldings();
  Future<void> saveHoldings(List<HoldingModel> holdings);
}

class TradingLocalDataSourceImpl implements TradingLocalDataSource {
  final AppDatabase database;

  TradingLocalDataSourceImpl({required this.database});

  @override
  Future<double> getWalletBalance() async {
    final query = database.select(database.wallet)
      ..where((tbl) => tbl.id.equals(1));
    final result = await query.getSingleOrNull();

    if (result != null) {
      return result.balance;
    }

    // Fallback if not initialized correctly by migrations
    await saveWalletBalance(AppConfig.initialWalletBalance);
    return AppConfig.initialWalletBalance;
  }

  @override
  Future<void> saveWalletBalance(double balance) async {
    await database
        .into(database.wallet)
        .insertOnConflictUpdate(
          WalletCompanion.insert(id: const Value(1), balance: balance),
        );
  }

  @override
  Future<List<OrderModel>> getOrders() async {
    final rows = await database.select(database.orders).get();
    return rows
        .map(
          (row) => OrderModel(
            id: row.id,
            symbol: row.symbol,
            // @JsonKey relies on enum name matching in json parsing,
            // but here we stored as int. So mapping manually:
            side: row.side == 0 ? OrderSide.buy : OrderSide.sell,
            quantity: row.quantity,
            price: row.price,
            timestamp: row.timestamp,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveOrder(OrderModel order) async {
    await database
        .into(database.orders)
        .insert(
          OrdersCompanion.insert(
            id: order.id,
            symbol: order.symbol,
            side: order.side == OrderSide.buy ? 0 : 1,
            quantity: order.quantity,
            price: order.price,
            timestamp: order.timestamp,
          ),
        );
  }

  @override
  Future<List<HoldingModel>> getHoldings() async {
    final rows = await database.select(database.holdings).get();
    return rows
        .map(
          (row) => HoldingModel(
            symbol: row.symbol,
            quantity: row.quantity,
            averageCost: row.averageCost,
          ),
        )
        .toList();
  }

  @override
  Future<void> saveHoldings(List<HoldingModel> holdings) async {
    await database.transaction(() async {
      await database.delete(database.holdings).go();
      for (final h in holdings) {
        await database
            .into(database.holdings)
            .insert(
              HoldingsCompanion.insert(
                symbol: h.symbol,
                quantity: h.quantity,
                averageCost: h.averageCost,
              ),
            );
      }
    });
  }
}
