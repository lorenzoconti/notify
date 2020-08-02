import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import './provider-news-item.dart';

import '../global/enum.dart';

class News with ChangeNotifier {
  List<NewsItem> _news = [];

  CollectionReference _ref = Firestore.instance.collection('news');

  List<NewsItem> get news {
    return _news;
  }

  Future<Null> fetchNews() async {
    _news.clear();

    QuerySnapshot snapshot = await _ref.getDocuments();

    snapshot.documents.forEach((document) {
      Timestamp _timestamp = document['date'];
      DateTime _date = _timestamp.toDate();
      addNews(
          body: document['body'],
          code: document.documentID,
          date: _date,
          stringType: document['type'],
          subititle: document['subtitle'],
          title: document['title']);
    });

    notifyListeners();
  }

  StreamSubscription<QuerySnapshot> newsListener() {
    return _ref.snapshots().listen((snapshot) {
      snapshot.documents.forEach((document) {
        String code = document.documentID;
        String title = document['title'];
        String subtitle = document['subtitle'];
        String body = document['body'];
        Timestamp timestamp = document['date'];
        DateTime date = timestamp.toDate();
        String type = document['type'];

       _news.removeWhere((item) => item.code == code);

        addNews(
            body: body,
            code: code,
            date: date,
            stringType: type,
            subititle: subtitle,
            title: title);
      });

      notifyListeners();
    });
  }

  void addNews(
      {String title,
      String subititle,
      String body,
      DateTime date,
      String code,
      String stringType}) {
    NewsType type = NewsType.NEWS;

    switch (stringType) {
      case 'PROMO':
        type = NewsType.PROMO;
        break;
      case 'UPDATE':
        type = NewsType.UPDATE;
        break;
      case 'FIX':
        type = NewsType.FIX;
        break;
      case 'PATCH':
        type = NewsType.PATCH;
        break;
      default:
    }

    _news.add((NewsItem(
        title: title,
        subtitle: subititle,
        body: body,
        date: date,
        code: code,
        type: type)));
  }
}
