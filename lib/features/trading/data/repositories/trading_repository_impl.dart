import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/error/failures.dart';
import '../../../portfolio/data/models/holding_model.dart';
import '../../../portfolio/domain/entities/holding.dart';
import '../../data/datasources/trading_local_data_source.dart';
import '../../data/models/order_model.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/entities/wallet.dart';
import '../../domain/repositories/trading_repository.dart';

class TradingRepositoryImpl implements TradingRepository {
  final TradingLocalDataSource localDataSource;
  final Uuid uuid = const Uuid();

  TradingRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    try {
      final balance = await localDataSource.getWalletBalance();
      return Right(Wallet(balance: balance));
    } catch (e) {
      return Left(CacheFailure('Failed to get wallet: $e'));
    }
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    try {
      final models = await localDataSource.getOrders();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to get orders: $e'));
    }
  }

  @override
  Future<Either<Failure, List<Holding>>> getHoldings() async {
    try {
      final models = await localDataSource.getHoldings();
      return Right(models.map((e) => e.toEntity()).toList());
    } catch (e) {
      return Left(CacheFailure('Failed to get holdings: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> placeOrder({
    required String symbol,
    required OrderSide side,
    required int quantity,
    required double price,
  }) async {
    if (quantity <= 0) {
      return const Left(ValidationFailure('Quantity must be greater than 0'));
    }

    try {
      final balance = await localDataSource.getWalletBalance();
      final holdings = await localDataSource.getHoldings();
      final orderValue = quantity * price;

      final holdingIndex = holdings.indexWhere((h) => h.symbol == symbol);
      HoldingModel? currentHolding = holdingIndex != -1
          ? holdings[holdingIndex]
          : null;

      if (side == OrderSide.buy) {
        if (orderValue > balance) {
          return const Left(ValidationFailure('Insufficient funds'));
        }

        // Deduct balance
        await localDataSource.saveWalletBalance(balance - orderValue);

        // Update holding
        if (currentHolding != null) {
          final totalCost =
              (currentHolding.quantity * currentHolding.averageCost) +
              orderValue;
          final newQty = currentHolding.quantity + quantity;
          final newAvgCost = totalCost / newQty;

          holdings[holdingIndex] = HoldingModel(
            symbol: symbol,
            quantity: newQty,
            averageCost: newAvgCost,
          );
        } else {
          holdings.add(
            HoldingModel(
              symbol: symbol,
              quantity: quantity,
              averageCost: price,
            ),
          );
        }
      } else {
        // Sell
        if (currentHolding == null || currentHolding.quantity < quantity) {
          return const Left(ValidationFailure('Insufficient holding quantity'));
        }

        // Add balance
        await localDataSource.saveWalletBalance(balance + orderValue);

        // Update holding
        final newQty = currentHolding.quantity - quantity;
        if (newQty == 0) {
          holdings.removeAt(holdingIndex);
        } else {
          holdings[holdingIndex] = HoldingModel(
            symbol: symbol,
            quantity: newQty,
            averageCost: currentHolding.averageCost,
          );
        }
      }

      await localDataSource.saveHoldings(holdings);

      final order = OrderModel(
        id: uuid.v4(),
        symbol: symbol,
        side: side,
        quantity: quantity,
        price: price,
        timestamp: DateTime.now(),
      );
      await localDataSource.saveOrder(order);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to place order: $e'));
    }
  }
}
