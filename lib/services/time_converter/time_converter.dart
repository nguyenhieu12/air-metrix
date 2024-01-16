class TimeConverter {
  static int getCurrentHourTimestamp() {
    DateTime now = DateTime.now();

    DateTime currentHour = now.subtract(Duration(
      minutes: now.minute,
      seconds: now.second,
      microseconds: now.microsecond,
    ));

    return currentHour.millisecondsSinceEpoch ~/ 1000;
  }

  static int getUnixTimestamp(DateTime date) {
    DateTime unixTime = date.subtract(Duration(
      minutes: date.minute,
      seconds: date.second,
      microseconds: date.microsecond,
    ));

    return unixTime.millisecondsSinceEpoch ~/ 1000;
  }
}
