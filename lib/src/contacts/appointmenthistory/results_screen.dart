import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/contacts/appointmenthistory/prescription_screen.dart';
import 'package:suns_med/src/contacts/appointmenthistory/session_appointmenthistory_bloc.dart';
import 'package:suns_med/src/contacts/appointmenthistory/xray_screen.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

import 'image-result-service.dart';

class ResultsScreen extends StatefulWidget {
  final String id;

  const ResultsScreen({Key key, this.id}) : super(key: key);
  @override
  _ResultsScreenState createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  final bloc = AppointmentHistoryBloc();
  final sessionBloc = SessionBloc();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final money = NumberFormat('#,###,000');

  @override
  void initState() {
    bloc.dispatch(LoadExamination(id: this.widget.id));
    bloc.dispatch(LoadDetailMedicalExamination(id: this.widget.id));
    super.initState();
  }

  _renderHtml(String content) {
    return '<!DOCTYPE html><html lang="en"><head> <meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1.0" /><title>Content</title></head><body>$content</body></html>';
  }

  Future _showAlert(BuildContext context, String message, String note) async {
    return showDialog(
        context: context,
        child: Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: _buildDialog(context, note),
        ));
  }

  _buildDialog(context, String note) => Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '${AppLocalizations.of(context).note}:',
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.pumpkin),
              ),
              Container(
                width: 282,
                child: Html(
                  data: _renderHtml(note == null || note.isEmpty
                      ? AppLocalizations.of(context).notData
                      : note),
                  defaultTextStyle: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 14,
                      color: Colors.black),
                  padding: EdgeInsets.only(top: 10.0),
                  onLinkTap: (url) {
                    print("Opening $url...");
                  },
                  customRender: (node, children) {
                    if (node is dom.Element) {
                      switch (node.localName) {
                        case "custom_tag": // using this, you can handle custom tags in your HTML
                          return Column(children: children);
                      }
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: const TopAppBar(),
      body: SingleChildScrollView(
        child: Stack(children: [
          // AppBar(
          //   backgroundColor: AppColor.deepBlue,
          //   centerTitle: true,
          //   toolbarHeight: 133,
          //   title: Text(
          //     'Kết quả khám bệnh',
          //     style:TextStyle(
          //             fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
          //   ),
          // ),
          CustomAppBar(
              title: AppLocalizations.of(context).examinationResults,
              titleSize: 18,
              isOrangeAppBar: true),
          Container(
            margin: EdgeInsets.only(top: 90),
            child: Column(
              children: [
                _buildCardService(),
                _buildBody(),
                SizedBox(
                  height: 10,
                ),
                _buildCustomButton(),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  _buildCustomButton() {
    return Container(
      padding: const EdgeInsets.only(
        left: 32,
        right: 31,
      ),
      child: CustomButton(
        color: AppColor.deepBlue,
        onPressed: () {
          bloc.state?.detailMedicalExamination?.prescriptions == null
              ? scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text(AppLocalizations.of(context).noPrescription),
                  ),
                )
              : Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PrescriptionScreen(
                      img: bloc.state?.detailMedicalExamination?.prescriptions,
                    ),
                  ),
                );
        },
        text: AppLocalizations.of(context).viewPrescription,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.white),
        radius: BorderRadius.circular(26),
      ),
    );
  }

  _buildBody() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        var checkState = output.examination?.length == null;

        // var checkState = output.result?.historyExamItems?.length == null;
        return checkState
            ? Container()
            : Wrap(
                children: List.generate(
                  output.examination?.length,
                  (index) {
                    var item = output.examination[index];
                    return Container(
                      padding: const EdgeInsets.fromLTRB(11, 13, 11, 20),
                      decoration: BoxDecoration(
                          color: AppColor.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 6,
                              color: Colors.black12,
                              offset: Offset(0, 3),
                            )
                          ]),
                      margin: const EdgeInsets.fromLTRB(25, 14, 25, 0),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                                vertical: 9, horizontal: 19),
                            decoration: BoxDecoration(
                              color: AppColor.lightGray,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              "${item?.name}",
                              style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkPurple,
                              ),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/apointment.png'),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  "${item?.name}",
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Image.asset('assets/images/user1.png'),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Text(
                                  item?.staffName ??
                                      AppLocalizations.of(context).noDoctor,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(19),
                              decoration: BoxDecoration(
                                color: AppColor.lightGray,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).result,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 14,
                                      color: AppColor.darkPurple,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    (item?.result == null || item?.result == '')
                                        ? AppLocalizations.of(context)
                                            .noExaminationResults
                                        : item?.result,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: [
                          //     Image.asset('assets/images/note.png'),
                          //     Expanded(
                          //       // width: 285,
                          //       child: Text(
                          //         item?.result ??
                          //             "Không có dữ liệu kết quả khám.",
                          //         style:TextStyle(
                          //       fontFamily: 'Montserrat-M',
                          //           fontSize: 16,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(children: [
                                InkWell(
                                  onTap: () => _showAlert(
                                      context, 'message', item?.note),
                                  child: Image.asset('assets/images/note.png'),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                Text(
                                  AppLocalizations.of(context).note,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.darkPurple,
                                  ),
                                ),
                              ]),
                              InkWell(
                                onTap: () {
                                  item?.image == null
                                      ? scaffoldKey.currentState.showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                AppLocalizations.of(context)
                                                    .noExamImage),
                                          ),
                                        )
                                      : Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ImageResultService(
                                              img: item?.image,
                                              service: item?.name,
                                            ),
                                          ),
                                        );
                                },
                                child: Row(
                                  children: [
                                    Image.asset('assets/images/result.png'),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text(
                                      AppLocalizations.of(context).result,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: AppColor.orangeColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              item?.images == null
                                  ? SizedBox()
                                  : InkWell(
                                      onTap: () {
                                        // item?.images == null
                                        //     ? scaffoldKey.currentState.showSnackBar(
                                        //         SnackBar(
                                        //           content: Text(
                                        //               "Không có dữ liệu hình ảnh kết quả."),
                                        //         ),
                                        //       )
                                        //     :
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => XRayScreen(
                                              img: item?.images,
                                            ),
                                          ),
                                        );
                                      },
                                      child: Image.asset(
                                        'assets/images/result.png',
                                      ),
                                    ),
                            ],
                          ),
                          //Divider()
                          SizedBox(
                            height: 14,
                          ),
                          Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(19),
                              decoration: BoxDecoration(
                                color: AppColor.lightGray,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context).doctor} ${AppLocalizations.of(context).note}',
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 14,
                                      color: AppColor.darkPurple,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    item?.note ??
                                        AppLocalizations.of(context).noNote,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14,
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  },
                ),
              );
      },
    );
  }

  _buildCardService() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        return Container(
          height: 135,
          decoration: BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  blurRadius: 6,
                  color: Colors.black12,
                  offset: Offset(0, 3),
                )
              ]),
          margin: const EdgeInsets.fromLTRB(25, 14, 25, 0),
          padding: const EdgeInsets.fromLTRB(12, 11, 12, 20),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 9),
                margin: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.lightGray,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  AppLocalizations.of(context).costExamination,
                  style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: AppColor.darkPurple,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).cost,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination == null)
                            ? AppLocalizations.of(context).undefined
                            : "${money.format(output.detailMedicalExamination?.price)} đ",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
                      // Text(
                      //   " đ",
                      //   style:TextStyle(
                      //          fontFamily: 'Montserrat-M',
                      //       //fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //       color: AppColor.darkPurple),
                      // ),
                    ],
                  ),
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${AppLocalizations.of(context).examType}:',
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  _buildExaminationType(),
                ],
              ),
            ],
          ),
        );
      },
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
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.pumpkin),
            );
          } else {
            return Text(
              AppLocalizations.of(context).examinationBhyt,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColor.pumpkin),
            );
          }
        });
  }
}
