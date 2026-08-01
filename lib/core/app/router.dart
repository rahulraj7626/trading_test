import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../features/market/presentation/pages/market_screen.dart';
import '../../features/portfolio/presentation/pages/holdings_screen.dart';
import '../../features/trading/presentation/pages/buy_sell_ticket_screen.dart';
import '../../features/watchlist/presentation/pages/watchlist_screen.dart';
import '../constants/app_strings.dart';

class MainShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const MainShell({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: AppStrings.navMarket,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: AppStrings.navWatchlist,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart),
            label: AppStrings.navPortfolio,
          ),
        ],
      ),
    );
  }
}

final appRouter = GoRouter(
  initialLocation: '/market',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainShell(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/market',
              builder: (context, state) => const MarketScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/watchlist',
              builder: (context, state) => const WatchlistScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/portfolio',
              builder: (context, state) => const HoldingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/trade/:symbol',
      builder: (context, state) {
        final symbol = state.pathParameters['symbol']!;
        return BuySellTicketScreen(symbol: symbol);
      },
    ),
  ],
);
