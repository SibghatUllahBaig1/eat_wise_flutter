import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'lat_lng.dart';
import 'place.dart';
import 'uploaded_file.dart';
import '/backend/schema/structs/index.dart';
import '/auth/firebase_auth/auth_util.dart';

List<String> daysList() {
  // Give me a list of numbers from 01, 02, 03... to 31
  List<String> days = [];
  for (int i = 1; i <= 31; i++) {
    days.add(i.toString().padLeft(2, '0')); // Pad with leading zero
  }
  return days;
}

List<String> months() {
  // give me a list of months in a format like oct. nov. dec.
  return [
    'jan.',
    'feb.',
    'mar.',
    'apr.',
    'may.',
    'jun.',
    'jul.',
    'aug.',
    'sep.',
    'oct.',
    'nov.',
    'dec.'
  ];
}

List<String> years() {
  // Give me a list of numbers from 1950 to 2010
  List<String> yearList = [];
  for (int year = 1950; year <= 2010; year++) {
    yearList.add(year.toString());
  }
  return yearList;
}

DateTime? dateOfBirth(
  String day,
  String? month,
  String year,
) {
  // Define a map to convert month abbreviations to their respective numbers
  const monthMap = {
    'jan': 1,
    'feb': 2,
    'mar': 3,
    'apr': 4,
    'may': 5,
    'jun': 6,
    'jul': 7,
    'aug': 8,
    'sep': 9,
    'oct': 10,
    'nov': 11,
    'dec': 12,
  };

  // Clean up the month input (remove dots, trim spaces, lowercase)
  final cleanedMonth = month?.toLowerCase().replaceAll('.', '').trim();

  // Get the month number
  final monthNumber = cleanedMonth != null ? monthMap[cleanedMonth] : null;

  // Try to parse day and year
  final parsedDay = int.tryParse(day);
  final parsedYear = int.tryParse(year);

  // If any part is invalid, return null
  if (monthNumber == null || parsedDay == null || parsedYear == null) {
    return null;
  }

  try {
    // Return the final DateTime
    return DateTime(parsedYear, monthNumber, parsedDay);
  } catch (e) {
    // If invalid date (e.g. 31 Feb), catch and return null
    return null;
  }
}

String? hiddenText(
  String? contentText,
  int? frontText,
  int? backText,
) {
  // frontText is the number of characters from the beginning of the text backText is the number of characters from the end of the text. Make sure that as many characters are shown in the front as indicated in the fronText and as many characters are shown in the back as indicated in the backText, put * in place of the remaining characters, but leave a space instead of spaces. Here is an example: contentText - 12 44 33 43 , frontText - 2, backText - 4. Return Value: 12 ** ** 33 43
  if (contentText == null || frontText == null || backText == null) {
    return null;
  }

  if (contentText.length <= frontText + backText) {
    return contentText;
  }

  String front = contentText.substring(0, frontText);
  String back = contentText.substring(contentText.length - backText);

  String hidden = '';
  for (int i = frontText; i < contentText.length - backText; i++) {
    if (contentText[i] == ' ') {
      hidden += ' ';
    } else {
      hidden += '*';
    }
  }

  return '$front$hidden$back';
}

String? creditCardType(String? creditCard) {
  // by card number, give me the type of this card. For example, this is a Visa or Mastercard kata
  if (creditCard == null) {
    return null;
  }

  // Remove all non-digit characters from the credit card number
  String cleanedCardNumber = creditCard.replaceAll(RegExp(r'\D'), '');

  // Check the length of the cleaned credit card number to determine the type
  if (cleanedCardNumber.length == 0) {
    return null;
  } else if (cleanedCardNumber.length == 15 &&
          cleanedCardNumber.startsWith('34') ||
      cleanedCardNumber.startsWith('37')) {
    return 'American Express';
  } else if (cleanedCardNumber.length == 16 &&
      cleanedCardNumber.startsWith('4')) {
    return 'Visa';
  } else if (cleanedCardNumber.length == 16 &&
      cleanedCardNumber.startsWith('5') &&
      int.parse(cleanedCardNumber[1]) >= 1 &&
      int.parse(cleanedCardNumber[1]) <= 5) {
    return 'Mastercard';
  } else if ((cleanedCardNumber.length == 13 ||
          cleanedCardNumber.length == 16) &&
      cleanedCardNumber.startsWith('6011')) {
    return 'Discover';
  } else {
    return 'Unknown';
  }
}

String? fileToImage(FFUploadedFile? imageFile) {
  // convert the uploaded image to ImagePath
  if (imageFile == null) return null;
  return 'path/to/image/${imageFile.name}'; // Assuming FFUploadedFile has a 'name' property
}

List<DateTime> getDatesRange(
  DateTime date1,
  DateTime date2,
) {
  // get dates list from date1 to date2 without date1 and date2
  List<DateTime> datesList = [];
  DateTime currentDate = date1.add(Duration(days: 1));

  while (currentDate.isBefore(date2)) {
    datesList.add(currentDate);
    currentDate = currentDate.add(Duration(days: 1));
  }

  return datesList;
}

DateTime getNextMonthDateTime(DateTime inputDate) {
  int year = inputDate.year;
  int month = inputDate.month;

  if (month == 12) {
    year++;
    month = 1;
  } else {
    month++;
  }
  return DateTime(year, month);
}

DateTime getLastMonthDateTime(DateTime inputDate) {
  int year = inputDate.year;
  int month = inputDate.month;

  if (month == 1) {
    year--;
    month = 12;
  } else {
    month--;
  }
  return DateTime(year, month);
}

int indexFromList(
  List<String> wordsList,
  String selectedWord,
) {
  return wordsList.indexOf(selectedWord);
}

DateTime getNextDate(DateTime inputDate) {
  // Добавляем 1 день к входной дате
  return DateTime(
    inputDate.year,
    inputDate.month,
    inputDate.day + 1,
  );
}

DateTime getLastDate(DateTime inputDate) {
  // Вычитаем 1 день из входной даты
  return DateTime(
    inputDate.year,
    inputDate.month,
    inputDate.day - 1,
  );
}

List<DateTime> getMonthDays(
  String firstDayOfWeek,
  String yearAndMonth,
) {
  // Парсим год и месяц
  final parts = yearAndMonth.split('/');
  if (parts.length != 2) return [];

  final year = int.tryParse(parts[0]) ?? DateTime.now().year;
  final month = int.tryParse(parts[1]) ?? DateTime.now().month;

  // Определяем первый и последний день месяца
  final firstDayOfMonth = DateTime(year, month, 1);
  final lastDayOfMonth = DateTime(year, month + 1, 0);

  // Получаем индекс дня недели (0=воскресенье, 1=понедельник...)
  int firstDayIndex;
  switch (firstDayOfWeek.toLowerCase()) {
    case 'monday':
      firstDayIndex = 1;
      break;
    case 'tuesday':
      firstDayIndex = 2;
      break;
    case 'wednesday':
      firstDayIndex = 3;
      break;
    case 'thursday':
      firstDayIndex = 4;
      break;
    case 'friday':
      firstDayIndex = 5;
      break;
    case 'saturday':
      firstDayIndex = 6;
      break;
    case 'sunday':
    default:
      firstDayIndex = 0;
  }

  // Вычисляем начальную дату (может быть в предыдущем месяце)
  final startDate = firstDayOfMonth.subtract(
    Duration(days: (firstDayOfMonth.weekday - firstDayIndex) % 7),
  );

  // Вычисляем количество дней для отображения
  final totalDays = lastDayOfMonth.difference(startDate).inDays + 1;

  // Генерируем список дат и фильтруем только нужные
  return List.generate(totalDays, (index) {
    return DateTime(
      startDate.year,
      startDate.month,
      startDate.day + index,
    );
  })
      .where(
          (date) => date.isBefore(lastDayOfMonth.add(const Duration(days: 1))))
      .toList();
}

List<DateTime> daysFunction(
  String firstDayOfWeek,
  DateTime currentDay,
  int daysQuantity,
) {
  // Определяем индекс первого дня недели (0-6)
  int firstDayIndex;
  switch (firstDayOfWeek.toLowerCase()) {
    case 'monday':
      firstDayIndex = 1;
      break;
    case 'tuesday':
      firstDayIndex = 2;
      break;
    case 'wednesday':
      firstDayIndex = 3;
      break;
    case 'thursday':
      firstDayIndex = 4;
      break;
    case 'friday':
      firstDayIndex = 5;
      break;
    case 'saturday':
      firstDayIndex = 6;
      break;
    case 'sunday':
    default:
      firstDayIndex = 0;
  }

  // Нормализуем текущую дату (без времени)
  DateTime normalizedCurrentDay =
      DateTime(currentDay.year, currentDay.month, currentDay.day);

  // Находим ближайший предыдущий день, соответствующий firstDayOfWeek
  DateTime startDate = normalizedCurrentDay.subtract(Duration(
    days: (normalizedCurrentDay.weekday - firstDayIndex) % 7,
  ));

  // Создаем список из N дней, начиная с startDate
  List<DateTime> dateList = List.generate(daysQuantity, (index) {
    return DateTime(
      startDate.year,
      startDate.month,
      startDate.day + index,
    );
  });

  // Проверяем, что текущий день включен в список
  bool containsCurrentDay = dateList.any((date) =>
      date.year == normalizedCurrentDay.year &&
      date.month == normalizedCurrentDay.month &&
      date.day == normalizedCurrentDay.day);

  // Если текущий день не входит в диапазон, корректируем список
  if (!containsCurrentDay) {
    if (normalizedCurrentDay.isBefore(startDate)) {
      // Если текущий день раньше начала диапазона
      dateList = List.generate(daysQuantity, (index) {
        return DateTime(
          normalizedCurrentDay.year,
          normalizedCurrentDay.month,
          normalizedCurrentDay.day + index,
        );
      });
    } else {
      // Если текущий день позже конца диапазона
      dateList = List.generate(daysQuantity, (index) {
        return DateTime(
          normalizedCurrentDay.year,
          normalizedCurrentDay.month,
          normalizedCurrentDay.day - (daysQuantity - 1) + index,
        );
      });
    }
  }

  return dateList;
}

List<DateTime> getLastWeekDate(DateTime selectedDate) {
  // Вычисляем дату, которая была ровно 7 дней назад
  DateTime weekAgo = selectedDate.subtract(const Duration(days: 7));

  // Находим понедельник предыдущей недели
  DateTime firstDayOfLastWeek =
      weekAgo.subtract(Duration(days: weekAgo.weekday - 1));

  // Генерируем список всех 7 дней предыдущей недели
  List<DateTime> lastWeekDates = List.generate(7, (index) {
    return firstDayOfLastWeek.add(Duration(days: index));
  });

  return lastWeekDates;
}

List<DateTime> getNextWeekDate(DateTime selectedDate) {
  // Находим следующий понедельник (начало следующей недели)
  DateTime nextMonday =
      selectedDate.add(Duration(days: 8 - selectedDate.weekday));

  // Генерируем список из 7 дней следующей недели
  List<DateTime> nextWeekDates = List.generate(7, (index) {
    return nextMonday.add(Duration(days: index));
  });

  return nextWeekDates;
}

List<String> getHours() {
  // Генерируем список часов от 00 до 11
  return List.generate(12, (index) => index.toString().padLeft(2, '0'));
}

List<String> getMinutes() {
  // Генерируем список минут от 00 до 59
  return List.generate(60, (index) => index.toString().padLeft(2, '0'));
}

int getIndexOfItems(
  String selectedItem,
  List<String> itemsList,
) {
  // Находим индекс элемента в списке
  return itemsList.indexOf(selectedItem);
}

String first3Characters(String text) {
  // give me the first 3 characters of the text
  return text.length >= 3 ? text.substring(0, 3) : text;
}
