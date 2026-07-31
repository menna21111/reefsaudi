import 'package:easy_localization/easy_localization.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/app_string.dart';

class PortfolioMoneyUtils {
  const PortfolioMoneyUtils._();

  static String formatCompact(double value) {
    if (value >= 1000000000) {
      return '${(value / 1000000000).toStringAsFixed(1)}B';
    }
    if (value >= 1000000) {
      return '${(value / 1000000).toStringAsFixed(1)}M';
    }
    if (value >= 1000) {
      return '${(value / 1000).toStringAsFixed(1)}K';
    }
    return NumberFormat('#,##0', 'en').format(value);
  }

  static String formatFull(double value) {
    return NumberFormat('#,##0', 'en').format(value);
  }

  static String withCurrency(double value) {
    return '${formatCompact(value)} ${AppString.sar.tr()}';
  }
}
