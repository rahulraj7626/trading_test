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
          body: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Live Price Section
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.divider),
                  ),
                  child: StockRow(symbol: widget.symbol, showVolume: false),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Side Selector
                SegmentedButton<OrderSide>(
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return _selectedSide == OrderSide.buy
                            ? AppColors.profit
                            : AppColors.loss;
                      }
                      return null;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return Colors.white;
                      }
                      return null;
                    }),
                  ),
                  segments: const [
                    ButtonSegment(
                      value: OrderSide.buy,
                      label: Text(AppStrings.buttonBuy),
                    ),
                    ButtonSegment(
                      value: OrderSide.sell,
                      label: Text(AppStrings.buttonSell),
                    ),
                  ],
                  selected: {_selectedSide},
                  onSelectionChanged: (Set<OrderSide> newSelection) {
                    setState(() {
                      _selectedSide = newSelection.first;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.lg),

                // Quantity Input
                TextField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: const InputDecoration(
                    labelText: AppStrings.inputQuantity,
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: AppSpacing.lg),

                // Order Value Preview
                BlocBuilder<LivePriceCubit, LivePriceState>(
                  builder: (context, priceState) {
                    final qtyStr = _quantityController.text;
                    final qty = int.tryParse(qtyStr) ?? 0;
                    double price = 0;
                    if (priceState is LivePriceLoaded) {
                      price = priceState.tick.price;
                    }
                    final orderValue = qty * price;

                    return Row(
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

                            return Container(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.availableBalance,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        Formatters.formatPrice(balance),
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.maxBuyQty,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$maxBuy',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const Divider(
                                    height: 16,
                                    color: AppColors.divider,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.currentHolding,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$currentHoldingQty ${AppStrings.qtySuffix}',
                                        style: AppTextStyles.bodyMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        AppStrings.maxSellQty,
                                        style: AppTextStyles.labelMedium,
                                      ),
                                      Text(
                                        '$maxSell',
                                        style: AppTextStyles.bodyMedium,
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
                const Spacer(),

                // Submit Button
                BlocBuilder<TradingCubit, TradingState>(
                  builder: (context, tradingState) {
                    return BlocBuilder<LivePriceCubit, LivePriceState>(
                      builder: (context, priceState) {
                        final isLoading =
                            tradingState is TradingOrderSubmitting ||
                            priceState is! LivePriceLoaded;
                        return ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            backgroundColor: _selectedSide == OrderSide.buy
                                ? AppColors.profit
                                : AppColors.loss,
                          ),
                          onPressed: isLoading
                              ? null
                              : () {
                                  final qty =
                                      int.tryParse(_quantityController.text) ??
                                      0;
                                  if (qty <= 0) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          AppStrings.errorInvalidQty,
                                        ),
                                      ),
                                    );
                                    return;
                                  }

                                  context.read<TradingCubit>().placeOrder(
                                    symbol: widget.symbol,
                                    side: _selectedSide,
                                    quantity: qty,
                                    price: priceState.tick.price,
                                  );
                                },
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : Text(
                                  _selectedSide == OrderSide.buy
                                      ? AppStrings.placeBuyOrder
                                      : AppStrings.placeSellOrder,
                                  style: AppTextStyles.titleMedium.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
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
