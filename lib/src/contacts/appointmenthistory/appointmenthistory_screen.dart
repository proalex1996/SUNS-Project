import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/appointment_history_item.dart';
import 'package:suns_med/src/contacts/appointmenthistory/detailhistory_screen.dart';
import 'package:suns_med/src/contacts/appointmenthistory/session_appointmenthistory_bloc.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';

class AppointmentHistoryScreen extends StatefulWidget {
  final int contactId;

  const AppointmentHistoryScreen({Key key, this.contactId}) : super(key: key);

  @override
  _AppointmentHistoryScreenState createState() =>
      _AppointmentHistoryScreenState();
}

class _AppointmentHistoryScreenState extends State<AppointmentHistoryScreen> {
  final bloc = AppointmentHistoryBloc();
  final contactbloc = ContactBloc();

  @override
  void initState() {
    bloc.dispatch(LoadRelationshipHistoryEvent());
    bloc.dispatch(LoadMedicalExamination(id: widget?.contactId));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   centerTitle: true,
      //   backgroundColor: AppColor.deepBlue,
      //   title: Text(
      //     'Lịch sử khám bệnh',
      //     style:TextStyle(
      //         fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
      //   ),
      // ),
      appBar: CustomAppBar(
        title: AppLocalizations.of(context).examinationHistory,
        titleSize: 18,
        isTopPadding: false,
      ),
      body: SingleChildScrollView(
        child: Container(
          color: AppColor.whitetwo,
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: _buildAppointment(),
        ),
      ),
    );
  }

  _buildAppointment() {
    return BlocProvider<AppointmentHistoryEvent, AppointmentHistoryState,
        AppointmentHistoryBloc>(
      bloc: bloc,
      builder: (output) {
        var checkNull = output.medicalExamination?.length == 0;
        return checkNull
            ? Container(
                alignment: Alignment.center,
                child: Text(
                  AppLocalizations.of(context).noMedicalHistory,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 18,
                      color: Colors.black),
                ),
              )
            : ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: output.medicalExamination?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var medicalExamination = output.medicalExamination[index];
                  var time = medicalExamination?.createdTime == null
                      ? ""
                      : DateFormat.yMd("vi_VN")
                          .add_Hm()
                          .format(medicalExamination?.createdTime);
                  print(output.medicalExamination.first.id);
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: AppointmentHistoryItem(
                      fullName: medicalExamination?.name,
                      id: medicalExamination?.appointmentCode,
                      appointDate: time,
                      clinicName: medicalExamination?.staffName,
                      // relationShip: item.value,
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailHistoryScreen(
                              id: medicalExamination?.id,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              );
      },
    );
  }
}
