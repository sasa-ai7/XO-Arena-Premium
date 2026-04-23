import 'package:intl/intl.dart';

String formatCoins(int value, {bool compact = false}) {
  final safeValue = value < 0 ? 0 : value;
  if (!compact || safeValue < 10000) {
    return NumberFormat.decimalPattern().format(safeValue);
  }

  if (safeValue >= 1000000) {
    final millions = safeValue / 1000000;
    final hasDecimal = millions < 10 && millions != millions.truncateToDouble();
    final fixed = hasDecimal ? millions.toStringAsFixed(1) : millions.toStringAsFixed(0);
    return '${_trimTrailingZero(fixed)}M';
  }

  final thousands = safeValue / 1000;
  final hasDecimal = thousands < 100 && thousands != thousands.truncateToDouble();
  final fixed = hasDecimal ? thousands.toStringAsFixed(1) : thousands.toStringAsFixed(0);
  return '${_trimTrailingZero(fixed)}K';
}

String _trimTrailingZero(String value) {
  if (value.endsWith('.0')) {
    return value.substring(0, value.length - 2);
  }
  return value;
}
