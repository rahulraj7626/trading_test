import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trading/core/error/failures.dart';
import 'package:trading/features/market/domain/entities/stock_tick.dart';
import 'package:trading/features/market/domain/repositories/market_repository.dart';
import 'package:trading/features/portfolio/domain/entities/holding.dart';
import 'package:trading/features/portfolio/domain/usecases/portfolio_usecases.dart';
import 'package:trading/features/portfolio/presentation/bloc/holdings_cubit.dart';
import 'package:trading/features/portfolio/presentation/bloc/portfolio_summary_cubit.dart';
import 'package:trading/features/trading/domain/entities/order_entity.dart';
import 'package:trading/features/trading/domain/entities/wallet.dart';
import 'package:trading/features/trading/domain/repositories/trading_repository.dart';

class FakeTradingRepository implements TradingRepository {
  List<Holding> holdingsList = [];

  @override
  Future<Either<Failure, List<Holding>>> getHoldings() async {
    return Right(holdingsList);
  }

  @override
  Future<Either<Failure, Wallet>> getWallet() async {
    return const Right(Wallet(balance: 100000.0));
  }

  @override
  Future<Either<Failure, List<OrderEntity>>> getOrders() async {
    return const Right([]);
  }

  @override
  Future<Either<Failure, void>> placeOrder({
    required String symbol,
    required OrderSide side,
    required int quantity,
    required double price,
  }) async {
    return const Right(null);
  }
}

class FakeMarketRepository implements MarketRepository {
  final _controller = StreamController<Map<String, StockTick>>.broadcast();

  @override
  Stream<Map<String, StockTick>> watchAllTicks() => _controller.stream;

  @override
  Stream<StockTick> watchTick(String symbol) => const Stream.empty();

  @override
  Future<Either<Failure, Map<String, StockTick>>> getAllLatestTicks() async {
    return const Right({});
  }

  @override
  Future<Either<Failure, StockTick>> getLatestTick(String symbol) async {
    return Left(CacheFailure('Not found'));
  }

  @override
  Future<void> startFeed() async {}

  @override
  Future<void> stopFeed() async {}

  void emitTicks(Map<String, StockTick> ticks) {
    _controller.add(ticks);
  }
}

void main() {
  late FakeTradingRepository tradingRepository;
  late FakeMarketRepository marketRepository;
  late GetHoldingsUseCase getHoldingsUseCase;
  late HoldingsCubit holdingsCubit;
  late PortfolioSummaryCubit summaryCubit;

  setUp(() {
    tradingRepository = FakeTradingRepository();
    marketRepository = FakeMarketRepository();
    getHoldingsUseCase = GetHoldingsUseCase(tradingRepository);

    holdingsCubit = HoldingsCubit(getHoldingsUseCase: getHoldingsUseCase);
    summaryCubit = PortfolioSummaryCubit(
      marketRepository: marketRepository,
      holdingsCubit: holdingsCubit,
    );
  });

  tearDown(() {
    summaryCubit.close();
    holdingsCubit.close();
  });

  test('PortfolioSummaryCubit updates currentValue instantly when holdings reload', () async {
    await pumpEventQueue();

    // Initially 0
    expect(summaryCubit.state.currentValue, 0);

    // Simulate buying a stock for the first time
    tradingRepository.holdingsList = [
      const Holding(symbol: 'RELIANCE', quantity: 10, averageCost: 2500.0),
    ];

    // Reload holdings on shared HoldingsCubit
    await holdingsCubit.loadHoldings();
    await pumpEventQueue();

    // Verify currentValue and invested are non-zero instantly
    expect(summaryCubit.state.totalInvested, 25000.0);
    expect(summaryCubit.state.currentValue, 25000.0);
  });
}
