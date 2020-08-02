import 'package:flutter/material.dart';
import 'package:notify/src/providers/provider-news-item.dart';

import '../global/config.dart';

class InfoPage extends StatelessWidget {
  final NewsItem news;
  InfoPage(this.news);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: SingleChildScrollView(
        child: Container(
            margin: EdgeInsets.all(Config.dh * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _subtitleAndDate(),
                _newsBody(),
              ],
            )),
      ),
    );
  }

  Widget _subtitleAndDate() {
    return Container(
      height: Config.dh * 0.1,
      //margin: EdgeInsets.only(bottom: Config.dh * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            news.subtitle,
            style: TextStyle(color: Colors.grey.shade200, fontSize: 18),
          ),
          Text(news.newsFormattedData(),
              style: TextStyle(
                  color: Colors.grey.shade200,
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w300))
        ],
      ),
    );
  }

  Widget _newsBody() {
    return Text(
      news.body.replaceAll('\\n', '\n'),
      style: TextStyle(
        color: Colors.grey.shade200,
      ),
    );
  }
}
