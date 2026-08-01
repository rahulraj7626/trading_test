import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../portfolio/domain/entities/holding.dart';
import '../entities/order_entity.dart';
import '../entities/wallet.dart';

abstract class TradingRepository {
  Future<Either<Failure, Wallet>> getWallet();
  Future<Either<Failure, List<OrderEntity>>> getOrders();
  Future<Either<Failure, List<Holding>>> getHoldings();

  Future<Either<Failure, void>> placeOrder({
    required String symbol,
    required OrderSide side,
    required int quantity,
    required double price,
  });
}
