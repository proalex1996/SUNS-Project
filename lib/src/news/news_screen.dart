import 'dart:async';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/src/home/session_home_bloc.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/tabbar/session_getlisttab_bloc.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/src/home/session_department_bloc.dart';
import 'package:suns_med/src/news/search_news/detailnews_screen.dart';
import 'package:suns_med/src/news/session_news_bloc.dart';
import 'package:suns_med/shared/service_proxy/management_portal/news/dto/news_model.dart';
import 'package:suns_med/src/news/tabbar/home_news/session_createpost_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Topic {
  final String name;

  Topic(this.name);
}

class NewsScreen extends StatefulWidget {
  PagingResult<PostNewsModel> result;
  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // static List<Topic> topic = [
  //   Topic('Bệnh tim mạch'),
  //   Topic('Thuốc nội tiết'),
  //   Topic('Lời khuyên'),
  //   Topic('Sản phụ khoa'),
  //   Topic('Tai mũi họng'),
  //   Topic('Vật lý trị liệu'),
  //   Topic('Y học cổ truyền'),
  //   Topic('Cơ xương khớp'),
  //   Topic('Nhi khoa')
  // ];
  // final TextEditingController _controller = TextEditingController();
  var state;
  final homeBloc = HomeBloc();
  int first = 0;
  int _current = 0;
  PagingResult<PostNewsModel> dataNews;
  List<NewsModel> listNews;
  ScrollController _scrollController = ScrollController();
  final blocSession = SessionBloc();
  int indexNews = 1;
  final newsBloc = NewsBloc();
  final postCreatedBloc = PostBloc();
  final bloc = TabbarBloc();
  TabController _tabController;
  AnimationController animationController;
  @override
  void initState() {
    super.initState();
    bloc.dispatch(GetListNameTabEvent());
    newsBloc.dispatch(GetAllNewsEvent());
    // if (newsBloc.state?.packageResultPost[3] == null) {
    //   newsBloc.dispatch(LoadEvent(type: 3));
    // }
    // if (newsBloc.state?.packageResultPost[4] == null) {
    //   newsBloc.dispatch(LoadEvent(type: 4));
    // }
    // if (newsBloc.state?.packageResultPost[1] == null) {
    //   newsBloc.dispatch(LoadEvent(type: 1));
    // }
    // if (newsBloc.state?.packageResultPost[3] == null) {
    //   newsBloc.dispatch(LoadEvent(type: 3));
    // }
    if (newsBloc.state?.packageResultPost[0] == null) {
      newsBloc.dispatch(LoadEvent(type: 0));
    }
    // if (newsBloc.state?.packageResultPost[2] == null) {
    //   newsBloc.dispatch(LoadEvent(type: 2));
    // }

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _getMoreData();
      }
    });
    //_tabController = TabController(length: 3, vsync: this);
  }

  // _onPageChanged(int index) {
  //   setState(() {
  //     _currentPage = index;
  //   });
  // }

  _getMoreData() {
    // for (int i = 0; i < bloc.state.listCategory.length; i++) {
    //   newsBloc.dispatch(
    //     LoadMoreEvent(type: bloc.state.listCategory[i].id),
    //   );
    // }

    newsBloc.dispatch(
      LoadMoreEvent(
          type: bloc.state.listCategory
              .where((element) => element.isClick == true)
              .toList()
              .first
              .id),
    );
  }

  Future<Null> _refreshHome() async {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   automaticallyImplyLeading: false,
      //   backgroundColor: AppColor.white,
      //   flexibleSpace: BlocProvider<EventSession, StateSession, SessionBloc>(
      //       bloc: blocSession,
      //       builder: (state) {
      //         return Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           crossAxisAlignment: CrossAxisAlignment.center,
      //           children: [
      //             Expanded(
      //                 child: Align(
      //                     alignment: Alignment.centerLeft,
      //                     child: Image.asset(
      //                         'assets/images/profile/logo_gcare.png'))),
      //             Row(
      //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //               crossAxisAlignment: CrossAxisAlignment.center,
      //               children: [
      //                 Padding(
      //                   padding: EdgeInsets.only(top: height(context) * 0.03),
      //                   child: miniAvatar(state.user?.avatar),
      //                 ),
      //                 SizedBox(
      //                   width: width(context) * 0.02,
      //                 ),
      //                 Padding(
      //                   padding: EdgeInsets.only(top: height(context) * 0.05),
      //                   child: Column(
      //                     crossAxisAlignment: CrossAxisAlignment.start,
      //                     children: [
      //                       Text(
      //                         'Xin chào',
      //                         style:TextStyle(
      //    fontFamily: 'Montserrat-M',
      //                           color: AppColor.darkPurple,
      //                           fontSize: 14,
      //                         ),
      //                       ),
      //                       Text(state.user?.fullName,
      //                           style:TextStyle(
      //    fontFamily: 'Montserrat-M',
      //                               color: AppColor.darkPurple,
      //                               fontSize: 14,
      //                               fontWeight: FontWeight.bold)),
      //                     ],
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   width: width(context) * 0.02,
      //                 ),
      //                 InkWell(
      //                   // onTap: () {
      //                   //   Navigator.push(
      //                   //     context,
      //                   //     MaterialPageRoute(
      //                   //       builder: (context) => NotificationScreen(),
      //                   //     ),
      //                   //   );
      //                   // },
      //                   child: Padding(
      //                     padding: EdgeInsets.only(top: height(context) * 0.03),
      //                     child: Stack(children: <Widget>[
      //                       new Icon(
      //                         Icons.menu,
      //                         color: AppColor.darkPurple,
      //                       ),
      //                     ]),
      //                   ),
      //                 ),
      //                 SizedBox(
      //                   width: width(context) * 0.05,
      //                 ),
      //               ],
      //             )
      //           ],
      //         );
      //       }),
      //   //   centerTitle: true,
      //   //   title: Text(
      //   //     'Cập nhật thông tin cá nhân',
      ////   //     style:TextStyle(
      //                             fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
      ////   //   ),
      // ),
      appBar: const TopAppBar(),
      body: RefreshIndicator(onRefresh: _refreshHome, child: bodyBuilding()),
    );
  }
  // CustomTabbar()
  // _buildPressSearch() {
  //   return showSearchCustom(
  //     context: context,
  //     // query: _search.text,
  //     delegate: SearchPage<Topic>(
  //       controller: _controller,
  //       items: topic,

  //       searchLabel: 'Tìm kiếm theo chủ đề...',
  //       onPress: () {
  //         Navigator.push(
  //           context,
  //           MaterialPageRoute(
  //               builder: (context) => SearchScreen(value: _controller.text)),
  //         );
  //       },
  //       suggestion: Container(
  //           child: Column(
  //         children: <Widget>[
  //           Container(
  //             padding: const EdgeInsets.only(top: 12, left: 21),
  //             height: 40,
  //             width: double.infinity,
  //             decoration: BoxDecoration(
  //                 color: AppColor.veryLightPinkFour,
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.black26,
  //                       offset: Offset(0, 3),
  //                       blurRadius: 6)
  //                 ]),
  //             child: Text('Tìm kiếm gần đây',
  //                 style:TextStyle(
  //                  fontFamily: 'Montserrat-M',
  //                     color: AppColor.deepBlue,
  //                     fontSize: 16,
  //                     fontWeight: FontWeight.bold)),
  //           ),
  //           Expanded(
  //             child: ListView.builder(
  //                 itemCount: topic.length,
  //                 itemBuilder: (context, index) {
  //                   return ListTile(
  //                     title: Text(topic[index].name),
  //                     onTap: () {
  //                       Navigator.push(
  //                         context,
  //                         MaterialPageRoute(
  //                             builder: (context) =>
  //                                 SearchScreen(value: topic[index].name)),
  //                       );
  //                     },
  //                   );
  //                 }),
  //           ),
  //         ],
  //       )),
  //       failure: Center(
  //         child: Text('Không tìm thấy lịch sử tìm kiếm từ khoá.'),
  //       ),
  //       filter: (topic) => [
  //         topic.name,
  //       ],
  //       builder: (topic) => ListTile(
  //         title: Text(topic.name),
  //         onTap: () {
  //           Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //                 builder: (context) => SearchScreen(value: _controller.text)),
  //           );
  //         },
  //       ),
  //     ),
  //   );
  // }

  convertListImage(List imgList) {
    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(color: Colors.black12, blurRadius: 10),
                  ],
                ),
                //height: 10000,
                margin: EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Stack(
                          children: <Widget>[
                            Image.network(
                              item.image,
                              height: 190,
                              fit: BoxFit.fitHeight,
                              // width: 1000,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailNewsScreen(
                                  news: item,
                                  listNews: imgList,
                                ),
                              ),
                            );
                          },
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              '${item.name}',
                              overflow: TextOverflow.fade,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: AppColor.darkPurple,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    )),
              ),
            ))
        .toList();
    return imageSliders;
  }

  Widget bodyBuilding() {
    final CarouselController _controller = CarouselController();
    return BlocProvider<NewsEvent, NewsState, NewsBloc>(
        bloc: newsBloc,
        builder: (output) {
          var posts = output.packageResultPost[3];
          var promotion = output.packageResultPost[4];
          var mainNews = output.resultAllNews;
          return Container(
            // padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.white,
                  Colors.white38,
                  Color(0xFFF2F8FF)
                ],
              ),
            ),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  mainNews != null
                      ? (mainNews.data != null
                          ? (mainNews.data.length >= 4
                              ? Stack(
                                  children: [
                                    Container(
                                      width: width(context),
                                      height: 200,
                                      decoration: BoxDecoration(
                                        color: Color(0xFF616C9A),
                                        image: DecorationImage(
                                            alignment: Alignment.topCenter,
                                            image: AssetImage(
                                                "assets/images/profile/circle.png"),
                                            fit: BoxFit.fitWidth),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            top: height(context) * 0.08),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Text(
                                              AppLocalizations.of(context)
                                                  .newsUpper,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  color: Colors.white,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold)),
                                        ),
                                      ),
                                    ),
                                    mainNews != null
                                        ? Padding(
                                            padding: EdgeInsets.only(
                                                top: height(context) * 0.15),
                                            child: carousel(
                                                context, _controller, mainNews),
                                          )
                                        : Container(),
                                  ],
                                )
                              : Container())
                          : Container())
                      : Container(),
                  Container(
                      padding: EdgeInsets.only(
                          top: height(context) * 0.03,
                          bottom: height(context) * 0.02),
                      height: height(context) * 0.13,
                      child: BlocProvider<TabbarEvent, TabbarState, TabbarBloc>(
                        bloc: bloc,
                        builder: (state) {
                          if (first == 0 &&
                              state.listCategory != null &&
                              state.listCategory.isNotEmpty) {
                            state.listCategory[0].isClick = true;
                            first = 1;
                            newsBloc.dispatch(
                                LoadEvent(type: state.listCategory[0].id));
                            dataNews = output
                                .packageResultPost[state.listCategory[0].id];
                          } else if (first != 0 &&
                              state.listCategory
                                      .where(
                                          (element) => element.isClick == true)
                                      .toList() !=
                                  null) {
                            try {
                              dataNews = output.packageResultPost[state
                                  .listCategory
                                  .where((element) => element.isClick == true)
                                  .toList()
                                  .first
                                  .id];
                            } catch (e) {
                              state.listCategory[0].isClick = true;
                              dataNews = output.packageResultPost[0];
                            }
                          }
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: state.listCategory != null
                                  ? state.listCategory.length
                                  : 0,
                              itemBuilder: (_, i) {
                                var data = state.listCategory;
                                return Row(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          first = 1;
                                          if (newsBloc.state?.packageResultPost[
                                                  data[i].id] ==
                                              null) {
                                            newsBloc.dispatch(
                                                LoadEvent(type: data[i].id));
                                          }

                                          for (int j = 0;
                                              j < data.length;
                                              j++) {
                                            data[j].isClick = false;
                                          }
                                          data[i].isClick = true;
                                          dataNews = output.packageResultPost[
                                              state.listCategory
                                                  .where((element) =>
                                                      element.isClick == true)
                                                  .toList()
                                                  .first
                                                  .id];
                                        });
                                      },
                                      child: data[i].isClick
                                          ? Column(
                                              children: [
                                                Text(
                                                  '${data[i].name}',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      color: AppColor.darkPurple
                                                          .withOpacity(1),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height:
                                                      height(context) * 0.01,
                                                ),
                                                Container(
                                                  height: 4,
                                                  width: 195,
                                                  color: AppColor.darkPurple
                                                      .withOpacity(1),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              children: [
                                                Text(
                                                  '${data[i].name}',
                                                  style: TextStyle(
                                                      fontFamily:
                                                          'Montserrat-M',
                                                      color: AppColor.darkPurple
                                                          .withOpacity(0.4),
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  height:
                                                      height(context) * 0.01,
                                                ),
                                                Container(
                                                  height: 4,
                                                  width: 195,
                                                  color: AppColor.darkPurple
                                                      .withOpacity(0.4),
                                                ),
                                              ],
                                            ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    )
                                  ],
                                );
                              });
                        },
                      )),
                  listNewsH(context, dataNews, true),
                  // Row(
                  //   children: [
                  //     Expanded(
                  //       child: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               indexNews = 1;
                  //             });
                  //           },
                  //           child: Padding(
                  //             padding:
                  //                 EdgeInsets.only(left: width(context) * 0.05),
                  //             child: categoryNews(
                  //                 AppLocalizations.of(context).promotionService,
                  //                 0),
                  //           )),
                  //     ),
                  //     SizedBox(
                  //       width: width(context) * 0.01,
                  //     ),
                  //     Expanded(
                  //       child: GestureDetector(
                  //           onTap: () {
                  //             setState(() {
                  //               indexNews = 0;
                  //             });
                  //           },
                  //           child: Padding(
                  //             padding:
                  //                 EdgeInsets.only(right: width(context) * 0.05),
                  //             child: categoryNews(
                  //                 AppLocalizations.of(context).newsLowwer, 1),
                  //           )),
                  //     ),
                  //   ],
                  // ),
                  // SizedBox(
                  //   height: 20,
                  // ),
                  // indexNews == 1
                  //     ? (promotion != null
                  //         ? listPromotion(promotion)
                  //         : Container())
                  //     : (posts.data != null
                  //         ? listNewsH(context, posts.data, true)
                  //         : Container())
                ],
              ),
            ),
          );
        });
  }

  Widget carousel(BuildContext context, CarouselController _controller, data) {
    var imgList = [];
    List<Widget> imageSliders = [];
    if (data != null) {
      if (data.data != null) {
        for (int i = 0; i < data.data.length; i++) {
          if (i <= 3) {
            imgList.add(data.data[i]);
          } else {
            break;
          }
        }
      }

      imageSliders = convertListImage(imgList);
    }
    return imageSliders.isNotEmpty
        ? Column(children: [
            CarouselSlider(
              items: imageSliders,
              carouselController: _controller,
              options: CarouselOptions(
                  autoPlay: true,
                  height: 300,
                  enlargeCenterPage: true,
                  aspectRatio: 2.0,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
            ),
            imgList.length > 1
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: imgList.asMap().entries.map((entry) {
                      return Container(
                        width: _current == entry.key ? 13 : 8,
                        height: _current == entry.key ? 13 : 8,
                        margin: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color:
                                (Theme.of(context).brightness == Brightness.dark
                                        ? Colors.white
                                        : AppColor.darkPurple)
                                    .withOpacity(
                                        _current == entry.key ? 0.9 : 0.4)),
                      );
                    }).toList(),
                  )
                : Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 8,
                      height: 8,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColor.darkPurple)
                                  .withOpacity(0.4)),
                    ),
                    Container(
                      width: 13,
                      height: 13,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColor.darkPurple)
                                  .withOpacity(0.9)),
                    ),
                    Container(
                      width: 8,
                      height: 8,
                      margin:
                          EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color:
                              (Theme.of(context).brightness == Brightness.dark
                                      ? Colors.white
                                      : AppColor.darkPurple)
                                  .withOpacity(0.4)),
                    ),
                  ]),
          ])
        : Container();
  }

  Widget categoryNews(String category, int choose) {
    return choose == 0
        ? Column(
            children: [
              Text(
                category,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: AppColor.darkPurple
                        .withOpacity(indexNews == 1 ? 1 : 0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height(context) * 0.01,
              ),
              Container(
                height: 4,
                color:
                    AppColor.darkPurple.withOpacity(indexNews == 1 ? 1 : 0.4),
              )
            ],
          )
        : Column(
            children: [
              Text(
                category,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    color: AppColor.darkPurple
                        .withOpacity(indexNews == 0 ? 1 : 0.4),
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: height(context) * 0.01,
              ),
              Container(
                height: 4,
                color:
                    AppColor.darkPurple.withOpacity(indexNews == 0 ? 1 : 0.4),
              )
            ],
          );
  }

  // Widget listPromotion(data) {
  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //     child: data != null
  //         ? Column(
  //             children: [
  //               for (int i = 0; i < data.data.length; i++)
  //                 Column(
  //                   children: [
  //                     GestureDetector(
  //                       onTap: () {
  //                         data.data[i].totalView += 1;
  //                         Navigator.push(
  //                           context,
  //                           MaterialPageRoute(
  //                             builder: (context) => DetailNewsScreen(
  //                               news: data.data[i],
  //                               listNews: [data.data[i]],
  //                             ),
  //                           ),
  //                         );
  //                       },
  //                       child: Container(
  //                         decoration: BoxDecoration(
  //                           color: Colors.white,
  //                           borderRadius: BorderRadius.all(Radius.circular(20)),
  //                           boxShadow: [
  //                             BoxShadow(color: Colors.black12, blurRadius: 10),
  //                           ],
  //                         ),
  //                         height: height(context) * 0.5,
  //                         child: Column(
  //                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                           children: [
  //                             Column(
  //                               crossAxisAlignment: CrossAxisAlignment.start,
  //                               children: [
  //                                 Stack(children: [
  //                                   ClipRRect(
  //                                     borderRadius: BorderRadius.vertical(
  //                                         top: Radius.circular(20)),
  //                                     child: data.data[i].image != null
  //                                         ? Image.network(
  //                                             '${data.data[i].image}',
  //                                             fit: BoxFit.fitHeight,
  //                                             // height: height(context) * 0.4,
  //                                             // width: 1000,
  //                                           )
  //                                         : Image.asset(
  //                                             'assets/images/logo.png',
  //                                             fit: BoxFit.contain,
  //                                           ),
  //                                   ),
  //                                   Padding(
  //                                     padding:
  //                                         EdgeInsets.fromLTRB(20, 200, 20, 0),
  //                                     child: Text(
  //                                       'Promotion',
  //                                       overflow: TextOverflow.fade,
  //                                       style: TextStyle(
  //                                           fontFamily: 'Montserrat-M',
  //                                           fontSize: 16,
  //                                           color: AppColor.deepBlue,
  //                                           fontWeight: FontWeight.bold),
  //                                       textAlign: TextAlign.center,
  //                                     ),
  //                                   ),
  //                                 ]),
  //                                 SizedBox(
  //                                   height: 20,
  //                                 ),
  //                                 Padding(
  //                                   padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //                                   child: SizedBox(
  //                                     height: 40,
  //                                     child: Text(
  //                                       data.data[i].name,
  //                                       overflow: TextOverflow.ellipsis,
  //                                       maxLines: 3,
  //                                       style: TextStyle(
  //                                         fontFamily: 'Montserrat-M',
  //                                         fontSize: 16,
  //                                         color: Color(0xFF333333),
  //                                       ),
  //                                       textAlign: TextAlign.center,
  //                                     ),
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
  //                               child: Row(
  //                                 children: [
  //                                   Icon(
  //                                     Icons.schedule,
  //                                     color: Colors.grey,
  //                                     size: 36.0,
  //                                   ),
  //                                   SizedBox(
  //                                     width: 20,
  //                                   ),
  //                                   Text(
  //                                     formatDate(data.data[i].lastUpdated),
  //                                     overflow: TextOverflow.fade,
  //                                     style: TextStyle(
  //                                       fontFamily: 'Montserrat-M',
  //                                       fontSize: 16,
  //                                       color: Colors.grey,
  //                                     ),
  //                                     textAlign: TextAlign.center,
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             SizedBox(
  //                               height: 10,
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ),
  //                     SizedBox(
  //                       height: 10,
  //                     ),
  //                   ],
  //                 ),
  //             ],
  //           )
  //         : Center(
  //             child: Padding(
  //             padding: const EdgeInsets.only(bottom: 60.0),
  //             child: Text(
  //               "Không có dữ liệu.",
  //               style: TextStyle(
  //                   fontFamily: 'Montserrat-M',
  //                   fontSize: 20,
  //                   color: AppColor.darkPurple.withOpacity(0.4)),
  //             ),
  //           )),
  //   );
  // }

}

Widget listNewsH(BuildContext context, data, bool banner) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var useMobileLayout = shortestSide < 600;
  return data != null
      ? (data.data != null
          ? Column(
              children: [
                for (int i = 0; i < data.data.length; i++)
                  GestureDetector(
                    onTap: () {
                      data.data[i].totalView += 1;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailNewsScreen(
                            news: data.data[i],
                            listNews: data.data,
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
                              child: data.data[i]?.image == null
                                  ? Image.asset(
                                      'assets/images/logo.png',
                                      width: useMobileLayout ? 100 : 200,
                                      height: useMobileLayout ? 100 : 200,
                                    )
                                  : Image.network(data.data[i]?.image),
                            ),
                            SizedBox(
                              width: useMobileLayout ? 15 : 25,
                            ),
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Container(
                                  //   padding: useMobileLayout
                                  //       ? const EdgeInsets.all(5)
                                  //       : const EdgeInsets.all(10),
                                  //   decoration: BoxDecoration(
                                  //       color: Colors.grey[200],
                                  //       borderRadius: BorderRadius.circular(25)),
                                  //   child: Text(
                                  //     post?.categoryName,
                                  //     style:TextStyle(
                                  //     fontFamily: 'Montserrat-M',
                                  //         color: Colors.grey,
                                  //         fontSize: useMobileLayout ? 16 : 28),
                                  //   ),
                                  // ),
                                  // SizedBox(
                                  //   height: 5,
                                  // ),
                                  Container(
                                    padding: EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: Text(
                                      data.data[i]?.name,
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
                                      Text('${data.data[i].totalLike}')
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
                banner ? _getBanner(context) : Container(),
                SizedBox(
                  height: 20,
                )
              ],
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
            )))
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

_getBanner(BuildContext context) {
  var shortestSide = MediaQuery.of(context).size.shortestSide;
  var useMobileLayout = shortestSide < 600;
  final PageController _pageController = PageController(initialPage: 3);
  final departmentBloc = DepartmentBloc();

  return BlocProvider<DepartmentEvent, DepartmentState, DepartmentBloc>(
    bloc: departmentBloc,
    builder: (state) {
      var checkState = state.bannerNew == null;
      return checkState
          ? Container()
          : Container(
              height: useMobileLayout ? 160 : 280,
              child: PageView.builder(
                controller: _pageController,
                //onPageChanged: _onPageChanged,
                scrollDirection: Axis.horizontal,
                itemCount: state?.bannerNew?.length ?? 0,
                itemBuilder: (ctx, index) {
                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          state?.bannerNew[index].image,
                          fit: BoxFit.cover,
                        )),
                  );
                },
              ),
            );
    },
  );
}

String formatDate(String date) {
  DateTime todayDate = DateTime.parse(date);
  DateFormat formatter = DateFormat('dd MMM yyyy');
  String formatted = formatter.format(todayDate);
  return formatted;
}
