import 'package:fpdart/fpdart.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../../../trading/domain/repositories/trading_repository.dart';
import '../entities/holding.dart';

class GetHoldingsUseCase implements UseCase<List<Holding>, NoParams> {
  final TradingRepository repository;

  GetHoldingsUseCase(this.repository);

  @override
  Future<Either<Failure, List<Holding>>> call(NoParams params) async {
    return await repository.getHoldings();
  }
}
