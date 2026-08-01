import 'package:flutter/material.dart';
import '../../../../core/config/app_config.dart';

class StockPickerDialog extends StatelessWidget {
  final List<String> currentSymbols;

  const StockPickerDialog({super.key, required this.currentSymbols});

  @override
  Widget build(BuildContext context) {
    final available = AppConfig.availableStocks
        .where((s) => !currentSymbols.contains(s))
        .toList();

    return AlertDialog(
      title: const Text('Add Stock'),
      content: SizedBox(
        width: double.maxFinite,
        child: available.isEmpty
            ? const Text('All stocks are already in the watchlist.')
            : ListView.builder(
                shrinkWrap: true,
                itemCount: available.length,
                itemBuilder: (context, index) {
                  final symbol = available[index];
                  return ListTile(
                    title: Text(symbol),
                    onTap: () {
                      Navigator.of(context).pop(symbol);
                    },
                  );
                },
              ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}
