import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/watchlist.dart';
import '../../domain/usecases/watchlist_usecases.dart';
import 'watchlist_state.dart';

class WatchlistCubit extends Cubit<WatchlistState> {
  final GetWatchlistsUseCase getWatchlistsUseCase;
  final SaveWatchlistsUseCase saveWatchlistsUseCase;
  final Uuid uuid = const Uuid();

  WatchlistCubit({
    required this.getWatchlistsUseCase,
    required this.saveWatchlistsUseCase,
  }) : super(WatchlistInitial()) {
    loadWatchlists();
  }

  Future<void> loadWatchlists() async {
    emit(WatchlistLoading());
    final result = await getWatchlistsUseCase(const NoParams());

    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (watchlists) => emit(WatchlistLoaded(watchlists: watchlists)),
    );
  }

  Future<void> _save(List<Watchlist> watchlists, int selectedIndex) async {
    final result = await saveWatchlistsUseCase(watchlists);
    result.fold(
      (failure) => emit(WatchlistError(failure.message)),
      (_) => emit(
        WatchlistLoaded(watchlists: watchlists, selectedIndex: selectedIndex),
      ),
    );
  }

  void selectWatchlist(int index) {
    if (state is WatchlistLoaded) {
      emit((state as WatchlistLoaded).copyWith(selectedIndex: index));
    }
  }

  void addWatchlist(String name) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      if (current.watchlists.length >= 10) return;
      final newList = List<Watchlist>.from(current.watchlists);
      final newWatchlist = Watchlist(id: uuid.v4(), name: name);
      newList.add(newWatchlist);
      _save(newList, newList.length - 1);
    }
  }

  void deleteWatchlist(String id) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      if (current.watchlists.length <= 1) return;
      final newList = current.watchlists.where((w) => w.id != id).toList();
      final newIndex = current.selectedIndex >= newList.length
          ? (newList.length - 1 >= 0 ? newList.length - 1 : 0)
          : current.selectedIndex;
      _save(newList, newIndex);
    }
  }

  void addStockToWatchlist(String watchlistId, String symbol) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      final index = current.watchlists.indexWhere((w) => w.id == watchlistId);
      if (index != -1) {
        final watchlist = current.watchlists[index];
        if (!watchlist.symbols.contains(symbol)) {
          final newSymbols = List<String>.from(watchlist.symbols)..add(symbol);
          final updatedWatchlist = watchlist.copyWith(symbols: newSymbols);
          final newList = List<Watchlist>.from(current.watchlists)
            ..[index] = updatedWatchlist;
          _save(newList, current.selectedIndex);
        }
      }
    }
  }

  void removeStockFromWatchlist(String watchlistId, String symbol) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      final index = current.watchlists.indexWhere((w) => w.id == watchlistId);
      if (index != -1) {
        final watchlist = current.watchlists[index];
        final newSymbols = List<String>.from(watchlist.symbols)..remove(symbol);
        final updatedWatchlist = watchlist.copyWith(symbols: newSymbols);
        final newList = List<Watchlist>.from(current.watchlists)
          ..[index] = updatedWatchlist;
        _save(newList, current.selectedIndex);
      }
    }
  }

  void reorderStocks(String watchlistId, int oldIndex, int newIndex) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      final index = current.watchlists.indexWhere((w) => w.id == watchlistId);
      if (index != -1) {
        final watchlist = current.watchlists[index];
        final newSymbols = List<String>.from(watchlist.symbols);

        if (oldIndex < newIndex) {
          newIndex -= 1;
        }
        final symbol = newSymbols.removeAt(oldIndex);
        newSymbols.insert(newIndex, symbol);

        final updatedWatchlist = watchlist.copyWith(symbols: newSymbols);
        final newList = List<Watchlist>.from(current.watchlists)
          ..[index] = updatedWatchlist;
        _save(newList, current.selectedIndex);
      }
    }
  }

  void toggleFavorite(String symbol) {
    if (state is WatchlistLoaded) {
      final current = state as WatchlistLoaded;
      final selected = current.selectedWatchlist;
      if (selected != null) {
        if (selected.symbols.contains(symbol)) {
          removeStockFromWatchlist(selected.id, symbol);
        } else {
          addStockToWatchlist(selected.id, symbol);
        }
      }
    }
  }
}
