import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/appointment_history_item.dart';
import 'package:suns_med/src/Widgets/rating.dart';
import 'package:suns_med/src/contacts/appointmenthistory/bmi_screen.dart';
import 'package:suns_med/src/contacts/appointmenthistory/results_screen.dart';
import 'package:suns_med/src/contacts/healthchart_screen.dart';
import 'package:suns_med/src/contacts/qrcode_screen.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/src/account/updateinformation_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'appointmenthistory/detailhistory_screen.dart';
import 'appointmenthistory/session_appointmenthistory_bloc.dart';
import 'package:suns_med/src/contacts/appointmenthistory/appointmenthistory_screen.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/medicalexamination/dto/input_rating_model.dart';
import 'package:flutter_rating_bar/src/rating_bar.dart';

class DetailContactScreen extends StatefulWidget {
  final ContactModel contactModel;
  final String relationShipValue;
  final String genderValue;
  const DetailContactScreen({
    Key key,
    this.contactModel,
    this.genderValue,
    this.relationShipValue,
  }) : super(key: key);

  @override
  _DetailContactScreenState createState() => _DetailContactScreenState();
}

class _DetailContactScreenState extends State<DetailContactScreen> {
  final bloc = ContactBloc();
  final historyBloc = AppointmentHistoryBloc();
  bool _isShowHistory = false;
  final money = NumberFormat('#,###,000');
  //  final notifyBloc = NotificationBloc();
  TextEditingController controller = TextEditingController();
  final blocSession = SessionBloc();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  InputRatingCommentModel inputRatingComment = InputRatingCommentModel();
  int rating = 0;
  bool clicked = false;
  @override
  void initState() {
    bloc.dispatch(LoadContactEvent());
    bloc.dispatch(LoadRelationship());
    bloc.dispatch(LoadGenderEvent());
    bloc.dispatch(LoadTotalCostEvent(id: widget.contactModel?.id));
    historyBloc.dispatch(LoadRelationshipHistoryEvent());
    historyBloc.dispatch(LoadMedicalExamination(id: widget?.contactModel?.id));
    historyBloc.dispatch(LoadMedicalExamination(id: widget?.contactModel?.id));
    super.initState();
  }

  Future<Null> _refresh() async {
    bloc.dispatch(LoadContactEvent());
    bloc.dispatch(LoadRelationship());
    bloc.dispatch(LoadGenderEvent());
    bloc.dispatch(LoadTotalCostEvent(id: widget.contactModel?.id));
    historyBloc.dispatch(LoadRelationshipHistoryEvent());
    historyBloc.dispatch(LoadMedicalExamination(id: widget?.contactModel?.id));
    historyBloc.dispatch(LoadMedicalExamination(id: widget?.contactModel?.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const TopAppBar(),
      body: RefreshIndicator(onRefresh: _refresh, child: bodyBuilding()),
    );
  }

  Widget bodyBuilding() {
    return BlocProvider<ContactEvent, ContactState, ContactBloc>(
        bloc: bloc,
        builder: (output) {
          return SingleChildScrollView(
            child: Container(
              color: Color(0xFFF2F8FF),
              child: Column(
                children: [
                  Stack(children: [
                    CustomAppBar(
                      title: AppLocalizations.of(context).relatedDetail,
                      titleSize: 24,
                      isOrangeAppBar: true,
                      isTopPadding: true,
                      // topPadding: 40,
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(width(context) * 0.05,
                          height(context) * 0.13, width(context) * 0.05, 0),
                      child: Column(
                        children: [
                          Container(
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(25, 20, 20, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10),
                                      ],
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // SizedBox(
                                        //   height: 5,
                                        // ),
                                        Text(
                                          AppLocalizations.of(context)
                                              .totalCostExamination,
                                          overflow: TextOverflow.fade,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 14,
                                            color: Color(0xFF9093A3),
                                          ),
                                          textAlign: TextAlign.left,
                                        ),
                                        SizedBox(
                                          height: 6,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              (output?.totalCost == null)
                                                  ? '0 đ'
                                                  : '${money.format(output?.totalCost)} đ',
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: TextStyle(
                                                  fontFamily: 'Montserrat-M',
                                                  fontSize: 24,
                                                  color: AppColor.darkPurple,
                                                  fontWeight: FontWeight.bold),
                                              textAlign: TextAlign.left,
                                            ),
                                            IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: const Icon(
                                                  Icons.chevron_right),
                                              iconSize: width(context) * 0.1,
                                              onPressed: () {},
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.05,
                          ),
                          Row(
                            children: [
                              image(null),
                              SizedBox(
                                width: width(context) * 0.1,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (widget?.contactModel?.fullName == null)
                                          ? 'Tên chưa xác định'
                                          : widget?.contactModel?.fullName,
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 16,
                                          color: AppColor.darkPurple,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      (widget?.relationShipValue == null)
                                          ? '${AppLocalizations.of(context).relationship} Bạn bè'
                                          : '${AppLocalizations.of(context).relationship} ${widget?.relationShipValue}',
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: Color(0xFF9093A3),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      (widget?.contactModel?.id == null)
                                          ? '${AppLocalizations.of(context).profileID} Chưa xác định'
                                          : '${AppLocalizations.of(context).profileID} ${widget?.contactModel?.id}',
                                      overflow: TextOverflow.fade,
                                      maxLines: 2,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: Color(0xFF9093A3),
                                      ),
                                      textAlign: TextAlign.left,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: height(context) * 0.05,
                          ),
                          Container(
                            width: width(context),
                            padding: EdgeInsets.fromLTRB(25, 20, 20, 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  (widget?.contactModel?.email == null)
                                      ? 'Email chưa xác định'
                                      : '${widget?.contactModel?.email}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Color(0xFF9093A3),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  (widget?.contactModel?.birthDay == null)
                                      ? 'Chuwa xác định ngày sinh'
                                      : DateFormat.yMd('vi').format(
                                          widget?.contactModel?.birthDay),
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Color(0xFF9093A3),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  (widget?.contactModel?.phoneNumber == null)
                                      ? 'SĐT chưa xác định'
                                      : '${widget?.contactModel?.phoneNumber}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Color(0xFF9093A3),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  (widget?.genderValue == null)
                                      ? 'Giới tính chưa xác định'
                                      : '${widget?.genderValue}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Color(0xFF9093A3),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                                Text(
                                  (widget?.contactModel?.address == null)
                                      ? 'Địa chỉ chưa xác định'
                                      : '${widget?.contactModel?.address}',
                                  overflow: TextOverflow.fade,
                                  maxLines: 2,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: Color(0xFF9093A3),
                                  ),
                                  textAlign: TextAlign.left,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: height(context) * 0.02,
                          ),
                          cardInfomation(
                            'QR Code',
                            'code',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => QRCodeScreen(
                                    qrcodeModel: widget.contactModel,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: height(context) * 0.02,
                          ),
                          cardInfomation(
                            AppLocalizations.of(context).health,
                            '',
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HealthChartScreen(
                                    idContact: widget.contactModel.id,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: height(context) * 0.02,
                          ),
                          BlocProvider<
                                  AppointmentHistoryEvent,
                                  AppointmentHistoryState,
                                  AppointmentHistoryBloc>(
                              bloc: historyBloc,
                              builder: (history) {
                                var exam = history?.medicalExamination;
                                return Column(children: [
                                  cardHistory(
                                      AppLocalizations.of(context).examHistory,
                                      '', () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            AppointmentHistoryScreen(
                                          contactId: widget.contactModel.id,
                                        ),
                                      ),
                                    );
                                  }),
                                  SizedBox(
                                    height: height(context) * 0.02,
                                  ),
                                  cardInfomation(
                                      AppLocalizations.of(context).bodyIndex,
                                      '', () {
                                    (exam.isEmpty || exam == null)
                                        ? showInSnackBar(
                                            AppLocalizations.of(context)
                                                .notData)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BMIScreen(
                                                id: exam?.first?.id,
                                              ),
                                            ),
                                          );
                                  }),
                                  SizedBox(
                                    height: height(context) * 0.02,
                                  ),
                                  cardInfomation(
                                      AppLocalizations.of(context).diagnosis,
                                      '', () {
                                    (exam.isEmpty || exam == null)
                                        ? showInSnackBar(
                                            AppLocalizations.of(context)
                                                .notData)
                                        : Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ResultsScreen(
                                                id: exam?.first?.id,
                                              ),
                                            ),
                                          );
                                  }),
                                  SizedBox(
                                    height: height(context) * 0.02,
                                  ),
                                  cardRating(
                                      AppLocalizations.of(context).rateComment,
                                      '',
                                      context),
                                  SizedBox(
                                    height: height(context) * 0.05,
                                  ),
                                ]);
                              })
                        ],
                      ),
                    )
                  ]),
                ],
              ),
            ),
          );
        });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
  }

  Widget cardInfomation(String title, String code, Function onTap) {
    return Container(
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                boxShadow: [
                  BoxShadow(color: Colors.black12, blurRadius: 10),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          '$title',
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 14,
                              color: AppColor.darkPurple,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.left,
                        ),
                      ),
                      Row(
                        children: [
                          () {
                            if (code != '') {
                              return QrImage(
                                data: '$code',
                                size: 50,
                              );
                            } else {
                              return Container(
                                width: width(context) * 0.12,
                              );
                            }
                          }(),
                          IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(Icons.chevron_right),
                            iconSize: width(context) * 0.1,
                            onPressed: onTap,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardHistory(String title, String code, Function onTap) {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
            AppointmentHistoryBloc>(
        bloc: historyBloc,
        builder: (history) {
          var exam = history?.medicalExamination;
          return Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    '$title',
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.bold),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.chevron_right),
                                  iconSize: width(context) * 0.1,
                                  onPressed: onTap,
                                  padding: EdgeInsets.zero,
                                ),
                              ],
                            ),
                          ],
                        ),
                        (exam == null || exam.isEmpty == true)
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(AppLocalizations.of(context).notData),
                                  SizedBox(height: height(context) * 0.02),
                                ],
                              )
                            : Column(
                                children: [
                                  rowContent(
                                      AppLocalizations.of(context).examType,
                                      exam?.first?.servicePackageName ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      AppLocalizations.of(context)
                                          .costExamination,
                                      (exam?.first?.price == null)
                                          ? AppLocalizations.of(context)
                                              .notUpdate
                                          : '${money.format(exam?.first?.price)} VND'),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      AppLocalizations.of(context).patient,
                                      exam?.first?.name ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      '${AppLocalizations.of(context).code} Booking',
                                      exam?.first?.appointmentCode ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      AppLocalizations.of(context)
                                          .dateOfExamination,
                                      DateFormat.yMd("vi_VN").add_Hm().format(
                                              exam?.first?.createdTime) ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      '${AppLocalizations.of(context).doctor}:',
                                      exam?.first?.staffName ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                  rowContent(
                                      AppLocalizations.of(context).address,
                                      exam?.first?.address ??
                                          AppLocalizations.of(context)
                                              .notUpdate),
                                  SizedBox(height: height(context) * 0.02),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget cardRating(String title, String code, BuildContext context) {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
            AppointmentHistoryBloc>(
        bloc: historyBloc,
        builder: (history) {
          var exam = history?.medicalExamination;
          return Container(
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(25, 10, 20, 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 10),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '$title',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 14,
                                  color: AppColor.darkPurple,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                            // SizedBox(
                            //   width: width(context) * 0.3,
                            // ),
                            IconButton(
                              padding: EdgeInsets.zero,
                              icon: const Icon(Icons.chevron_right),
                              iconSize: width(context) * 0.1,
                              onPressed: () {},
                              alignment: Alignment.centerRight,
                            ),
                          ],
                        ),
                        // Center(
                        //   child: StarRating(
                        //     size: 23,
                        //     rating: exam?.first?.rating == null
                        //         ? 0
                        //         : exam.first.rating.toDouble(),
                        //     color: Colors.amber,
                        //     emptyColor: AppColor.pinkishGrey,
                        //     enable: true,
                        //     onRatingChanged: (rating) {
                        //       setState(() {
                        //         exam?.first?.rating = rating.toInt();
                        //       });
                        //     },
                        //     starCount: 5,
                        //   ),
                        // ),
                        RatingBar.builder(
                          initialRating: inputRatingComment?.rating == null
                              ? historyBloc
                                      .state.detailMedicalExamination?.rating
                                      ?.toDouble() ??
                                  0
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
                        SizedBox(height: 15),
                        Column(
                          children: [
                            Container(
                                height: height(context) * 0.25,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFFFFFFFF),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(0xFFF2F2F2),
                                        spreadRadius: 2),
                                  ],
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 13),
                                  child: Container(
                                      padding: const EdgeInsets.all(10),
                                      child: TextFormField(
                                        maxLines: 10,
                                        decoration: InputDecoration(
                                          // hintText: 'What do people call you?',
                                          hintText: AppLocalizations.of(context)
                                              .experienceComment,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hintMaxLines: 3,
                                        ),
                                        onChanged: (value) {
                                          setState(() {
                                            inputRatingComment.comment = value;
                                          });
                                        },
                                        onSaved: (String value) {
                                          controller.text = value;
                                          return controller.text;
                                        },
                                        onFieldSubmitted: (String value) {
                                          controller.text = value;
                                          showToastMessage(value);
                                        },
                                        validator: (String value) {
                                          return (value != null &&
                                                  value.contains('@'))
                                              ? 'Do not use the @ char.'
                                              : null;
                                        },
                                      )),
                                )),
                            SizedBox(height: 15),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                padding: EdgeInsets.fromLTRB(
                                    width(context) * 0.2,
                                    5,
                                    width(context) * 0.2,
                                    5),
                                child: GestureDetector(
                                  onTap: () async {
                                    if (historyBloc.state.medicalExamination
                                            .isNotEmpty ||
                                        historyBloc.state.medicalExamination !=
                                            null) {
                                      historyBloc.dispatch(AllowedRatingEvent(
                                        idExamination: historyBloc
                                            .state.medicalExamination.first.id,
                                      ));

                                      print(
                                        historyBloc
                                            .state.medicalExamination.first.id,
                                      );

                                      print(
                                          'comment: ${inputRatingComment.comment}, star: ${inputRatingComment.rating}');
                                      Future.delayed(
                                          Duration(milliseconds: 900), () {
                                        print(historyBloc.state.isAllowed);
                                        if (historyBloc.state.isAllowed ==
                                            false) {
                                          _showSnackBar(
                                              AppLocalizations.of(context)
                                                  .notVote);
                                        } else {
                                          if (inputRatingComment.comment !=
                                                  null ||
                                              inputRatingComment.rating !=
                                                  null) {
                                            historyBloc.dispatch(
                                              PostRatingEvent(
                                                id: historyBloc
                                                    .state
                                                    .medicalExamination
                                                    .first
                                                    .id,
                                                inputRatingComment:
                                                    inputRatingComment,
                                              ),
                                            );
                                          } else {
                                            _showSnackBar(
                                                AppLocalizations.of(context)
                                                    .enterVote);
                                          }
                                        }
                                      });
                                      if (historyBloc.state.isRated == true) {
                                        _showSnackBar(
                                            AppLocalizations.of(context)
                                                .voteSuccessful);
                                      }
                                    } else
                                      _showSnackBar(
                                          AppLocalizations.of(context).notData);
                                  },
                                  child: Container(
                                    height: height(context) * 0.05,
                                    width: width(context),
                                    decoration: BoxDecoration(
                                      color: AppColor.deepBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(50)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 10),
                                      ],
                                    ),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Text(
                                        AppLocalizations.of(context)
                                            .submitComment,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  void _showSnackBar(String msg) {
    final snackBar = SnackBar(content: Text(msg));
    _scaffoldKey.currentState.showSnackBar(snackBar);
  }

  Widget rowContent(String title, String content) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            '$title',
            // overflow: TextOverflow.fade,
            maxLines: 2,
            style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 14,
              color: Color(0xFF9093A3),
            ),
            textAlign: TextAlign.left,
          ),
        ),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              '$content',
              // overflow: TextOverflow.ellipsis,
              // maxLines: 2,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 14,
                  color: AppColor.darkPurple,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ],
    );
  }

  Widget image(String _image) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(5),
        //color: Colors.white,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(500),
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.white10, spreadRadius: 1),
          ],
        ),
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(1),
              child: CircleAvatar(
                  maxRadius: 50,
                  backgroundImage: (_image == null)
                      ? AssetImage("assets/images/avatar2.png")
                      : NetworkImage(_image)),
            ),
          ],
        ),
        //  Container(width: 100, height: 100, child: Image.file(_image)),
      ),
    );
  }
}
