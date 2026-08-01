import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../bloc/watchlist_cubit.dart';
import '../bloc/watchlist_state.dart';

class WatchlistSelectorSheet extends StatelessWidget {
  final String symbol;

  const WatchlistSelectorSheet({super.key, required this.symbol});

  static Future<void> show(BuildContext context, String symbol) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => WatchlistSelectorSheet(symbol: symbol),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WatchlistCubit, WatchlistState>(
      builder: (context, state) {
        if (state is! WatchlistLoaded || state.watchlists.isEmpty) {
          return const SizedBox.shrink();
        }

        return Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.md,
            top: AppSpacing.md,
            left: AppSpacing.md,
            right: AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 36,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textSecondary.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppStrings.titleAddToWatchlist} ($symbol)',
                    style: AppTextStyles.titleLarge,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: state.watchlists.length,
                  itemBuilder: (context, index) {
                    final watchlist = state.watchlists[index];
                    final isInWatchlist = watchlist.symbols.contains(symbol);

                    return CheckboxListTile(
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                      title: Text(
                        watchlist.name,
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: Colors.white,
                        ),
                      ),
                      subtitle: Text(
                        '${watchlist.symbols.length} items',
                        style: AppTextStyles.labelMedium,
                      ),
                      value: isInWatchlist,
                      onChanged: (bool? checked) {
                        if (checked == true) {
                          context.read<WatchlistCubit>().addStockToWatchlist(
                            watchlist.id,
                            symbol,
                          );
                        } else {
                          context
                              .read<WatchlistCubit>()
                              .removeStockFromWatchlist(watchlist.id, symbol);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
