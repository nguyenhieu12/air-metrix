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
}
