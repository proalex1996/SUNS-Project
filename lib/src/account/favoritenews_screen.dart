import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/news_item.dart';
import 'package:suns_med/src/account/session_account_bloc.dart';
import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/src/news/news_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FavoriteNewsScreen extends StatefulWidget {
  @override
  _FavoriteNewsScreenState createState() => _FavoriteNewsScreenState();
}

class _FavoriteNewsScreenState extends State<FavoriteNewsScreen> {
  final bloc = AccountBloc();
  final sessionBloc = SessionBloc();

  @override
  void initState() {
    bloc.dispatch(LoadLikeNews());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
        // appBar: AppBar(
        //   toolbarHeight: height(context) * 0.15,
        //   backgroundColor: AppColor.deepBlue,
        //   flexibleSpace: Padding(
        //     padding: EdgeInsets.fromLTRB(
        //         width(context) * 0.58, height(context) * 0.07, 0, 0),
        //     child: Container(
        //       decoration: BoxDecoration(
        //         image: DecorationImage(
        //           image: AssetImage(
        //               'assets/images/profile/pattern_part_circle.png'),
        //           fit: BoxFit.none,
        //         ),
        //       ),
        //     ),
        //   ),
        //   title: Text(
        //     'Bài viết yêu thích',
        //     style:TextStyle(
        //         fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        //   ),
        //   // leading: BlocProvider<NotificationEvent, NotificationState,
        //   //     NotificationBloc>(
        //   //   bloc: notifyBloc,
        //   //   builder: (state) {
        //   //     return IconButton(
        //   //         icon: Icon(Icons.arrow_back),
        //   //         onPressed: () {
        //   //           notifyBloc.dispatch(CountNotifyEvent());
        //   //           Navigator.pop(context);
        //   //         });
        //   //   },
        //   // ),
        //   centerTitle: true,
        // ),
        appBar: const TopAppBar(),
        body: BlocProvider<AccountEvent, AccountState, AccountBloc>(
            bloc: bloc,
            builder: (state) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    CustomAppBar(
                      title: language.favoritePosts,
                      titleSize: 18,
                      isTopPadding: true,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: listNews(context, state.likeNews, false),
                    ),
                  ],
                ),
              );
            }));
  }

  Widget listNews(BuildContext context, data, bool banner) {
    var shortestSide = MediaQuery.of(context).size.shortestSide;
    var useMobileLayout = shortestSide < 600;
    return data != null
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                for (int i = 0; i < data.length; i++)
                  GestureDetector(
                    onTap: () {
                      data[i].totalView += 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsScreen(
                            news: data[i],
                            listNews: data,
                          ),
                        ),
                      );
                    },
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: useMobileLayout ? 100 : 200,
                              height: useMobileLayout ? 100 : 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: data[i]?.image == null
                                  ? Image.asset(
                                      'assets/images/logo.png',
                                      width: useMobileLayout ? 100 : 200,
                                      height: useMobileLayout ? 100 : 200,
                                    )
                                  : Image.network(data[i]?.image),
                            ),
                            SizedBox(
                              width: useMobileLayout ? 15 : 25,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      data[i]?.name,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontWeight: FontWeight.bold,
                                          fontSize: useMobileLayout ? 16 : 28),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.favorite_border_outlined,
                                        color: AppColor.deepBlue,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text('${data[i].totalLike}')
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        Divider()
                      ],
                    ),
                  ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          )
        : Center(
            child: Padding(
            padding: const EdgeInsets.only(bottom: 60.0),
            child: Text(
              "Không có dữ liệu.",
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 20,
                  color: AppColor.darkPurple.withOpacity(0.4)),
            ),
          ));
  }

  _getNews() {
    return BlocProvider<AccountEvent, AccountState, AccountBloc>(
      bloc: bloc,
      builder: (output) {
        return output.likeNews == null || output.likeNews.isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: Text(AppLocalizations.of(context).notData),
                ),
              )
            : Wrap(
                children: List.generate(
                  output.likeNews?.length ?? 0,
                  (index) {
                    var news = output.likeNews[index];
                    return NewItem(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailNewsScreen(
                              news: news,
                              listNews: output.likeNews,
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
                  },
                ),
              );
      },
    );
  }
}
