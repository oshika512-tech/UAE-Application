import 'package:intl/intl.dart';
class DatetimeCal {
  
String formatDateOrTime(DateTime dateTime, bool isDate) {
  return isDate
      ? DateFormat('yyyy-MM-dd').format(dateTime) // Date only
      : DateFormat('hh:mm a').format(dateTime);  // Time with AM/PM
}

  
}