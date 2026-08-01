import 'package:flutter/material.dart';
import '../../config/theme/app_colors.dart';
import '../../config/theme/app_text_styles.dart';

class CompanyAvatar extends StatelessWidget {
  final String symbol;

  const CompanyAvatar({super.key, required this.symbol});

  @override
  Widget build(BuildContext context) {
    // Generate a consistent color based on the symbol string
    final colorHash = symbol.codeUnits.fold(0, (prev, curr) => prev + curr);
    final colors = [
      Colors.blue,
      Colors.red,
      Colors.purple,
      Colors.teal,
      Colors.orange,
      Colors.indigo,
    ];
    final bgColor = colors[colorHash % colors.length];

    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.divider, width: 1),
      ),
      child: Center(
        child: Text(
          symbol.substring(0, 1).toUpperCase(),
          style: AppTextStyles.titleMedium.copyWith(
            color: bgColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
