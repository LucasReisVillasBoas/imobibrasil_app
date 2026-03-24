import 'package:intl/intl.dart';

class AppFormatters {
  static final _brl = NumberFormat.currency(
    locale: 'pt_BR',
    symbol: 'R\$',
    decimalDigits: 2,
  );

  static String toBRL(double value) => _brl.format(value);

  static String toArea(double value) {
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)} mil m²';
    }
    return '${value.toStringAsFixed(0)} m²';
  }
}
