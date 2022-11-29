import 'dart:async';

import 'package:dart_extensions/dart_extensions.dart';

extension DurationExtension on Duration {
  Future<dynamic> delay([FutureOr Function()? callback]) async {
    return Future.delayed(this, callback);
  }

  // https://stackoverflow.com/questions/54852585/how-to-convert-a-duration-like-string-to-a-real-duration-in-flutter
  // https://stackoverflow.com/questions/60016267/in-dart-split-string-into-two-parts-using-length-of-first-string
  String format() {
    List<String> result = <String>[];

    List<String> parts = toString().split(':');
    List<String> sParts = parts[parts.length - 1].split('.');

    if (parts.length > 2) {
      final int hours = int.parse(parts[parts.length - 3]);

      if (hours != 0) {
        result.add('$hours h');
      }
    }

    if (parts.length > 1) {
      final minutes = int.parse(parts[parts.length - 2]);

      if (minutes != 0) {
        result.add('$minutes m');
      }
    }

    if (sParts.length > 1) {
      final seconds = int.parse(sParts[sParts.length - 2]);

      if (seconds != 0) {
        result.add('$seconds s');
      }
    }

    if (sParts.isNotEmpty) {
      final String mParts = sParts[sParts.length - 1];

      final milliseconds = int.parse(mParts.substring(0, mParts.length ~/ 2));
      final microseconds =
          int.parse(mParts.substring(mParts.length ~/ 2, mParts.length));

      if (milliseconds != 0) {
        result.add('$milliseconds ms');
      }

      if (microseconds != 0) {
        result.add('$microseconds µs');
      }
    }

    return result.join(' ');
  }

  static const int daysPerYear = 365;
  static const int weeksPerYear = 52;
  static const int monthsPerYear = 12;
  static const int daysPerWeek = 7;

  // int get inYears => inDays ~/ daysPerYear;
  // int get inWeeks => inDays ~/ daysPerWeek;

  int get years => inDays ~/ daysPerYear;
  // int get months => ((inDays * daysPerYear) ~/ monthsPerYear) % monthsPerYear;
  int get weeks => (inDays % daysPerYear) ~/ daysPerWeek;
  int get days => (inDays % daysPerYear) % daysPerWeek;
  int get hours => inHours % Duration.hoursPerDay;
  int get minutes => inMinutes % Duration.minutesPerHour;
  int get seconds => inSeconds % Duration.secondsPerMinute;
  int get milliseconds => inMilliseconds % Duration.millisecondsPerSecond;
  int get microseconds => inMicroseconds % Duration.microsecondsPerMillisecond;

  /// https://github.com/mzdm/iso_duration_parser/blob/master/lib/src/parser.dart
  String toISO() {
    if (this == Duration.zero) {
      return 'PT0S';
    }

    final strNegative = isNegative ? '-' : '';
    final strBuffer = StringBuffer('${strNegative}P');

    if (years != 0) {
      strBuffer.write('${years.abs().deleteTrailingZero()}Y');
    }
    // if (months != 0) {
    //   strBuffer.write('${months.abs().deleteTrailingZero()}M');
    // }
    if (weeks != 0) {
      strBuffer.write('${weeks.abs().deleteTrailingZero()}W');
    }
    if (days != 0) {
      strBuffer.write('${days.abs().deleteTrailingZero()}D');
    }

    if (<num>[hours, minutes, seconds].any((e) => e != 0)) {
      strBuffer.write('T');

      if (hours != 0) {
        strBuffer.write('${hours.abs().deleteTrailingZero()}H');
      }
      if (minutes != 0) {
        strBuffer.write('${minutes.abs().deleteTrailingZero()}M');
      }
      if (seconds != 0) {
        strBuffer.write('${seconds.abs().deleteTrailingZero()}S');
      }
    }

    return strBuffer.toString();
  }
}
