import 'package:intl/intl.dart';

String formatDatebyddMMYY(DateTime dateTime) {
  return DateFormat("d MMM, yyyy").format(dateTime);
}
