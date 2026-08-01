import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';
import '../../utils/formatters.dart';

class MetricText extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final TextStyle? valueStyle;

  const MetricText({
    super.key,
    required this.label,
    required this.value,
    this.valueColor,
    this.valueStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style:
              valueStyle ??
              AppTextStyles.titleMedium.copyWith(
                color: valueColor ?? AppColors.textPrimary,
              ),
        ),
      ],
    );
  }
}
