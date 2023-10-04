String converDateTimeToString(DateTime? dateTime) {
  if (dateTime == null) {
    return "";
  }

  String year = dateTime.year.toString();

  String month = dateTime.month.toString();

  String day = dateTime.day.toString();
  // ensure that monthe and day are both in two digits
  // if (month.length == 1) {
  //   month = month;
  // }

  // if (day.length == 1) {
  //   day = day;
  // }

  return "$year-$month-$day";
}
