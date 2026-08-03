import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../config/theme/app_colors.dart';
import '../di/injection.dart';
import '../../features/portfolio/presentation/bloc/holdings_cubit.dart';
import '../../features/portfolio/presentation/bloc/portfolio_summary_cubit.dart';
import '../../features/watchlist/presentation/bloc/watchlist_cubit.dart';
import 'router.dart';

class TradingApp extends StatelessWidget {
  const TradingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<WatchlistCubit>()),
        BlocProvider(create: (_) => getIt<HoldingsCubit>()),
        BlocProvider(create: (_) => getIt<PortfolioSummaryCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Trading App',
        theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: AppColors.background,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            surface: AppColors.surface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.surface,
            elevation: 0,
          ),
          bottomNavigationBarTheme: const BottomNavigationBarThemeData(
            backgroundColor: AppColors.surface,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: Colors.grey,
            selectedLabelStyle: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: TextStyle(fontSize: 12),
          ),
          snackBarTheme: SnackBarThemeData(
            backgroundColor: AppColors.surface,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(color: AppColors.divider, width: 1),
            ),
            elevation: 4,
            contentTextStyle: const TextStyle(
              fontSize: 14,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        routerConfig: appRouter,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
