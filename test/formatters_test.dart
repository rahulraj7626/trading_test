import 'package:flutter_test/flutter_test.dart';
import 'package:trading/core/utils/formatters.dart';

void main() {
  group('Formatters', () {
    test('formatSignedPrice never indicates pre + or - for 0.00', () {
      expect(Formatters.formatSignedPrice(0.0), '₹0.00');
      expect(Formatters.formatSignedPrice(0.0001), '₹0.00');
      expect(Formatters.formatSignedPrice(-0.0001), '₹0.00');
      expect(Formatters.formatSignedPrice(0.004), '₹0.00');
      expect(Formatters.formatSignedPrice(-0.004), '₹0.00');
    });

    test('formatSignedPrice handles positive and negative amounts correctly', () {
      expect(Formatters.formatSignedPrice(150.50), '+₹150.50');
      expect(Formatters.formatSignedPrice(-150.50), '-₹150.50');
    });

    test('formatSignedPercent never indicates pre + or - for 0.00', () {
      expect(Formatters.formatSignedPercent(0.0), '0.00%');
      expect(Formatters.formatSignedPercent(0.0001), '0.00%');
      expect(Formatters.formatSignedPercent(-0.0001), '0.00%');
      expect(Formatters.formatSignedPercent(0.004), '0.00%');
      expect(Formatters.formatSignedPercent(-0.004), '0.00%');
    });

    test('formatSignedPercent handles positive and negative percentages correctly', () {
      expect(Formatters.formatSignedPercent(5.25), '+5.25%');
      expect(Formatters.formatSignedPercent(-5.25), '-5.25%');
    });

    test('formatChange formats positive, negative and zero changes without + or - on 0.00', () {
      expect(Formatters.formatChange(0.0, 0.0), '₹0.00 (0.00%)');
      expect(Formatters.formatChange(12.5, 2.5), '+₹12.50 (+2.50%)');
      expect(Formatters.formatChange(-12.5, -2.5), '-₹12.50 (-2.50%)');
    });
  });
}
