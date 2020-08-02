import 'package:flutter/material.dart';

import '../global/enum.dart';

class NewsItem with ChangeNotifier {
  String title;
  String subtitle;
  DateTime date;
  String body;
  String code;
  NewsType type;

  NewsItem(
      {@required this.title,
      @required this.subtitle,
      @required this.date,
      @required this.body,
      @required this.type,
      @required this.code});

  String newsFormattedData() {
    String day = date.day.toString();
    String month = date.month.toString();
    String year = date.year.toString();
    String hour = date.hour.toString();
    String minute = date.minute.toString();
    minute.length < 2 ? minute = '0' + minute : minute = minute;
    return '$day/$month/$year  $hour:$minute';
  }

  String newsFormattedType() {
    switch (type) {
      case NewsType.EVENT:
        return 'Event';
        break;
      case NewsType.PROMO:
        return 'Promozione';
        break;
      case NewsType.PATCH:
        return 'Patch';
        break;
      case NewsType.FIX:
        return 'Bug Fix';
        break;
      default:
        return 'News';
    }
  }

  Color typeColor() {
    switch (type) {
      case NewsType.EVENT:
        return Colors.lightBlue.shade300;
        break;
      case NewsType.PROMO:
        return Colors.green;
        break;
      case NewsType.PATCH:
        return Colors.orangeAccent.shade200;
        break;
      case NewsType.FIX:
        return Colors.red;
        break;
      default:
        return Colors.blue;
    }
  }
}
