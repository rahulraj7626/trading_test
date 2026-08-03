import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/theme/app_colors.dart';
import '../../../../core/config/theme/app_spacing.dart';
import '../../../../core/config/theme/app_text_styles.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/utils/formatters.dart';
import '../../../market/domain/repositories/market_repository.dart';
import '../../../market/presentation/bloc/live_price_cubit.dart';
import '../../../market/presentation/bloc/live_price_state.dart';
import '../../../market/presentation/widgets/stock_row.dart';
import '../../../portfolio/presentation/bloc/holdings_cubit.dart';
import '../../../portfolio/presentation/bloc/holdings_state.dart';
import '../../domain/entities/order_entity.dart';
import '../bloc/trading_cubit.dart';
import '../bloc/trading_state.dart';

class BuySellTicketScreen extends StatefulWidget {
  final String symbol;

  const BuySellTicketScreen({super.key, required this.symbol});

  @override
  State<BuySellTicketScreen> createState() => _BuySellTicketScreenState();
}

class _BuySellTicketScreenState extends State<BuySellTicketScreen> {
  OrderSide _selectedSide = OrderSide.buy;
  final TextEditingController _quantityController = TextEditingController();

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activeColor = _selectedSide == OrderSide.buy
        ? AppColors.buy
        : AppColors.sell;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => LivePriceCubit(
            marketRepository: getIt<MarketRepository>(),
            symbol: widget.symbol,
          ),
        ),
        BlocProvider(create: (_) => getIt<TradingCubit>()),
      ],
      child: BlocListener<TradingCubit, TradingState>(
        listener: (context, state) {
          if (state is TradingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          } else if (state is TradingOrderSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.success,
              ),
            );
            context.read<HoldingsCubit>().loadHoldings();
            Navigator.of(context).pop();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('${AppStrings.tradePrefix} ${widget.symbol}'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Live Price Card
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: StockRow(
                    symbol: widget.symbol,
                    showVolume: false,
                    showFavoriteStar: false,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Custom Buy / Sell Selector (Consistent Colors)
                Container(
                  height: 48,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSide = OrderSide.buy;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _selectedSide == OrderSide.buy
                                  ? AppColors.buy
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.buttonBuy,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: _selectedSide == OrderSide.buy
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedSide = OrderSide.sell;
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: _selectedSide == OrderSide.sell
                                  ? AppColors.sell
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              AppStrings.buttonSell,
                              style: AppTextStyles.titleMedium.copyWith(
                                color: _selectedSide == OrderSide.sell
                                    ? Colors.white
                                    : AppColors.textSecondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Quantity Input
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    labelText: AppStrings.inputQuantity,
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.divider),
                    ),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Order Value Preview Card
                BlocBuilder<LivePriceCubit, LivePriceState>(
                  builder: (context, priceState) {
                    final qtyStr = _quantityController.text;
                    final qty = int.tryParse(qtyStr) ?? 0;
                    double price = 0;
                    if (priceState is LivePriceLoaded) {
                      price = priceState.tick.price;
                    }
                    final orderValue = qty * price;

                    return Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.divider),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.orderValue,
                            style: AppTextStyles.titleMedium,
                          ),
                          Text(
                            Formatters.formatPrice(orderValue),
                            style: AppTextStyles.titleMedium,
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Account Context (Funds, Holding, Max Buy/Sell)
                BlocBuilder<TradingCubit, TradingState>(
                  buildWhen: (previous, current) => current is TradingLoaded,
                  builder: (context, tradingState) {
                    return BlocBuilder<LivePriceCubit, LivePriceState>(
                      builder: (context, priceState) {
                        return BlocBuilder<HoldingsCubit, HoldingsState>(
                          builder: (context, holdingsState) {
                            double balance = 0.0;
                            if (tradingState is TradingLoaded) {
                              balance = tradingState.wallet.balance;
                            }

                            double currentPrice = 0.0;
                            if (priceState is LivePriceLoaded) {
                              currentPrice = priceState.tick.price;
                            }

                            int maxBuy = 0;
                            if (currentPrice > 0) {
                              maxBuy = (balance / currentPrice).floor();
                            }

                            int currentHoldingQty = 0;
                            if (holdingsState is HoldingsLoaded) {
                              final holdingIdx = holdingsState.holdings
                                  .indexWhere((h) => h.symbol == widget.symbol);
                              if (holdingIdx != -1) {
                                currentHoldingQty =
                                    holdingsState.holdings[holdingIdx].quantity;
                              }
                            }
                            final maxSell = currentHoldingQty;
                            final holdingCurrentValue =
                                currentHoldingQty * currentPrice;

                            return Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        AppStrings.availableBalance,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        Formatters.formatPrice(balance),
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        AppStrings.maxBuyQty,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$maxBuy',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 20,
                                    color: AppColors.divider,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        AppStrings.currentHolding,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$currentHoldingQty ${AppStrings.qtySuffix}',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        AppStrings.portfolioCurrentValue,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        Formatters.formatPrice(
                                          holdingCurrentValue,
                                        ),
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text(
                                        AppStrings.maxSellQty,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$maxSell',
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                ),
                const SizedBox(height: AppSpacing.xl),

                // Submit Button (Validation & Enable/Disable)
                BlocBuilder<TradingCubit, TradingState>(
                  builder: (context, tradingState) {
                    return BlocBuilder<LivePriceCubit, LivePriceState>(
                      builder: (context, priceState) {
                        return BlocBuilder<HoldingsCubit, HoldingsState>(
                          builder: (context, holdingsState) {
                            double balance = 0.0;
                            if (tradingState is TradingLoaded) {
                              balance = tradingState.wallet.balance;
                            }

                            double currentPrice = 0.0;
                            if (priceState is LivePriceLoaded) {
                              currentPrice = priceState.tick.price;
                            }

                            int maxBuy = 0;
                            if (currentPrice > 0) {
                              maxBuy = (balance / currentPrice).floor();
                            }

                            int currentHoldingQty = 0;
                            if (holdingsState is HoldingsLoaded) {
                              final holdingIdx = holdingsState.holdings
                                  .indexWhere((h) => h.symbol == widget.symbol);
                              if (holdingIdx != -1) {
                                currentHoldingQty =
                                    holdingsState.holdings[holdingIdx].quantity;
                              }
                            }
                            final maxSell = currentHoldingQty;

                            final qtyStr = _quantityController.text;
                            final qty = int.tryParse(qtyStr) ?? 0;

                            final isLoading =
                                tradingState is TradingOrderSubmitting ||
                                priceState is! LivePriceLoaded;

                            bool isValid = !isLoading;
                            String? validationError;

                            if (_selectedSide == OrderSide.sell) {
                              if (maxSell == 0) {
                                isValid = false;
                                validationError =
                                    'No holdings available to sell';
                              } else if (qty <= 0) {
                                isValid = false;
                              } else if (qty > maxSell) {
                                isValid = false;
                                validationError =
                                    'Quantity exceeds max sellable quantity ($maxSell)';
                              }
                            } else {
                              if (maxBuy == 0) {
                                isValid = false;
                                validationError = 'Insufficient balance to buy';
                              } else if (qty <= 0) {
                                isValid = false;
                              } else if (qty > maxBuy) {
                                isValid = false;
                                validationError =
                                    'Quantity exceeds max buyable quantity ($maxBuy)';
                              }
                            }

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (validationError != null) ...[
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      validationError,
                                      textAlign: TextAlign.center,
                                      style: AppTextStyles.labelMedium.copyWith(
                                        color: AppColors.error,
                                      ),
                                    ),
                                  ),
                                ],
                                SizedBox(
                                  height: 52,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: activeColor,
                                      disabledBackgroundColor:
                                          AppColors.divider,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: isValid ? 2 : 0,
                                    ),
                                    onPressed: isValid
                                        ? () {
                                            context
                                                .read<TradingCubit>()
                                                .placeOrder(
                                                  symbol: widget.symbol,
                                                  side: _selectedSide,
                                                  quantity: qty,
                                                  price:
                                                      (priceState
                                                              as LivePriceLoaded)
                                                          .tick
                                                          .price,
                                                );
                                          }
                                        : null,
                                    child: isLoading
                                        ? const CircularProgressIndicator(
                                            color: Colors.white,
                                          )
                                        : Text(
                                            _selectedSide == OrderSide.buy
                                                ? AppStrings.placeBuyOrder
                                                : AppStrings.placeSellOrder,
                                            style: AppTextStyles.titleMedium
                                                .copyWith(
                                                  color: isValid
                                                      ? Colors.white
                                                      : AppColors.textSecondary,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
