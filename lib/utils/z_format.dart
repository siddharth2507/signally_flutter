import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ZFormat {
  static String numToMoney(num number) {
    final currencyFormat = new NumberFormat("#,##0.00", "en_US");
    return '\$${currencyFormat.format(number)}';
  }

  static String strToMoney(String number) {
    final currencyFormat = new NumberFormat("#,##0.00", "en_US");
    return '\$${currencyFormat.format(num.tryParse(number) ?? 0)}';
  }

  static num toPrecision(num number, int fractionDigits) {
    if (number.isNaN) return 0;
    num mod = pow(10, fractionDigits);
    return ((number * mod).round() / mod);
  }

  static String numToPercent(num number) {
    return '${toPrecision(number * 100, 2)}%';
  }

  static dateTimeFormatStr(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat("MMM dd, yyyy 'at' h:mm a").format(dateTime);
  }

  static dateFormatStr(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat("MMM dd, yyyy").format(dateTime);
  }

  static dateFormatSignal(DateTime? dateTime) {
    if (dateTime == null) return '';
    // ÷convert date to local time zone
    return DateFormat("MMM-dd, h:mm a").format(dateTime.toLocal());
  }

  static timeFormatStr(TimeOfDay? dateTime, BuildContext context) {
    if (dateTime == null) return '';
    return TimeOfDay(hour: dateTime.hour, minute: dateTime.minute).format(context).toString();
  }
}
