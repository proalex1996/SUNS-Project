import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/news_item.dart';

import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/src/news/search_news/session_search_bloc.dart';
import 'package:suns_med/src/news/session_news_bloc.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final bloc = SearchBloc();
  final newsBloc = NewsBloc();
  FocusNode _focusNode = new FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: AppColor.deepBlue,
        title: _buildCustomSearchBar(
          'Tìm kiếm theo chủ đề...',
          controller: _searchController,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (_searchController.text.length >= 2) {
                bloc.dispatch(EventSearch(keyword: _searchController.text));
              }
            },
          ),
        ],
      ),
      body: _getNews(),
    );
  }

  _getNews() {
    return BlocProvider<SearchEvent, SearchState, SearchBloc>(
      bloc: bloc,
      builder: (state) {
        return state.listPost == null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 21),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6)
                        ]),
                    child: Text('Lưu ý: Cần nhập 2 ký tự trở lên để tìm kiếm.',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  // Text("Lưu ý: Cần nhập 3 ký tự trở lên để tỉm kiếm."),
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset("assets/images/searchImg.png"),
                ],
              )
            : state.listPost.isEmpty
                ? Center(
                    child: Container(
                      child: Text('Chưa có dữ liệu về từ khoá này'),
                    ),
                  )
                : Wrap(
                    children: List.generate(state.listPost?.length, (index) {
                      var news = state.listPost[index];
                      return NewItem(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailNewsScreen(
                                news: news,
                                listNews: state.listPost,
                              ),
                            ),
                          );
                        },
                        image: news?.image,
                        special: news?.categoryName,
                        title: news?.name,
                        datetime: news?.lastUpdated,
                        favorite: news?.totalLike,
                        view: news?.totalView,
                        share: news?.totalShare,
                      );
                    }),
                  );
      },
    );
  }

  _buildCustomSearchBar(
    String hintText, {
    Function(String) onChange,
    TextEditingController controller,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      padding: const EdgeInsets.only(left: 20),
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent &&
              (event.logicalKey.keyId == 54)) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(EventSearch(keyword: _searchController.text));
            }
          }
        },
        child: TextFormField(
          controller: controller,
          onChanged: onChange,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(EventSearch(keyword: _searchController.text));
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
