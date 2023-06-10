import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:share/share.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/comment_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/news/dto/postnews_model.dart';
import 'package:suns_med/src/account/updateinformation_screen.dart';
import 'package:suns_med/src/home/session_home_bloc.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

import 'package:suns_med/src/news/session_news_bloc.dart';
import 'package:suns_med/src/news/news_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/paging_result.dart';

class DetailNewsScreen extends StatefulWidget {
  final PostNewsModel news;
  var listNews;
  PagingResult<PostNewsModel> dataNews;
  DetailNewsScreen(
      {@required this.news, @required this.listNews, this.dataNews});

  @override
  _DetailNewsScreenState createState() => _DetailNewsScreenState();
}

class _DetailNewsScreenState extends State<DetailNewsScreen> {
  PostNewsModel _newsModel;
  var _listNews;
  String text = 'https://suns.com.vn/';
  CommentModel commentModel = CommentModel();
  TextEditingController _textController = TextEditingController();
  final bloc = NewsBloc();
  final homeBloc = HomeBloc();
  final blocSession = SessionBloc();

  Future<Null> _refreshHome() async {
    setState(() {});
  }

  bool _checkSpaceSpace(String value) {
    Pattern pattern = r'(?=.*?[A-Za-z])';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  @override
  void initState() {
    super.initState();

    bloc.dispatch(
        ViewEvent(id: widget?.news?.id, type: widget.news.categoryId));
    bloc.dispatch(LoadHasLikeEvent(id: widget?.news?.id));
    _newsModel = this.widget.news;
    _listNews = this.widget.listNews;
  }

  @override
  Widget build(BuildContext context) {
    String date = this.widget.news.lastUpdated;
    DateTime datetime = DateTime.parse(date);
    return Scaffold(
      appBar: const TopAppBar(),
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: BlocProvider<NewsEvent, NewsState, NewsBloc>(
          bloc: bloc,
          builder: (state) {
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    (_newsModel.image != null)
                        ? Container(
                            width: width(context),
                            height: width(context),
                            decoration: BoxDecoration(
                              //color: Color(0xFFF4794C),
                              image: DecorationImage(
                                //alignment: Alignment.bottomRight,
                                image: NetworkImage(
                                  _newsModel.image,
                                ),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    alignment: Alignment.centerLeft,
                                    padding: EdgeInsets.only(top: 10, left: 10),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Stack(
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: Colors.white,
                                          ),
                                          Icon(
                                            Icons.arrow_back,
                                            size: 28,
                                            color: AppColor.orangeColor,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        // height: height(context) * 0.2,
                                        // width: width(context) * 0.8,
                                        child: Text(
                                          DateFormat.MMMMd('en_US')
                                                  .format(datetime)
                                                  .toString() +
                                              ' AT ' +
                                              DateFormat('h:mm a')
                                                  .format(datetime)
                                                  .toString(),
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            color: AppColor.white,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        : Container(
                            width: width(context),
                            height: width(context),
                            decoration: BoxDecoration(
                              //color: Color(0xFFF4794C),
                              image: DecorationImage(
                                //alignment: Alignment.bottomRight,
                                image: AssetImage('assets/images/logo.png'),
                                fit: BoxFit.fitWidth,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Stack(children: [
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: AppColor.orangeColor,
                                        iconSize: 30,
                                        onPressed: () {
                                          Navigator.pop(
                                              context, this.widget.dataNews);
                                        },
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.centerLeft,
                                      child: IconButton(
                                        icon: Icon(Icons.arrow_back),
                                        color: Colors.white,
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    )
                                  ]),
                                  SizedBox(
                                    height: height(context) * 0.2,
                                  ),
                                  Expanded(
                                    child: Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          DateFormat.MMMMd('en_US')
                                                  .format(datetime)
                                                  .toString() +
                                              ' AT ' +
                                              DateFormat('h:mm a')
                                                  .format(datetime)
                                                  .toString(),
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )),
                    SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(
                          width(context) * 0.05, 0, width(context) * 0.07, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.favorite_border_outlined,
                                color: AppColor.deepBlue,
                              ),
                              SizedBox(
                                width: 6.8,
                              ),
                              Text(
                                '${_convertIntToFriendlyString(_newsModel.totalLike)}',
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.veryLightPinkTwo),
                              ),
                            ],
                          ),
                          Container(
                            height: height(context) * 0.05,
                            width: width(context) * 0.25,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: Colors.black45),
                            ),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(11, 0, 5, 0),
                              child: GestureDetector(
                                onTap: () {
                                  if (state?.hasLike == false) {
                                    bloc.dispatch(LikeEvent(
                                        id: widget?.news?.id,
                                        type: widget.news.categoryId));
                                  } else {
                                    bloc.dispatch(UnLikeEvent(
                                        id: widget?.news?.id,
                                        type: widget.news.categoryId));
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                      child: state.hasLike == true
                                          ? Icon(
                                              Icons.favorite,
                                              color: Color(0xFFEB7A4C),
                                            )
                                          : Icon(
                                              Icons.favorite_border_outlined,
                                              color: AppColor.deepBlue,
                                            ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Expanded(
                                      child: Text(
                                        AppLocalizations.of(context).like,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 14,
                                            color: AppColor.darkPurple),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 12,
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: Column(
                          children: [
                            Text(
                              _buildTitle(),
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 20,
                                  color: AppColor.darkPurple,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(
                              height: 10,
                              color: Colors.black54,
                            ),
                          ],
                        ),
                      ),
                    ),

                    _newsModel.description == null
                        ? SizedBox()
                        : Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            child: Html(
                              data: _renderHtml(_newsModel.description),
                              customTextStyle:
                                  (dom.Node node, TextStyle baseStyle) {
                                return baseStyle.merge(
                                  TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: Color(0xFF2E3E5C),
                                      fontSize: 16),
                                );
                              },
                              onLinkTap: (url) {
                                print("Opening $url...");
                              },
                              customRender: (node, children) {
                                if (node is dom.Element) {
                                  switch (node.localName) {
                                    case "custom_tag":
                                      return Column(children: children);
                                  }
                                }
                                return null;
                              },
                            ),
                          ),
                    Divider(
                      endIndent: 20,
                      indent: 20,
                      color: AppColor.veryLightPinkTwo,
                      height: 20,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: height(context) * 0.01,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: width(context) * 0.05),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).relatedArticles,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              color: AppColor.darkPurple,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                          overflow: TextOverflow.fade,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: height(context) * 0.03,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          for (int i = 0; i < _listNews.length; i++)
                            Row(
                              children: [
                                SizedBox(
                                  width: width(context) * 0.05,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    _listNews[i].totalView += 1;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailNewsScreen(
                                          news: _listNews[i],
                                          listNews: [_listNews[i]],
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10),
                                      ],
                                    ),
                                    height: 300,
                                    width: width(context) * 0.9,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              10), //or 15.0
                                          child: _listNews[i].image == null
                                              ? Image.asset(
                                                  'assets/images/logo.png',
                                                  fit: BoxFit.contain,
                                                  height:
                                                      height(context) * 0.25,
                                                )
                                              : Image.network(
                                                  _listNews[i].image,
                                                  height:
                                                      height(context) * 0.25,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          '${_listNews[i].name}',
                                          overflow: TextOverflow.fade,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 16,
                                              color: AppColor.darkPurple,
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.left,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width(context) * 0.02,
                                )
                              ],
                            ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: height(context) * 0.03,
                    ),
                    // BlocProvider<EventSession, StateSession, SessionBloc>(
                    //   bloc: SessionBloc(),
                    //   builder: (state) {
                    //     return Padding(
                    //       padding: EdgeInsets.only(left: 20, right: 20),
                    //       child: TextField(
                    //         enabled: false,
                    //         controller: _textController,
                    //         // onChanged: (t) {
                    //         //   _textController.text = t;
                    //         // },
                    //         decoration: new InputDecoration(
                    //             //enabled: false,
                    //             hintText: "Bình luận",
                    //             contentPadding:
                    //                 EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    //             labelStyle:
                    //                 newTextStyle(
                    //            fontFamily: 'Montserrat-M',color: const Color(0xFF424242)),
                    //             border: new UnderlineInputBorder(
                    //               borderSide: new BorderSide(color: Colors.red),
                    //             ),
                    //             prefixIcon: Padding(
                    //               padding:
                    //                   const EdgeInsets.only(bottom: 10, right: 10),
                    //               child: CircleAvatar(
                    //                 maxRadius: 15,
                    //                 backgroundColor: AppColor.greyColor,
                    //                 backgroundImage: state.user.avatar == null
                    //                     ? AssetImage("assets/images/avatar2.png")
                    //                     : NetworkImage(state.user.avatar),
                    //               ),
                    //             ),
                    //             suffixIcon: IconButton(
                    //               icon: Icon(Icons.send),
                    //               onPressed: () {
                    //                 if (_textController != null &&
                    //                     _textController.text.isNotEmpty &&
                    //                     _checkSpaceSpace(_textController.text) ==
                    //                         true) {
                    //                   commentModel.description =
                    //                       _textController.text;
                    //                   bloc.dispatch(CommentEvent(
                    //                       id: widget.news.id,
                    //                       commentModel: commentModel));

                    //                   _textController.clear();
                    //                 }
                    //               },
                    //             )),
                    //       ),
                    //       // child: TextField(
                    //       //   decoration: InputDecoration(
                    //       //     border: InputBorder.none,
                    //       //     hintText: "Bình luận",
                    //       //     hintStyle:TextStyle(
                    //               fontFamily: 'Montserrat-M',fontSize: 15, color: AppColor.lavender),
                    //       //   ),
                    //       // ),
                    //     );
                    //   },
                    // ),
                    // BlocProvider<NewsEvent, NewsState, NewsBloc>(
                    //     bloc: bloc,
                    //     builder: (state) {
                    //       var res = state.resultComment?.data;

                    //       return Padding(
                    //         padding: const EdgeInsets.all(20),
                    //         child: Wrap(
                    //           children: List.generate(res?.length ?? 0, (index) {
                    //             var userRatingId = res[index]?.createdById ?? 0;
                    //             var userValue = state?.listUserRating?.any(
                    //                         (element) =>
                    //                             int.parse(element.id) ==
                    //                             userRatingId) ==
                    //                     true
                    //                 ? state?.listUserRating?.firstWhere((element) =>
                    //                     int.parse(element.id) == userRatingId)
                    //                 : null;
                    //             return Padding(
                    //               padding:
                    //                   const EdgeInsets.only(bottom: 10, top: 10),
                    //               child: Row(
                    //                 mainAxisAlignment:
                    //                     MainAxisAlignment.spaceBetween,
                    //                 children: [
                    //                   Row(
                    //                     children: [
                    //                       // userValue.avatar == null
                    //                       //     ? Image.asset(
                    //                       //         "assets/images/avatar2.png",
                    //                       //         width: 40,
                    //                       //         height: 40,
                    //                       //       )
                    //                       //     : Image.network(
                    //                       //         userValue?.avatar,
                    //                       //         width: 40,
                    //                       //         height: 40,
                    //                       //       ),
                    //                       _renderImage(userValue?.avatar),
                    //                       SizedBox(
                    //                         width: 15,
                    //                       ),
                    //                       Column(
                    //                         mainAxisAlignment:
                    //                             MainAxisAlignment.spaceBetween,
                    //                         crossAxisAlignment:
                    //                             CrossAxisAlignment.start,
                    //                         children: [
                    //                           Text(
                    //                             userValue?.fullName ?? "",
                    //                             style:TextStyle(
                    //               fontFamily: 'Montserrat-M',
                    //                                 fontSize: 14,
                    //                                 color: Colors.black,
                    //                                 fontWeight: FontWeight.bold),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           Text(
                    //                             res[index].description,
                    //                             maxLines: 30,
                    //                             style:TextStyle(
                    //                 fontFamily: 'Montserrat-M',
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                           SizedBox(
                    //                             height: 5,
                    //                           ),
                    //                           Text(
                    //                             res[index].createdTime == null
                    //                                 ? ""
                    //                                 : timeago.format(
                    //                                     (res[index].createdTime),
                    //                                     locale: 'vi'),
                    //                             maxLines: 30,
                    //                             style:TextStyle(
                    //                 fontFamily: 'Montserrat-M',
                    //                                 fontSize: 14,
                    //                                 color: Colors.black),
                    //                           ),
                    //                         ],
                    //                       ),
                    //                     ],
                    //                   ),
                    //                   sessionBloc.state.user.id ==
                    //                           res[index].createdById.toString()
                    //                       ? IconButton(
                    //                           icon: Icon(Icons.delete_sharp),
                    //                           onPressed: () {
                    //                             bloc.dispatch(DeleteCommentEvent(
                    //                               commentId: res[index]?.id,
                    //                               userId: res[index]?.createdById,
                    //                               newsId: widget.news.id,
                    //                             ));
                    //                           },
                    //                         )
                    //                       : Container(),
                    //                 ],
                    //               ),
                    //             );
                    //           }),
                    //         ),
                    //       );
                    //     })
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _renderHtml(String content) {
    return '<!DOCTYPE html><html lang="en"><head> <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>Content</title></head><body>$content</body></html>';
  }

  _renderImage(String image) {
    Widget result;
    var imageDefault = 'assets/images/avatar2.png';
    if (image != null && image.isNotEmpty) {
      result = CachedNetworkImage(
        imageUrl: image,
        imageBuilder: (context, imageProvider) => Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            image: DecorationImage(
              image: imageProvider,
            ),
          ),
        ),
        placeholder: (context, url) => CircularProgressIndicator(),
        errorWidget: (context, url, error) => CircleAvatar(
          maxRadius: 30,
          backgroundColor: Color(0xffebeaef),
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                image: DecorationImage(
                    image: AssetImage('assets/images/ic_persondefault.png'))),
          ),
        ),
      );
    } else {
      result = Container(
        child: Image.asset(
          imageDefault,
          width: 60,
          height: 60,
        ),
      );
    }
    return result;
  }

  _onShare(BuildContext context) async {
    final RenderBox box = context.findRenderObject();

    await Share.share(text,
        sharePositionOrigin: box.localToGlobal(Offset.zero) & box.size);
    bloc.dispatch(
        ShareEvent(id: widget?.news?.id, type: widget.news.categoryId));
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

  String _buildTitle() {
    if (_newsModel.name == null) {
      return "Không có tiêu đề ?";
    } else {
      return _newsModel.name;
    }
  }
}
