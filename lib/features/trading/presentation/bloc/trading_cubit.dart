import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/trading_usecases.dart';
import 'trading_state.dart';

class TradingCubit extends Cubit<TradingState> {
  final GetWalletUseCase getWalletUseCase;
  final PlaceOrderUseCase placeOrderUseCase;

  TradingCubit({
    required this.getWalletUseCase,
    required this.placeOrderUseCase,
  }) : super(TradingInitial()) {
    loadWallet();
  }

  Future<void> loadWallet() async {
    emit(TradingLoading());
    final result = await getWalletUseCase(const NoParams());
    result.fold(
      (failure) => emit(TradingError(failure.message)),
      (wallet) => emit(TradingLoaded(wallet: wallet)),
    );
  }

  Future<void> placeOrder({
    required String symbol,
    required OrderSide side,
    required int quantity,
    required double price,
  }) async {
    emit(TradingOrderSubmitting());
    final result = await placeOrderUseCase(
      PlaceOrderParams(
        symbol: symbol,
        side: side,
        quantity: quantity,
        price: price,
      ),
    );

    result.fold(
      (failure) {
        emit(TradingError(failure.message));
        // Reload wallet after error to restore loaded state
        loadWallet();
      },
      (_) {
        emit(TradingOrderSuccess('Order placed successfully'));
        loadWallet();
      },
    );
  }
}
