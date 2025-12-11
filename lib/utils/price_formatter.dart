import 'package:intl/intl.dart';

String formatPrice(num price) {
  final formatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );
  return formatter.format(price);
}
