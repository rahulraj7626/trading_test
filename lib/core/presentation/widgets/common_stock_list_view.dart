import 'package:flutter/material.dart';

import '../../config/theme/app_spacing.dart';
import 'list_header_row.dart';

class CommonStockListView<T> extends StatelessWidget {
  final String col1;
  final String col2;
  final String col3;
  final VoidCallback? onCol1Tap;
  final VoidCallback? onCol2Tap;
  final VoidCallback? onCol3Tap;
  final List<T> items;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final void Function(int oldIndex, int newIndex)? onReorder;
  final Widget Function(BuildContext context, T item, int index, Widget child)?
  dismissibleBuilder;

  const CommonStockListView({
    super.key,
    required this.col1,
    required this.col2,
    required this.col3,
    this.onCol1Tap,
    this.onCol2Tap,
    this.onCol3Tap,
    required this.items,
    required this.itemBuilder,
    this.onReorder,
    this.dismissibleBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: ListHeaderRow(
            col1: col1,
            col2: col2,
            col3: col3,
            onCol1Tap: onCol1Tap,
            onCol2Tap: onCol2Tap,
            onCol3Tap: onCol3Tap,
          ),
        ),
        Expanded(
          child: onReorder != null
              ? ReorderableListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  onReorder: onReorder!,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final child = itemBuilder(context, item, index);
                    if (dismissibleBuilder != null) {
                      return dismissibleBuilder!(context, item, index, child);
                    }
                    return child;
                  },
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return itemBuilder(context, item, index);
                  },
                ),
        ),
      ],
    );
  }
}
