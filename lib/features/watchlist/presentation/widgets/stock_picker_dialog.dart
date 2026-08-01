import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_config.dart';
import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../../market/presentation/widgets/stock_row.dart';

class StockPickerDialog extends StatelessWidget {
  final List<String> currentSymbols;

  const StockPickerDialog({super.key, required this.currentSymbols});

  static Future<String?> show(
    BuildContext context, {
    required List<String> currentSymbols,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StockPickerDialog(currentSymbols: currentSymbols),
    );
  }

  @override
  Widget build(BuildContext context) {
    final available = AppConfig.availableStocks
        .where((s) => !currentSymbols.contains(s))
        .toList();

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.65,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.md,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drag Handle
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
            const Text(
              AppStrings.dialogAddStock,
              style: AppTextStyles.titleLarge,
            ),
            const SizedBox(height: AppSpacing.md),
            if (available.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                child: Center(
                  child: Text(
                    AppStrings.dialogAllStocksInWatchlist,
                    style: AppTextStyles.bodyMedium,
                  ),
                ),
              )
            else
              Flexible(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: available.length,
                  itemBuilder: (context, index) {
                    final symbol = available[index];
                    return BlocProvider(
                      key: ValueKey('picker_$symbol'),
                      create: (_) => LivePriceCubit(
                        marketRepository: getIt<MarketRepository>(),
                        symbol: symbol,
                      ),
                      child: StockRow(
                        symbol: symbol,
                        onTap: () {
                          Navigator.of(context).pop(symbol);
                        },
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
