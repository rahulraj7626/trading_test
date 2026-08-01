import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class ListHeaderRow extends StatelessWidget {
  final String col1;
  final String col2;
  final String col3;
  final VoidCallback? onCol1Tap;
  final VoidCallback? onCol2Tap;
  final VoidCallback? onCol3Tap;

  const ListHeaderRow({
    super.key,
    required this.col1,
    required this.col2,
    required this.col3,
    this.onCol1Tap,
    this.onCol2Tap,
    this.onCol3Tap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 4,
            child: InkWell(
              onTap: onCol1Tap,
              child: Row(
                children: [
                  Text(
                    col1,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (onCol1Tap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.unfold_more,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onCol2Tap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    col2,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (onCol2Tap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.unfold_more,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: InkWell(
              onTap: onCol3Tap,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    col3,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (onCol3Tap != null) ...[
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.unfold_more,
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
