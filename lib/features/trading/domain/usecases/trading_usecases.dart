import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order_entity.dart';
import '../entities/wallet.dart';
import '../repositories/trading_repository.dart';

class PlaceOrderParams {
  final String symbol;
  final OrderSide side;
  final int quantity;
  final double price;

  const PlaceOrderParams({
    required this.symbol,
    required this.side,
    required this.quantity,
    required this.price,
  });
}

class PlaceOrderUseCase implements UseCase<void, PlaceOrderParams> {
  final TradingRepository repository;

  PlaceOrderUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(PlaceOrderParams params) async {
    return await repository.placeOrder(
      symbol: params.symbol,
      side: params.side,
      quantity: params.quantity,
      price: params.price,
    );
  }
}

class GetWalletUseCase implements UseCase<Wallet, NoParams> {
  final TradingRepository repository;

  GetWalletUseCase(this.repository);

  @override
  Future<Either<Failure, Wallet>> call(NoParams params) async {
    return await repository.getWallet();
  }
}
