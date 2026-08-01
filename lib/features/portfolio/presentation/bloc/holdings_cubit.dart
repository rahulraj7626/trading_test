import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/portfolio_usecases.dart';
import 'holdings_state.dart';

class HoldingsCubit extends Cubit<HoldingsState> {
  final GetHoldingsUseCase getHoldingsUseCase;

  HoldingsCubit({required this.getHoldingsUseCase}) : super(HoldingsInitial()) {
    loadHoldings();
  }

  Future<void> loadHoldings() async {
    emit(HoldingsLoading());
    final result = await getHoldingsUseCase(const NoParams());

    result.fold(
      (failure) => emit(HoldingsError(failure.message)),
      (holdings) => emit(HoldingsLoaded(holdings: holdings)),
    );
  }

  void updateSortOption(HoldingsSortOption option) {
    if (state is HoldingsLoaded) {
      emit((state as HoldingsLoaded).copyWith(sortOption: option));
    }
  }
}
