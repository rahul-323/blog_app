import 'package:intl/intl.dart';

String formatDatebyddMMYY(DateTime dateTime) {
  return DateFormat("d MMM, YYYY").format(dateTime);
}
