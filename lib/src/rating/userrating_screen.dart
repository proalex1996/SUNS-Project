import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/dto/rating_input.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/rating/session_rating_bloc.dart';

class UserRatingScreen extends StatefulWidget {
  final String companyId;
  final CompanyType companyType;
  UserRatingScreen({this.companyId, @required this.companyType});
  @override
  _UserRatingScreenState createState() => _UserRatingScreenState();
}

class _UserRatingScreenState extends State<UserRatingScreen> {
  // final TextEditingController _commentController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final bloc = SessionBloc();
  final ratingBloc = RatingBloc();
  final detailCompanyBloc = DetailItemBloc();
  RatingInput rateComment = RatingInput();

  @override
  void initState() {
    super.initState();
    detailCompanyBloc.dispatch(EventResetIsRated());
    // rateComment = RateCommentModel(userName: "948819199", clinicId: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text(
          "Đánh giá",
          style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 18),
        ),
        backgroundColor: AppColor.deepBlue,
      ),
      body: BlocProvider<EventSession, StateSession, SessionBloc>(
          bloc: bloc,
          builder: (state) {
            return BlocProvider<DetailItemEvent, DetailItemState,
                    DetailItemBloc>(
                bloc: detailCompanyBloc,
                navigator: (detailCompanyState) {
                  if (detailCompanyState.isRated == true) {
                    Navigator.pop(context);
                  }
                },
                builder: (detailCompanyState) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          color: AppColor.whiteFive,
                          alignment: Alignment.center,
                          height: 147,
                          child: Column(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(top: 21),
                                child: CircleAvatar(
                                  maxRadius: 40,
                                  backgroundColor: AppColor.greyColor,
                                  backgroundImage: state.user.avatar == null
                                      ? AssetImage("assets/images/avatar2.png")
                                      : NetworkImage(state.user.avatar),
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                state.user.fullName.isEmpty
                                    ? "Hãy cập nhật thông tin của bạn ${state.user.phoneNumber}"
                                    : state.user?.fullName,
                                // state.user.phoneNumber,
                                style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 16,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: Text(
                            'Cho sao đánh giá',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: AppColor.deepBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 23.6,
                        ),
                        Center(
                          child: StarRating(
                            rating: rateComment?.rating == null
                                ? 0
                                : rateComment.rating.toDouble(),
                            color: Colors.amber,
                            size: 31,
                            emptyColor: AppColor.pinkishGrey,
                            enable: true,
                            onRatingChanged: (rating) {
                              setState(() {
                                rateComment.rating = rating.toInt();
                              });
                            },
                            starCount: 5,
                          ),
                        ),
                        SizedBox(
                          height: 21.4,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21),
                          child: Text(
                            'Viết đánh giá',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: AppColor.deepBlue,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 21, right: 19),
                          child: TextField(
                              onChanged: (t) {
                                rateComment.comment = t;
                              },
                              maxLines: 6,
                              // controller: _commentController,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                  color: Colors.black),
                              textAlign: TextAlign.left,
                              decoration: InputDecoration(
                                  hintText:
                                      "Nói cho mọi người biết trải nghiệm của bạn",
                                  hintStyle: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 13,
                                      color: Color(0xffcac8cd)),
                                  border: OutlineInputBorder(
                                      borderRadius:
                                          BorderRadius.circular(10)))),
                        ),
                        Container(
                          padding: const EdgeInsets.only(
                              top: 24, left: 33, right: 30),
                          child: RaisedButton(
                              onPressed: () {
                                if (rateComment.comment == null ||
                                    rateComment.rating == null) {
                                  scaffoldKey.currentState.showSnackBar(
                                    SnackBar(
                                      content: Text(
                                          'Vui lòng điền đầy đủ thông tin để đánh giá.'),
                                    ),
                                  );
                                } else {
                                  detailCompanyBloc.dispatch(
                                    EventPostInputRating(
                                      rateCommentModel: rateComment,
                                      companyId: this.widget.companyId,
                                      companyType: this.widget.companyType ==
                                              CompanyType.Doctor
                                          ? 'Doctor'
                                          : this.widget.companyType ==
                                                  CompanyType.Hospital
                                              ? 'Hospital'
                                              : 'Clinic',
                                    ),
                                  );
                                }
                              },
                              color: AppColor.deepBlue,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              child: Container(
                                height: 46,
                                alignment: Alignment.center,
                                width: double.infinity,
                                color: AppColor.deepBlue,
                                child: Text(
                                  "Đánh giá",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      color: Colors.white),
                                ),
                              )),
                        ),
                      ],
                    ),
                  );
                });
          }),
    );
  }
}
