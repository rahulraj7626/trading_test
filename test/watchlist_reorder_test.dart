import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:trading/core/error/failures.dart';
import 'package:trading/features/watchlist/domain/entities/watchlist.dart';
import 'package:trading/features/watchlist/domain/repositories/watchlist_repository.dart';
import 'package:trading/features/watchlist/domain/usecases/watchlist_usecases.dart';
import 'package:trading/features/watchlist/presentation/bloc/watchlist_cubit.dart';
import 'package:trading/features/watchlist/presentation/bloc/watchlist_state.dart';

class FakeWatchlistRepository implements WatchlistRepository {
  List<Watchlist> data = [];

  @override
  Future<Either<Failure, List<Watchlist>>> getWatchlists() async {
    return Right(data);
  }

  @override
  Future<Either<Failure, void>> saveWatchlists(List<Watchlist> watchlists) async {
    data = List.from(watchlists);
    return const Right(null);
  }
}

void main() {
  late FakeWatchlistRepository repository;
  late GetWatchlistsUseCase getWatchlistsUseCase;
  late SaveWatchlistsUseCase saveWatchlistsUseCase;
  late WatchlistCubit cubit;

  setUp(() {
    repository = FakeWatchlistRepository();
    repository.data = [
      const Watchlist(
        id: 'w1',
        name: 'My Watchlist',
        symbols: ['AAPL', 'GOOGL', 'MSFT', 'TSLA'],
      ),
    ];

    getWatchlistsUseCase = GetWatchlistsUseCase(repository);
    saveWatchlistsUseCase = SaveWatchlistsUseCase(repository);
    cubit = WatchlistCubit(
      getWatchlistsUseCase: getWatchlistsUseCase,
      saveWatchlistsUseCase: saveWatchlistsUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  test('reorderStocks moves item from oldIndex to newIndex', () async {
    await pumpEventQueue();
    expect(cubit.state, isA<WatchlistLoaded>());

    // Move 'TSLA' (index 3) to top (index 0)
    cubit.reorderStocks('w1', 3, 0);
    await pumpEventQueue();

    final state = cubit.state as WatchlistLoaded;
    expect(state.selectedWatchlist?.symbols, ['TSLA', 'AAPL', 'GOOGL', 'MSFT']);
    expect(repository.data.first.symbols, ['TSLA', 'AAPL', 'GOOGL', 'MSFT']);
  });

  test('reorderStocks with currentDisplaySymbols handles custom ordering', () async {
    await pumpEventQueue();

    // Display symbols sorted differently e.g. ['MSFT', 'AAPL', 'TSLA', 'GOOGL']
    final displaySymbols = ['MSFT', 'AAPL', 'TSLA', 'GOOGL'];

    // Move 'TSLA' (index 2 in displaySymbols) to index 0
    cubit.reorderStocks('w1', 2, 0, currentDisplaySymbols: displaySymbols);
    await pumpEventQueue();

    final state = cubit.state as WatchlistLoaded;
    expect(state.selectedWatchlist?.symbols, ['TSLA', 'MSFT', 'AAPL', 'GOOGL']);
  });
}
