import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/watchlist.dart';
import '../repositories/watchlist_repository.dart';

class GetWatchlistsUseCase implements UseCase<List<Watchlist>, NoParams> {
  final WatchlistRepository repository;

  GetWatchlistsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Watchlist>>> call(NoParams params) async {
    return await repository.getWatchlists();
  }
}

class SaveWatchlistsUseCase implements UseCase<void, List<Watchlist>> {
  final WatchlistRepository repository;

  SaveWatchlistsUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(List<Watchlist> watchlists) async {
    return await repository.saveWatchlists(watchlists);
  }
}
