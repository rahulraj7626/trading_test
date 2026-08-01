import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_config.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/utils/formatters.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../../market/presentation/bloc/live_price_state.dart';
import '../../domain/entities/holding.dart';

class HoldingRow extends StatelessWidget {
  final Holding holding;
  final VoidCallback? onTap;

  const HoldingRow({super.key, required this.holding, this.onTap});

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
        double currentPrice = holding.averageCost;
        if (state is LivePriceLoaded) {
          currentPrice = state.tick.price;
        }

        final invested = holding.quantity * holding.averageCost;
        final currentValue = holding.quantity * currentPrice;
        final pnl = currentValue - invested;
        final pnlPercent = (pnl / invested) * 100;
        final isPositive = pnl >= 0;
        final companyName =
            AppConfig.companyNames[holding.symbol] ?? holding.symbol;

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
                        '${AppStrings.labelQty} ${Formatters.quantityFormat.format(holding.quantity)} • ${AppStrings.labelAvg} ${Formatters.formatPrice(holding.averageCost)}',
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatPrice(currentValue),
                        style: AppTextStyles.bodyLarge,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${AppStrings.labelLtp} ${Formatters.formatPrice(currentPrice)}',
                        style: AppTextStyles.labelMedium,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Formatters.formatChange(
                          pnl,
                          0.0,
                        ).split(' ').first, // Only showing +5.60
                        style: AppTextStyles.bodyLarge.copyWith(
                          color: isPositive ? AppColors.profit : AppColors.loss,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${isPositive ? '+' : ''}${pnlPercent.toStringAsFixed(2)}%',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: isPositive ? AppColors.profit : AppColors.loss,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
