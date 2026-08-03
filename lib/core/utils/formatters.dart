import 'package:intl/intl.dart';

class Formatters {
  static final NumberFormat priceFormat = NumberFormat.currency(
    symbol: '₹',
    decimalDigits: 2,
    locale: 'en_IN',
  );

  static final NumberFormat quantityFormat = NumberFormat.decimalPattern(
    'en_IN',
  );

  static final NumberFormat percentFormat = NumberFormat.decimalPattern('en_IN')
    ..minimumFractionDigits = 2
    ..maximumFractionDigits = 2;

  static String formatPrice(double price) {
    return priceFormat.format(price);
  }

  static String formatChange(double change, double changePercent) {
    final formattedPrice = formatSignedPrice(change);
    final formattedPercent = formatSignedPercent(changePercent);
    return '$formattedPrice ($formattedPercent)';
  }

  static String formatSignedPrice(double amount) {
    if (amount.abs() < 0.005) {
      return priceFormat.format(0.0);
    }
    final sign = amount > 0 ? '+' : '';
    return '$sign${priceFormat.format(amount)}';
  }

  static String formatSignedPercent(double percent) {
    if (percent.abs() < 0.005) {
      return '${percentFormat.format(0.0)}%';
    }
    final sign = percent > 0 ? '+' : '';
    return '$sign${percentFormat.format(percent)}%';
  }
}
