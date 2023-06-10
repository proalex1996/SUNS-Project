import 'package:flutter/material.dart';
import 'package:fw_ticket/fw_ticket.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/account/notification/chat/detail_chat.dart';
import 'package:suns_med/shared/dialog/msg_dialog.dart';
import 'package:suns_med/src/Widgets/call/incoming_call.dart';
import 'package:suns_med/shared/call/call_workflow.dart';

class AppointmentItem extends StatefulWidget {
  final String id;
  final int appointmentOrder;
  final bool isAppointmentDateTime;
  final String name;
  final DateTime datetime;
  final String relationship;
  final String doctor, department;
  final String idDoctor;
  final Function onPress;
  final int status;
  final int currentOrder;
  final int staffId;
  final Widget button;

  const AppointmentItem(
      {Key key,
      this.id,
      this.name,
      this.datetime,
      this.onPress,
      this.isAppointmentDateTime,
      this.appointmentOrder,
      this.relationship,
      this.department,
      this.doctor,
      this.idDoctor,
      this.currentOrder,
      this.button,
      this.status,
      this.staffId})
      : super(key: key);

  @override
  _AppointmentItemState createState() => _AppointmentItemState();
}

class _AppointmentItemState extends State<AppointmentItem> {
  bool isRelation = false;
  bool isNotConfirm = true;

  @override
  Widget build(BuildContext context) {
    // String date = this.widget.datetime;
    // DateTime dateTime = DateTime.parse(date);
    return Stack(
      children: [
        Container(
          //height: 216,
          width: double.infinity,
          margin: EdgeInsets.fromLTRB(27, 14, 28, 17),
          padding: EdgeInsets.fromLTRB(11, 13, 11, 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                blurRadius: 8,
                color: AppColor.whiteFive,
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                  //height: 87,
                  padding: EdgeInsets.only(left: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget?.id}",
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 20,
                            color: AppColor.darkPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 2 - 51,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  AppLocalizations.of(context).patient,
                                  style: TextStyle(
                                    fontFamily: 'Montserrat-M',
                                    fontSize: 14,
                                    color: AppColor.warmGrey,
                                  ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  "${widget?.name}",
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 16,
                                      color: AppColor.darkPurple,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width / 2 - 39,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    AppLocalizations.of(context).doctor,
                                    style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 14,
                                      color: AppColor.warmGrey,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "${widget?.doctor}",
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 16,
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ))
                        ],
                      )
                    ],
                  )),
              Container(
                  margin: EdgeInsets.fromLTRB(0, 6, 0, 9),
                  padding: EdgeInsets.fromLTRB(15, 10, 15, 10),
                  //height: 66,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(4)),
                    color: AppColor.lightGray,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context).examTime,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.warmGrey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        widget.datetime == null
                            ? "Chưa có giờ khám"
                            : DateFormat.yMd('vi')
                                .add_Hm()
                                .format(this.widget.datetime),
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.darkPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ],
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 95,
                    padding: EdgeInsets.only(left: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () {
                            if (widget?.staffId == null) {
                              MsgDialog.showMsgDialog(
                                  context,
                                  "Chat với bác sĩ",
                                  'Bác sĩ chưa có tài khoản');
                            } else
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailChat(
                                    // chatId: conversation.id,
                                    name: widget?.doctor,
                                    // image: conversation.image,
                                    userId: widget?.staffId.toString(),
                                  ),
                                ),
                              );
                          },
                          child: Image.asset(
                            'assets/images/chat2.png',
                            height: 27,
                            width: 27,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: InkWell(
                            onTap: () {
                              if (widget?.staffId == null) {
                                MsgDialog.showMsgDialog(
                                    context,
                                    "Gọi với bác sĩ",
                                    'Bác sĩ chưa có tài khoản');
                              } else
                                _navigateInComming(CallInfo(
                                    id: widget?.staffId.toString(),
                                    name: widget?.name));
                            },
                            child: Image.asset(
                              'assets/images/call_video.png',
                              height: 27,
                              width: 27,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: 40,
                    width: 180,
                    child: RaisedButton(
                      color: AppColor.purple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(45),
                      ),
                      onPressed: () {
                        widget.onPress();
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image.asset(
                            'assets/imgclinic/ic_calendar.png',
                            width: 24,
                            height: 24,
                          ),
                          Text(
                            AppLocalizations.of(context).viewAppointment,
                            style: TextStyle(
                                // fontFamily: 'Montserrat-M',
                                fontSize: 14,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
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
