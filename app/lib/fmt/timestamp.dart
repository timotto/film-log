import 'package:flutter/widgets.dart';

String formatTimestamp(
  BuildContext context,
  DateTime value, {
  List<DateTime> values = const [],
}) {
  final dateSet =
      values.map((item) => [item.year, item.month, item.day].join('-')).toSet();
  final sameDay = values.isNotEmpty && dateSet.length == 1;
  if (sameDay) {
    return formatTime(context, value);
  }

  return '${formateDate(context, value)} ${formatTime(context, value)}';
}

String formateDate(BuildContext context, DateTime value) =>
    [value.year, value.month, value.day]
        .map((item) => item.toString())
        .map((item) => item.padLeft(2, '0'))
        .join('-');

String formatTime(BuildContext context, DateTime value) =>
    [value.hour, value.minute, value.second]
        .map((item) => item.toString())
        .map((item) => item.padLeft(2, '0'))
        .join(':');
