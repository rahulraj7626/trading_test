import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../data/datasources/watchlist_local_data_source.dart';
import '../../data/models/watchlist_model.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/repositories/watchlist_repository.dart';

class WatchlistRepositoryImpl implements WatchlistRepository {
  final WatchlistLocalDataSource localDataSource;

  WatchlistRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, List<Watchlist>>> getWatchlists() async {
    try {
      final models = await localDataSource.getWatchlists();
      final entities = models.map((e) => e.toEntity()).toList();
      return Right(entities);
    } catch (e) {
      return Left(CacheFailure('Failed to load watchlists: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveWatchlists(
    List<Watchlist> watchlists,
  ) async {
    try {
      final models = watchlists
          .map((e) => WatchlistModel.fromEntity(e))
          .toList();
      await localDataSource.saveWatchlists(models);
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to save watchlists: $e'));
    }
  }
}
