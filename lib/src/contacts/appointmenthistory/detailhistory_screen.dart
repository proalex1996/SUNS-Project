import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal/hospital/dto/appointment_history_model.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/input_rating_model.dart';
import 'package:suns_med/src/contacts/appointmenthistory/bmi_screen.dart';
import 'package:suns_med/src/contacts/appointmenthistory/results_screen.dart';
import 'package:suns_med/src/contacts/appointmenthistory/session_appointmenthistory_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/button.dart';

class DetailHistoryScreen extends StatefulWidget {
  final AppointmentHistoryModel appointmentHistoryModel;
  final String id;

  const DetailHistoryScreen({
    Key key,
    this.appointmentHistoryModel,
    this.id,
  }) : super(key: key);
  @override
  _DetailHistoryScreenState createState() => _DetailHistoryScreenState();
}

class _DetailHistoryScreenState extends State<DetailHistoryScreen> {
  final bloc = AppointmentHistoryBloc();
  final money = NumberFormat('#,###,000');

  InputRatingCommentModel inputRatingComment = InputRatingCommentModel();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  void initState() {
    super.initState();
    bloc.dispatch(LoadDetailMedicalExamination(id: this.widget.id));
    bloc.dispatch(AllowedRatingEvent(idExamination: widget.id));
  }

  bool stated = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      navigator: (state) {
        if (state.isRated == true) {
          _showSnackBar(AppLocalizations.of(context).voteSuccessful);
        }
      },
      bloc: bloc,
      builder: (state) {
        return Scaffold(
          key: _scaffoldKey,
          // appBar: AppBar(
          //   actions: [
          //     Container(
          //       padding: const EdgeInsets.only(right: 20),
          //       alignment: Alignment.centerRight,
          //       child: GestureDetector(
          //         onTap: () {
          //           if (state.isAllowed == false) {
          //             _showSnackBar(AppLocalizations.of(context).notVote);
          //           } else {
          //             if (inputRatingComment.comment != null ||
          //                 inputRatingComment.rating != null) {
          //               bloc.dispatch(
          //                 PostRatingEvent(
          //                   id: this.widget.id,
          //                   inputRatingComment: inputRatingComment,
          //                 ),
          //               );
          //             } else {
          //               _showSnackBar(AppLocalizations.of(context).enterVote);
          //             }
          //           }
          //         },
          //         child: Text(
          //           AppLocalizations.of(context).save,
          //           style:TextStyle(
          //     fontFamily: 'Montserrat-M',fontSize: 13),
          //         ),
          //       ),
          //     ),
          //   ],
          //   title: Text(
          //     AppLocalizations.of(context).historyDetail,
          //     style:TextStyle(
          //       fontFamily: 'Montserrat-M',color: Colors.white, fontSize: 18),
          //   ),
          //   centerTitle: true,

          // ),
          appBar: CustomAppBar(
            title: AppLocalizations.of(context).historyDetail,
            titleSize: 18,
            hasAcctionIcon: true,
            isTopPadding: false,
            actionIcon: Icon(Icons.save_outlined),
            onActionTap: () {
              if (state.isAllowed == false) {
                _showSnackBar(AppLocalizations.of(context).notVote);
              } else {
                if (inputRatingComment.comment != null ||
                    inputRatingComment.rating != null) {
                  bloc.dispatch(
                    PostRatingEvent(
                      id: this.widget.id,
                      inputRatingComment: inputRatingComment,
                    ),
                  );
                } else {
                  _showSnackBar(AppLocalizations.of(context).enterVote);
                }
              }
            },
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _buildCardTitle(AppLocalizations.of(context).examHistory),
                _buildContent(),
                _buildCardTitle(AppLocalizations.of(context).bodyIndex),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BMIScreen(
                          id: this.widget.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 20, top: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).viewDetail,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCardTitle(AppLocalizations.of(context).diagnosisAndExam),
                InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ResultsScreen(
                          id: this.widget.id,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                        left: 20, bottom: 20, top: 20, right: 21),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context).examinationResultsDetail,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                ),
                _buildCardTitle(AppLocalizations.of(context).rateComment),
                Container(
                  padding: const EdgeInsets.only(top: 20, bottom: 10),
                  child: Text(
                    AppLocalizations.of(context).giveStar,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // StarRating(
                //   rating: inputRatingComment?.rating == null
                //       ? state.detailMedicalExamination?.rating?.toDouble() ?? 0
                //       : inputRatingComment.rating.toDouble(),
                //   color: Colors.amber,
                //   size: 31,
                //   emptyColor: AppColor.pinkishGrey,
                //   enable: true,
                //   onRatingChanged: (rating) {
                //     setState(() {
                //       inputRatingComment.rating = rating.toInt();
                //     });
                //   },
                //   starCount: 5,
                // ),
                RatingBar.builder(
                  initialRating: inputRatingComment?.rating == null
                      ? state.detailMedicalExamination?.rating?.toDouble() ?? 0
                      : inputRatingComment.rating.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  // allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 31,
                  itemPadding: EdgeInsets.symmetric(horizontal: 1.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  onRatingUpdate: (rating) {
                    setState(() {
                      inputRatingComment.rating = rating.toInt();
                    });
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 20),
                  child: Text(
                    AppLocalizations.of(context).commentDoctor,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                // _buildCustomTextField(),

                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(blurRadius: 6, color: Colors.black12),
                      ],
                    ),
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: TextFormField(
                      initialValue: state.detailMedicalExamination?.comment,
                      onChanged: (t) {
                        inputRatingComment.comment = t;
                      },
                      maxLines: 6,
                      decoration: InputDecoration(
                        hintText: state.detailMedicalExamination?.comment ==
                                null
                            ? '${AppLocalizations.of(context).enterContent}...'
                            : state.detailMedicalExamination?.comment,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                      // maxLine: 6,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M', color: Colors.black),
                      // hintText: 'Nhập nội dung...',
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: const EdgeInsets.only(
                      left: 32, right: 32, top: 10, bottom: 20),
                  child: CustomButton(
                    color: AppColor.purple,
                    radius: BorderRadius.circular(26),
                    text: AppLocalizations.of(context).rateComment,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        color: Colors.white),
                    onPressed: () {
                      if (state.isAllowed == false) {
                        _showSnackBar(AppLocalizations.of(context).notVote);
                      } else {
                        if (inputRatingComment.comment != null ||
                            inputRatingComment.rating != null) {
                          bloc.dispatch(
                            PostRatingEvent(
                              id: this.widget.id,
                              inputRatingComment: inputRatingComment,
                            ),
                          );
                        } else {
                          _showSnackBar(AppLocalizations.of(context).enterVote);
                        }
                      }
                    },
                  ),
                ),
                // _buildCardTitle('Like'),
                // Container(
                //   padding: const EdgeInsets.only(
                //       left: 20, top: 5, bottom: 5, right: 20),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //     children: [
                //       Row(
                //         children: [
                //           Image.asset(
                //             'assets/images/ic_heart.png',
                //             width: 15,
                //             height: 13,
                //           ),
                //           SizedBox(
                //             width: 10.9,
                //           ),
                //           Text(
                //             'Chọn làm bác sĩ yêu thích',
                //             style:TextStyle(
                //       fontFamily: 'Montserrat-M',fontSize: 16),
                //           )
                //         ],
                //       ),
                //       CustomSwitch(
                //         activeColor: AppColor.pumpkin,
                //         value: stated,
                //         onChanged: (value) {
                //           stated = value;
                //         },
                //       )
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showSnackBar(msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  _buildContent() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        var time = output?.detailMedicalExamination?.createdTime == null
            ? ""
            : DateFormat.yMd("vi_VN").add_Hm().format(
                  DateTime.parse(output?.detailMedicalExamination?.createdTime
                      ?.toIso8601String()),
                );
        return Container(
          padding:
              const EdgeInsets.only(top: 19, left: 21, right: 20, bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).examType}:',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _buildExaminationType()
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).costExamination}',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "${money.format(output.detailMedicalExamination?.price ?? 0)} VND" ??
                        "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).patient}:',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    output.detailMedicalExamination?.name ?? "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).code} booking:',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    output.detailMedicalExamination?.appointmentCode ?? "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).examTime,
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    time ?? "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).doctor}:',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    output.detailMedicalExamination?.staffName ?? "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  Text(
                    '${AppLocalizations.of(context).address}:',
                    style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    output.detailMedicalExamination?.staffAddress ?? "",
                    style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _buildCardTitle(String text) {
    return Container(
      decoration: BoxDecoration(color: AppColor.veryLightPinkFour, boxShadow: [
        BoxShadow(
          blurRadius: 6,
          color: Colors.black12,
          offset: Offset(0, 3),
          spreadRadius: 0,
        ),
      ]),
      padding: const EdgeInsets.only(left: 21),
      alignment: Alignment.centerLeft,
      width: double.infinity,
      height: 40,
      child: Text(
        text,
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColor.deepBlue),
      ),
    );
  }

  _buildExaminationType() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
            AppointmentHistoryBloc>(
        bloc: bloc,
        builder: (output) {
          if (output.detailMedicalExamination?.special == true) {
            return Text(
              AppLocalizations.of(context).serviceExamination,
              style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
            );
          } else {
            return Text(
              AppLocalizations.of(context).examinationBhyt,
              style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
            );
          }
        });
  }
}
