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
    final sign = change >= 0 ? '+' : '';
    return '$sign${priceFormat.format(change)} ($sign${percentFormat.format(changePercent)}%)';
  }
}
