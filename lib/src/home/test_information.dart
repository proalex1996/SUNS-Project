import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:qr_flutter/src/qr_image.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';
import 'package:suns_med/src/Widgets/call/incoming_call.dart';
import 'package:suns_med/shared/call/call_workflow.dart';

class TestInformation extends StatefulWidget {
  TestInformation(
      {Key key,
      this.id,
      this.doctorName,
      this.department,
      this.useMobileLayout,
      this.specialist,
      this.staffId})
      : super(key: key);

  final String id;
  final bool useMobileLayout;
  final String doctorName;
  final String department;
  final String specialist;
  final int staffId;

  @override
  _TestInformationState createState() => _TestInformationState();
}

class _TestInformationState extends State<TestInformation> {
  final appointmentBloc = AppointmentBloc();

  @override
  void initState() {
    appointmentBloc.dispatch(LoadDetailAppointmentvent(id: widget.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        ListTile(
          title: Center(
              child: Text(AppLocalizations.of(context).examinationInfo,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColor.purple))),
          trailing: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColor.ocenBlue)),
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.clear_outlined,
                  size: 22,
                ),
              )),
        ),
        Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: 15, right: 15),
            padding: EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF438BA7), Color(0xFF99438BA7)]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: BlocProvider<AppointmentEvent, AppointmentState,
                    AppointmentBloc>(
                bloc: appointmentBloc,
                builder: (state) {
                  var appointment = state.detailAppointment;
                  return appointment == null
                      ? Container()
                      : Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      widget.doctorName,
                                      style: TextStyle(
                                          fontFamily: 'Montserrat-M',
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                    Container(
                                      width: widget.useMobileLayout ? 180 : 320,
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 10),
                                      child: Text(widget.department,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 14,
                                              color: Colors.white70)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 5, right: 10),
                                      child: Text(widget.specialist,
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 14,
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500)),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        'STT: ${appointment.order}',
                                        style: TextStyle(
                                            fontFamily: 'Montserrat-M',
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(1),
                                      color: Colors.white,
                                      child: QrImage(
                                        size:
                                            MediaQuery.of(context).size.width *
                                                .22,
                                        data: appointment.code ?? "suns",
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ],
                        );
                })),
        SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)))),
              onPressed: () {
                if (widget?.staffId == null) {
                  MsgDialog.showMsgDialog(
                      context, "Chat với bác sĩ", 'Bác sĩ chưa có tài khoản');
                } else
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailChat(
                        // chatId: conversation.id,
                        name: widget?.doctorName,
                        // image: conversation.image,
                        userId: widget?.staffId.toString(),
                      ),
                    ),
                  );
              },
              child: Container(
                width: 115,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgclinic/ic_chat.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Chat'),
                  ],
                ),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: BorderSide(color: Colors.red)))),
              onPressed: () {
                if (widget?.staffId == null) {
                  MsgDialog.showMsgDialog(
                      context, "Gọi với bác sĩ", 'Bác sĩ chưa có tài khoản');
                } else
                  _navigateInComming(CallInfo(
                      id: widget?.staffId.toString(),
                      name: widget?.doctorName));
              },
              child: Container(
                width: 115,
                height: 30,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/imgclinic/ic_call.png',
                      width: 24,
                      height: 24,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text('Video Call'),
                  ],
                ),
              ),
            ),
          ],
        )
      ],
    ));
  }

  _navigateInComming(CallInfo callInfo) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => InCommingCall(
          info: CommingCallInfo(
            isInCommingCall: false,
            receiver: callInfo,
          ),
        ),
      ),
    );
  }
}
