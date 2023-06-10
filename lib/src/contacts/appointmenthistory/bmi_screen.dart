import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/contacts/appointmenthistory/session_appointmenthistory_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BMIScreen extends StatefulWidget {
  final String id;

  const BMIScreen({Key key, this.id}) : super(key: key);
  @override
  _BMIScreenState createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final bloc = AppointmentHistoryBloc();
  final sessionBloc = SessionBloc();

  @override
  void initState() {
    bloc.dispatch(LoadDetailMedicalExamination(id: this.widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // key: scaffoldKey,
        body: SingleChildScrollView(
            child: Stack(children: [
      AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        toolbarHeight: 133,
        title: Text(
          AppLocalizations.of(context).bodyIndex,
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 120),
        child: Column(
          children: [
            _weightheightblood(),
            _sinhhieu(),
            SizedBox(
              height: 10,
            ),
            //_buildCustomButton(),
          ],
        ),
      ),
      // Container(
      //   color: Colors.white,
      //   margin: EdgeInsets.only(top: 130),

      //   child: Column(
      //     children: [
      //       Container(
      //         decoration:
      //             BoxDecoration(color: AppColor.veryLightPinkFour, boxShadow: [
      //           BoxShadow(
      //               blurRadius: 6, offset: Offset(0, 3), color: Colors.black12),
      //         ]),
      //         height: 40,
      //         alignment: Alignment.centerLeft,
      //         padding: const EdgeInsets.only(left: 21),
      //         child: Text(
      //           'Chiều cao, cân nặng',
      //           style:TextStyle(
      //               fontFamily: 'Montserrat-M',
      //               fontSize: 16,
      //               color: AppColor.deepBlue,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //       _weightheightblood(),
      //       SizedBox(
      //         height: 19.7,
      //       ),
      //       Container(
      //         decoration: BoxDecoration(boxShadow: [
      //           BoxShadow(
      //             blurRadius: 6,
      //             offset: Offset(0, 3),
      //             color: Colors.black12,
      //           ),
      //         ], color: AppColor.veryLightPinkFour),
      //         height: 40,
      //         alignment: Alignment.centerLeft,
      //         padding: const EdgeInsets.only(left: 21),
      //         child: Text(
      //           'Chỉ số sinh hiệu',
      //           style:TextStyle(
      //                 fontFamily: 'Montserrat-M',
      //               fontSize: 16,
      //               color: AppColor.deepBlue,
      //               fontWeight: FontWeight.bold),
      //         ),
      //       ),
      //       _sinhhieu(),
      //     ],
      //   ),
      // ),
    ])));
  }

  _sinhhieu() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        return Container(
            height: 192,
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
            child: Column(children: [
              Container(
                padding: const EdgeInsets.fromLTRB(14, 5, 14, 9),
                margin: const EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColor.lightGray,
                    borderRadius: BorderRadius.circular(4)),
                child: Text(
                  AppLocalizations.of(context).vitalityIndex,
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
                    AppLocalizations.of(context).heartRate,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination?.heartbeat == null)
                            ? AppLocalizations.of(context).undefined
                            : "${output?.detailMedicalExamination?.heartbeat} ${AppLocalizations.of(context).beat}",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
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
                    AppLocalizations.of(context).bloodPressure,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(children: [
                    Text(
                      (output?.detailMedicalExamination
                                      ?.systolicBloodPressure ==
                                  null ||
                              output?.detailMedicalExamination
                                      ?.diastolicBloodPressure ==
                                  null ||
                              output?.detailMedicalExamination
                                      ?.diastolicBloodPressure ==
                                  0)
                          ? AppLocalizations.of(context).undefined
                          : "${output?.detailMedicalExamination?.systolicBloodPressure}/${output?.detailMedicalExamination?.diastolicBloodPressure} mmHg",
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColor.orangeColor),
                    ),
                  ])
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context).bodyTemperature,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination?.bodyTemperature ==
                                null)
                            ? AppLocalizations.of(context).undefined
                            : "${output?.detailMedicalExamination?.bodyTemperature ?? ""} ${AppLocalizations.of(context).degree}",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
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
                    AppLocalizations.of(context).breathe,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination?.breathingRate ==
                                null)
                            ? AppLocalizations.of(context).undefined
                            : "${output?.detailMedicalExamination?.breathingRate ?? ""} ${AppLocalizations.of(context).beat}",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
                    ],
                  ),
                ],
              ),
            ]));
      },
    );
  }

  _weightheightblood() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        return Container(
          height: 162,
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
                  '${AppLocalizations.of(context).height}, ${AppLocalizations.of(context).weight}',
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
                    AppLocalizations.of(context).height,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination?.height == null)
                            ? AppLocalizations.of(context).undefined
                            : "${output?.detailMedicalExamination?.height} cm",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.darkPurple),
                      ),
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
                    AppLocalizations.of(context).weight,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      Text(
                        (output?.detailMedicalExamination?.weight == null)
                            ? AppLocalizations.of(context).undefined
                            : "${output?.detailMedicalExamination?.weight} kg",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColor.orangeColor),
                      ),
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
                    AppLocalizations.of(context).bloodType,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 14,
                        color: AppColor.darkPurple),
                  ),
                  Row(
                    children: [
                      _buildBloodGroup(),
                      // Text(
                      //   (output?.detailMedicalExamination?.bloodGroup == null)
                      //       ? 'Chưa xác định'
                      //       : "${output?.detailMedicalExamination?.bloodGroup}",
                      //   style:TextStyle(
                      //   fontFamily: 'Montserrat-M',
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.bold,
                      //       color: AppColor.darkPurple),
                      // ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  _buildBloodGroup() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        if (output.detailMedicalExamination?.bloodGroup == 0) {
          return Text(
            "O",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.darkPurple),
          );
        } else if (output.detailMedicalExamination?.bloodGroup == 1) {
          return Text(
            "A",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.darkPurple),
          );
        } else if (output.detailMedicalExamination?.bloodGroup == 2) {
          return Text(
            "B",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.darkPurple),
          );
        } else if (output.detailMedicalExamination?.bloodGroup == 3) {
          return Text(
            "AB",
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.darkPurple),
          );
        } else {
          return Text(
            AppLocalizations.of(context).noBloodInfor,
            style: TextStyle(
                fontFamily: 'Montserrat-M',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColor.darkPurple),
          );
        }
      },
    );
  }
}
