import 'package:flutter/cupertino.dart';

class StationData {
  StationData({
    @required this.date,
    @required this.value,
  });
  final String date;
  final String value;

  factory StationData.fromLine(String line) {
    if (line.trim() != "") {
      final components = line.split(",");
      String date = components[0];
      String value = components[1].substring(0, 4);
      try {
        return StationData(date: date.trim(), value: value.trim());
      } catch (e) {
        print("e");
        return null;
      }
    }
  }
}
