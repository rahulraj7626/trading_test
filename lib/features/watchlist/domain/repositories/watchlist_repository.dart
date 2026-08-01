import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../entities/watchlist.dart';

abstract class WatchlistRepository {
  Future<Either<Failure, List<Watchlist>>> getWatchlists();
  Future<Either<Failure, void>> saveWatchlists(List<Watchlist> watchlists);
}
