import 'package:intl/intl.dart';

class NumberUtil {
  factory NumberUtil() {
    return _numberUtil;
  }
  static final NumberUtil _numberUtil = NumberUtil._();
  NumberUtil._();

  static var formatter = NumberFormat('#,##,000');

  static String formatNumber(num number) {
    if (number >= 100) return formatter.format(number);
    return number.toString();
  }
}
