import 'package:get_it/get_it.dart';

import '../../features/market/data/repositories/market_repository_impl.dart';
// Market
import '../../features/market/domain/repositories/market_repository.dart';
import '../../features/market/presentation/bloc/live_price_cubit.dart';
import '../../features/market/presentation/bloc/market_list_cubit.dart';
// Portfolio
import '../../features/portfolio/domain/usecases/portfolio_usecases.dart';
import '../../features/portfolio/presentation/bloc/holdings_cubit.dart';
import '../../features/portfolio/presentation/bloc/portfolio_summary_cubit.dart';
import '../../features/trading/data/datasources/trading_local_data_source.dart';
import '../../features/trading/data/repositories/trading_repository_impl.dart';
import '../../features/trading/domain/repositories/trading_repository.dart';
import '../../features/trading/domain/usecases/trading_usecases.dart';
import '../../features/trading/presentation/bloc/trading_cubit.dart';
// Watchlist
import '../../features/watchlist/data/datasources/watchlist_local_data_source.dart';
import '../../features/watchlist/data/repositories/watchlist_repository_impl.dart';
import '../../features/watchlist/domain/repositories/watchlist_repository.dart';
import '../../features/watchlist/domain/usecases/watchlist_usecases.dart';
import '../../features/watchlist/presentation/bloc/watchlist_cubit.dart';
import '../database/database.dart';

final getIt = GetIt.instance;

Future<void> initInjection() async {
  // External
  final database = AppDatabase();
  getIt.registerLazySingleton(() => database);

  // Market
  getIt.registerLazySingleton<MarketRepository>(
    () => MarketRepositoryImpl(database: getIt()),
  );

  // Watchlist
  getIt.registerLazySingleton<WatchlistLocalDataSource>(
    () => WatchlistLocalDataSourceImpl(database: getIt()),
  );
  getIt.registerLazySingleton<WatchlistRepository>(
    () => WatchlistRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetWatchlistsUseCase(getIt()));
  getIt.registerLazySingleton(() => SaveWatchlistsUseCase(getIt()));
  getIt.registerFactory(
    () => WatchlistCubit(
      getWatchlistsUseCase: getIt(),
      saveWatchlistsUseCase: getIt(),
    ),
  );

  // Trading
  getIt.registerLazySingleton<TradingLocalDataSource>(
    () => TradingLocalDataSourceImpl(database: getIt()),
  );
  getIt.registerLazySingleton<TradingRepository>(
    () => TradingRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton(() => GetWalletUseCase(getIt()));
  getIt.registerLazySingleton(() => PlaceOrderUseCase(getIt()));
  getIt.registerFactory(
    () => LivePriceCubit(marketRepository: getIt(), symbol: ''),
  );
  getIt.registerFactory(() => MarketListCubit(marketRepository: getIt()));
  getIt.registerFactory(
    () => TradingCubit(getWalletUseCase: getIt(), placeOrderUseCase: getIt()),
  );

  // Portfolio
  getIt.registerLazySingleton(() => GetHoldingsUseCase(getIt()));
  getIt.registerLazySingleton(
    () => HoldingsCubit(getHoldingsUseCase: getIt()),
  );
  getIt.registerLazySingleton(
    () => PortfolioSummaryCubit(
      marketRepository: getIt(),
      holdingsCubit: getIt(),
    ),
  );
}
