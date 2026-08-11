/// Calendar-day helpers used across trackers.
DateTime normalizeToDate(DateTime date) =>
    DateTime(date.year, date.month, date.day);

bool isSameCalendarDay(DateTime? a, DateTime? b) {
  if (a == null || b == null) return false;
  return a.year == b.year && a.month == b.month && a.day == b.day;
}

DateTime startOfDay(DateTime date) => normalizeToDate(date);

DateTime endOfDay(DateTime date) =>
    DateTime(date.year, date.month, date.day, 23, 59, 59, 999);

/// Monday through Sunday for the week containing [reference].
List<DateTime> weekDaysMondayToSunday(DateTime reference) {
  final normalized = normalizeToDate(reference);
  final monday = normalized.subtract(Duration(days: normalized.weekday - 1));
  return List.generate(7, (index) => monday.add(Duration(days: index)));
}
