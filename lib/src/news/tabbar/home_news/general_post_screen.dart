import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/news_item.dart';
import 'package:suns_med/src/Widgets/tabbar/session_getlisttab_bloc.dart';
import 'package:suns_med/src/news/session_news_bloc.dart';
import 'package:suns_med/src/news/tabbar/home_news/createnews_screen.dart';
import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/src/news/tabbar/home_news/session_createpost_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;

class GeneralPostsScreen extends StatefulWidget {
  final int categoryId;
  GeneralPostsScreen({this.categoryId});
  @override
  _GeneralPostsScreenState createState() => _GeneralPostsScreenState();
}

class _GeneralPostsScreenState extends State<GeneralPostsScreen>
    with TickerProviderStateMixin<GeneralPostsScreen> {
  var _isVisible = true;

  final newsBloc = NewsBloc();
  final postCreatedBloc = PostBloc();
  final bloc = TabbarBloc();

  AnimationController animationController;
  Animation<Offset> _offset;

  StreamController<bool> _visibleChange = StreamController<bool>();

  ScrollController _hideButtonController = ScrollController();
  // ScrollController _scrollController = ScrollController();

  initScroll() {
    _isVisible = true;
    animationController =
        AnimationController(duration: kThemeAnimationDuration, vsync: this);
    _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(animationController);
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible == true) {
          // print("**** $_isVisible up");
          _isVisible = false;
          _visibleChange.add(_isVisible);
          animationController.forward();
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isVisible == false) {
            // print("**** $_isVisible down");
            _isVisible = true;
            _visibleChange.add(_isVisible);
            animationController.reverse();
          }
        }
      }
    });
  }

  @override
  void initState() {
    if (newsBloc.state?.packageResultPost[this.widget.categoryId] == null) {
      newsBloc.dispatch(LoadEvent(type: this.widget.categoryId));
    }
    // if (postCreatedBloc.state?.isCreated == true) {
    //   newsBloc.dispatch(LoadEvent(type: this.widget.categoryId));
    // }

    initScroll();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.pixels ==
          _hideButtonController.position.maxScrollExtent) {
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

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        RefreshIndicator(
          onRefresh: _refreshHome,
          child: Scrollbar(child: _getNews()),
        ),
        BlocProvider<NewsEvent, NewsState, NewsBloc>(
            bloc: newsBloc,
            builder: (state) {
              return StreamBuilder<bool>(
                  stream: _visibleChange.stream,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return SlideTransition(
                      position: _offset,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        width: 163,
                        height: 33,
                        child: RaisedButton(
                          color: AppColor.deepBlue,
                          onPressed: state.allowedPost != true
                              ? null
                              : () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => CreateNewsScreen(
                                        categoryId: widget.categoryId,
                                      ),
                                    ),
                                  );
                                },
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Text(
                            'Viết bài',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    );
                  });
            }),
      ],
    );
  }

  _getNews() {
    return BlocProvider<NewsEvent, NewsState, NewsBloc>(
      bloc: newsBloc,
      useLoading: false,
      builder: (output) {
        var posts = output.packageResultPost[2];
        var length = posts?.data?.length ?? 0;
        return posts == null
            ? Center(
                child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: Text("Không có dữ liệu."),
              ))
            : ListView.builder(
                controller: _hideButtonController,
                itemCount: length,
                itemBuilder: (ctx, index) {
                  var news = posts.data[index];
                  if (index == length) {
                    return CupertinoActivityIndicator();
                  }
                  if (index == 0) {
                    String date = news.lastUpdated;
                    timeago.setLocaleMessages('vi', timeago.ViMessages());
                    return GestureDetector(
                      onTap: () {
                        news.totalView += 1;
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          news.image == null
                              ? Image.asset(
                                  'assets/images/logo.png',
                                  height: 300,
                                  fit: BoxFit.contain,
                                )
                              : Image.network(
                                  news.image,
                                  width: double.infinity,
                                  height: 400,
                                  fit: BoxFit.cover,
                                ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  news.categoryName,
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.deepBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13),
                                ),
                                Text(
                                  timeago.format(DateTime.parse(date),
                                      locale: 'vi'),
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: AppColor.veryLightPinkTwo,
                                      fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16),
                            child: Text(
                              news.name,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 18),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 16, top: 10, right: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/ic_heart1.png',
                                      width: 16,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 6.8,
                                    ),
                                    Text(
                                      _convertIntToFriendlyString(
                                          news.totalLike),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 10,
                                          color: AppColor.pinkishGrey),
                                    ),
                                    SizedBox(
                                      width: 12.5,
                                    ),
                                    Image.asset(
                                      'assets/images/ic_eye.png',
                                      width: 24,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 6.8,
                                    ),
                                    Text(
                                      _convertIntToFriendlyString(
                                          news.totalView),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 10,
                                          color: AppColor.pinkishGrey),
                                    ),
                                    SizedBox(
                                      width: 12.5,
                                    ),
                                    Image.asset(
                                      'assets/images/ic_share1.png',
                                      width: 16,
                                      height: 15,
                                    ),
                                    SizedBox(
                                      width: 6.8,
                                    ),
                                    Text(
                                      _convertIntToFriendlyString(
                                          news.totalShare),
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 10,
                                          color: AppColor.pinkishGrey),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return NewItem(
                      onTap: () {
                        news.totalView += 1;
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
                      image: news?.image,
                      special: news.categoryName,
                      title: news.name,
                      datetime: news?.lastUpdated,
                      favorite: news?.totalLike,
                      view: news?.totalView,
                      share: news?.totalShare,
                    );
                  }
                });
      },
    );
  }

  Future<Null> _refreshHome() async {
    newsBloc.dispatch(LoadEvent(type: this.widget.categoryId));
  }

  _convertIntToFriendlyString(int number) {
    if (number / 1000000 >= 1) {
      return "${(number / 1000000).toStringAsFixed(1)}Tr";
    } else if (number / 1000 >= 1) {
      return "${(number / 1000).toStringAsFixed(1)}N";
    } else {
      return number.toString();
    }
  }
}
