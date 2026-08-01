import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/presentation/widgets/company_avatar.dart';
import '../../../../core/utils/formatters.dart';
import '../../../watchlist/presentation/bloc/watchlist_cubit.dart';
import '../../../watchlist/presentation/bloc/watchlist_state.dart';
import '../../../watchlist/presentation/widgets/watchlist_selector_sheet.dart';
import '../bloc/live_price_cubit.dart';
import '../bloc/live_price_state.dart';

class StockRow extends StatelessWidget {
  final String symbol;
  final VoidCallback? onTap;
  final bool showVolume;
  final bool showFavoriteStar;

  const StockRow({
    super.key,
    required this.symbol,
    this.onTap,
    this.showVolume = true,
    this.showFavoriteStar = true,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LivePriceCubit, LivePriceState>(
      buildWhen: (previous, current) {
        if (previous is LivePriceLoaded && current is LivePriceLoaded) {
          return previous.tick.price != current.tick.price;
        }
        return true;
      },
      builder: (context, state) {
        if (state is LivePriceLoaded) {
          final tick = state.tick;
          final isPositive = tick.change >= 0;
          final companyName =
              AppConfig.companyNames[tick.symbol] ?? tick.symbol;
          final volume = AppConfig.companyVolumes[tick.symbol] ?? 0.0;

          return InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.md,
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Row(
                      children: [
                        CompanyAvatar(symbol: tick.symbol),
                        const SizedBox(width: AppSpacing.sm), // smaller spacing
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                companyName,
                                style: AppTextStyles.bodyLarge,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tick.symbol,
                                style: AppTextStyles.labelMedium,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showVolume)
                    Expanded(
                      flex: 2,
                      child: Text(
                        volume.toStringAsFixed(2),
                        style: AppTextStyles.bodyLarge,
                        textAlign: TextAlign.right,
                      ),
                    ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          Formatters.formatPrice(tick.price),
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: isPositive
                                ? AppColors.profit
                                : AppColors.loss,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Formatters.formatChange(
                            tick.change,
                            tick.changePercent,
                          ),
                          style: AppTextStyles.labelMedium.copyWith(
                            color: isPositive
                                ? AppColors.profit
                                : AppColors.loss,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (showFavoriteStar)
                    BlocBuilder<WatchlistCubit, WatchlistState>(
                      builder: (context, watchlistState) {
                        bool isFavorite = false;
                        String? watchlistName;
                        if (watchlistState is WatchlistLoaded &&
                            watchlistState.selectedWatchlist != null) {
                          watchlistName =
                              watchlistState.selectedWatchlist!.name;
                          isFavorite = watchlistState.selectedWatchlist!.symbols
                              .contains(tick.symbol);
                        }
                        return InkWell(
                          borderRadius: BorderRadius.circular(20),
                          onTap: () {
                            if (watchlistState is WatchlistLoaded &&
                                watchlistState.selectedWatchlist != null) {
                              context.read<WatchlistCubit>().toggleFavorite(
                                tick.symbol,
                              );
                              final text = isFavorite
                                  ? '${AppStrings.removedFromWatchlist} $watchlistName'
                                  : '${AppStrings.addedToWatchlist} $watchlistName';
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Text(text),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                            }
                          },
                          onLongPress: () {
                            WatchlistSelectorSheet.show(context, tick.symbol);
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Icon(
                              isFavorite
                                  ? Icons.star_rounded
                                  : Icons.star_border_rounded,
                              color: isFavorite
                                  ? const Color(0xFFFFC107)
                                  : AppColors.textSecondary.withValues(
                                      alpha: 0.35,
                                    ),
                              size: 20,
                            ),
                          ),
                        );
                      },
                    ),
                ],
              ),
            ),
          );
        }
        return Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
