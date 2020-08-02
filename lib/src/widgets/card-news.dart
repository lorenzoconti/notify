import 'package:flutter/material.dart';
import 'package:notify/src/providers/provider-news-item.dart';

import '../global/config.dart';
import '../global/enum.dart';

import '../pages/page-info.dart';

class NewsCard extends StatelessWidget {
  final NewsItem news;
  NewsCard({this.news});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => InfoPage(news)));
      },
      padding: EdgeInsets.all(0),
      elevation: 1.0,
      child: Container(
        margin: EdgeInsets.symmetric(
            vertical: Config.dh * 0.01, horizontal: Config.dw * 0.035),
        padding: EdgeInsets.symmetric(
            vertical: Config.dh * 0.015, horizontal: Config.dw * 0.045),
        height: Config.dh * 0.2,
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _cardBody(),
            SizedBox(
              width: Config.dw * 0.075,
            ),
            _rightSideFakeButton()
          ],
        ),
      ),
    );
  }

  Widget _rightSideFakeButton() {
    return Icon(Icons.arrow_forward_ios, color: Colors.grey);
  }

  Widget _cardBody() {
    return Expanded(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _title(),
            _subtitle(),
            _divider(),
            _dateAndTypeRow()
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return Text(news.title,
        style: TextStyle(color: Colors.white, fontSize: 18));
  }

  Widget _subtitle() {
    return Text(news.subtitle,
        style: TextStyle(
            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400));
  }

  Widget _divider() {
    return Container(
      height: 1.5,
      width: Config.dw * 0.75,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
    );
  }

  Widget _dateAndTypeRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          news.newsFormattedData(),
          style: TextStyle(
              color: Colors.white, fontSize: 12, fontWeight: FontWeight.w200),
        ),
        Container(
            padding: EdgeInsets.symmetric(
                horizontal: Config.dw * 0.015, vertical: Config.dh * 0.005),
            height: Config.dh * 0.028,
            decoration: BoxDecoration(
                color: news.typeColor(),
                borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: Text(
                news.newsFormattedType(),
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    fontWeight: FontWeight.w500),
              ),
            ))
      ],
    );
  }
}
