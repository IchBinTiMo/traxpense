String converDateTimeToString(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();

  return "$year-$month-$day";
}
