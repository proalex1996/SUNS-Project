import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/news_item.dart';
import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/src/news/session_news_bloc.dart';
import 'package:suns_med/src/news/tabbar/home_news/createnews_screen.dart';

class MedicalNewScreen extends StatefulWidget {
  final int categoryId;
  MedicalNewScreen({this.categoryId});

  @override
  _MedicalNewScreenState createState() => _MedicalNewScreenState();
}

class _MedicalNewScreenState extends State<MedicalNewScreen> {
  ScrollController _scrollController = ScrollController();
  final newsBloc = NewsBloc();

  @override
  void initState() {
    if (newsBloc.state.packageResultPost[this.widget.categoryId] == null) {
      newsBloc.dispatch(LoadEvent(type: this.widget.categoryId));
    }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    super.initState();
  }

  _getMoreData() {
    newsBloc.dispatch(
      LoadMoreEvent(type: this.widget.categoryId),
    );
  }

  Future<Null> _refreshHome() async {
    newsBloc.dispatch(LoadEvent(type: this.widget.categoryId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(child: _getNews(), onRefresh: _refreshHome),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: AppColor.deepBlue,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CreateNewsScreen(
                categoryId: widget.categoryId,
              ),
            ),
          );
        },
      ),
    );
  }

  _getNews() {
    return BlocProvider<NewsEvent, NewsState, NewsBloc>(
      bloc: newsBloc,
      builder: (output) {
        var posts = output.packageResultPost[this.widget.categoryId];
        var length = posts?.data?.length ?? 0;

        return length == 0
            ? Center(
                child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Không có dữ liệu."),
              ))
            : ListView.builder(
                itemCount: length,
                itemBuilder: (ctx, index) {
                  var news = posts.data[index];
                  return NewItem(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsScreen(
                            news: news,
                            listNews: posts.data,
                          ),
                        ),
                      );
                    },
                    image: news?.image ?? "",
                    special: news?.categoryName,
                    title: news?.name,
                    datetime: news?.lastUpdated,
                    favorite: news?.totalLike,
                    view: news?.totalView,
                    share: news?.totalShare,
                  );
                });
      },
    );
  }
}
