import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/provider-news.dart';

import '../widgets/drawer-custom.dart';
import '../widgets/card-news.dart';

class NewsPage extends StatefulWidget {
  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  bool _isInit = false;
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    if (!_isInit) {
      //////////////
      if (mounted) {
        setState(() {
          _isLoading = true;
        });
      }
      //////////////
      Provider.of<News>(context).fetchNews().then((_) {
        _isInit = true;
      });
      Provider.of<News>(context).newsListener();
      //////////////
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
      //////////////
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<News>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade900,
        elevation: 5.0,
        title: Text(
          'Notify',
          style: TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade800.withOpacity(0.95),
      drawer: CustomDrawer(),
      body: RefreshIndicator(
        onRefresh: () => _refresh(),
        color: Colors.white,
        child: _isLoading
            ? Container(
                child: Center(
                    child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white))))
            : ListView.builder(
                padding: EdgeInsets.all(0),
                itemCount: newsProvider.news.length,
                //itemBuilder: (context, index)=> Container(width: Config.dw, child: Text(newsProvider.news[index].title),color: Colors.red,),
                itemBuilder: (context, index) =>
                    NewsCard(news: newsProvider.news[index])),
      ),
    );
  }

  Future<void> _refresh() {
    return Provider.of<News>(context).fetchNews();
  }
}
