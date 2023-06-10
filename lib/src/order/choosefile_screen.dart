import 'package:age/age.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/Widgets/infor_item.dart';
import 'package:suns_med/src/account/update_screen.dart';
import 'package:suns_med/src/order/createfile_screen.dart';
import 'package:suns_med/src/order/session_dropdownvalue_bloc.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'createinfor_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ChooseFileScreen extends StatefulWidget {
  final DateTime dateTime;
  final String staffId,
      staffName,
      address,
      timeSelect,
      servicePackageId,
      branchId;
  final int fromAge, toAge, gender;

  final bool useBookingTime;
  ChooseFileScreen(
      {this.dateTime,
      this.servicePackageId,
      this.branchId,
      this.staffId,
      this.address,
      @required this.staffName,
      this.useBookingTime,
      this.timeSelect,
      this.fromAge,
      this.toAge,
      this.gender});

  @override
  _ChooseFileScreenState createState() => _ChooseFileScreenState();
}

class _ChooseFileScreenState extends State<ChooseFileScreen> {
  final bloc = OrderBloc();
  final dropdownBloc = DropdownValueBloc();
  // AgeDuration age;
  DateTime today = DateTime.now();

  @override
  void initState() {
    bloc.dispatch(ChooseFileEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.whitetwo,
      // appBar: AppBar(
      //   backgroundColor: Color(0xFFF47A4D),
      //   title: Text(
      //     'Đặt lịch khám',
      //     style:TextStyle(
      //          fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
      //   ),
      //   centerTitle: true,
      // ),
      appBar: const TopAppBar(),
      body: Container(
        child: Column(
          children: <Widget>[
            CustomAppBar(
              title: AppLocalizations.of(context).book,
              titleSize: 18,
            ),
            _buildTitleText(),
            _buildListProfile(),
            _buildButton(),
          ],
        ),
      ),
    );
  }

  _buildButton() {
    return BlocProvider<OrderEvent, OrderState, OrderBloc>(
        bloc: bloc,
        builder: (state) {
          return Container(
            padding: const EdgeInsets.only(left: 23, right: 23, bottom: 20),
            child: CustomButton(
              radius: BorderRadius.circular(26),
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  color: AppColor.white),
              color: AppColor.purple,
              text: state.contact?.length == 0
                  ? AppLocalizations.of(context).updateInformation
                  : AppLocalizations.of(context).createProfile,
              onPressed: () async {
                // dropdownBloc.dispatch(LoadRelationShipEvent());

                if (state.contact?.length == 0)
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => UpdateScreen(
                        isUpdateAndCreated: true,
                      ),
                    ),
                  );
                else {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateFileScreen(
                              gender: widget.gender,
                              fromAge: widget.fromAge,
                              toAge: widget.toAge,
                              staffId: widget.staffId,
                              useBookingTime: widget.useBookingTime,
                              timeSelect: widget.timeSelect,
                              staffName: this.widget.staffName,
                              address: this.widget.address,
                              servicePackageId: widget.servicePackageId,
                              dateTime: widget.dateTime,
                              branchId: widget.branchId)));
                  bloc.dispatch(ChooseFileEvent());
                }
              },
            ),
          );
        });
  }

  _buildListProfile() {
    return BlocProvider<OrderEvent, OrderState, OrderBloc>(
      bloc: bloc,
      builder: (state) {
        return state.contact?.length == 0
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(AppLocalizations.of(context).mustUpdate),
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: state.contact?.length ?? 0,
                  itemBuilder: (BuildContext context, index) {
                    var profile = state.contact[index];
                    var hasEmail = profile?.email == null;
                    var time = profile?.birthDay == null
                        ? "${AppLocalizations.of(context).notUpdate}".toString()
                        : DateFormat.yMd("vi_VN").format(
                            profile?.birthDay,
                          );
                    var genderId = profile.gender ?? 0;
                    var genderValue = state.gender
                        ?.firstWhere((element) => element.key == genderId);

                    AgeDuration age = Age.dateDifference(
                        fromDate: profile?.birthDay,
                        toDate: today,
                        includeToDate: false);

                    return InforItem(
                      image: 'assets/images/avatar2.png',
                      name: profile?.fullName,
                      birthday: time,
                      gender: genderValue?.value,
                      phone: profile?.phoneNumber == null
                          ? "${AppLocalizations.of(context).phoneNumber} ${AppLocalizations.of(context).notUpdate}"
                          : profile?.phoneNumber,
                      email: hasEmail
                          ? "Email ${AppLocalizations.of(context).notUpdate}"
                          : profile?.email,
                      personalNumber: profile?.personalNumber == null
                          ? "CMND ${AppLocalizations.of(context).notUpdate}"
                          : profile?.personalNumber,
                      onPress: () {
                        if (widget.gender == profile?.gender &&
                                age.years >= widget.fromAge &&
                                age.years <= widget.toAge ||
                            widget.gender == profile?.gender &&
                                age.years >= widget.fromAge &&
                                widget.toAge == null ||
                            widget.gender == profile?.gender &&
                                age.years <= widget.toAge &&
                                widget.fromAge == null ||
                            widget.gender == profile?.gender &&
                                widget.toAge == null &&
                                widget.fromAge == null ||
                            widget.gender == null &&
                                widget.toAge == null &&
                                widget.fromAge == null ||
                            widget.gender == null &&
                                age.years >= widget.fromAge &&
                                age.years <= widget.toAge ||
                            widget.gender == null &&
                                age.years >= widget.fromAge &&
                                widget.toAge == null ||
                            widget.gender == null &&
                                age.years <= widget.toAge &&
                                widget.fromAge == null) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CreateInforScreen(
                                timeSelect: widget.timeSelect,
                                servicePackageId: widget.servicePackageId,
                                staffName: this.widget.staffName,
                                useBookingTime: widget.useBookingTime,
                                address: this.widget.address,
                                dateTime: widget.dateTime,
                                staffId: widget.staffId,
                                patientId: profile.id,
                                isCreated: true,
                                contact: profile,
                                branchId: widget.branchId,
                              ),
                            ),
                          );
                        } else {
                          Flushbar(
                            margin: EdgeInsets.all(8),
                            borderRadius: 8,
                            title: AppLocalizations.of(context).notification,
                            message: AppLocalizations.of(context)
                                .servicePackageInvalid,
                            duration: Duration(seconds: 3),
                          )..show(context);
                        }
                        // if (widget.gender == profile.gender ||
                        //     profile.gender == 0) {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //       builder: (context) => CreateInforScreen(
                        //         timeSelect: widget.timeSelect,
                        //         servicePackageId: widget.servicePackageId,
                        //         staffName: this.widget.staffName,
                        //         useBookingTime: widget.useBookingTime,
                        //         address: this.widget.address,
                        //         dateTime: widget.dateTime,
                        //         staffId: widget.staffId,
                        //         patientId: profile.id,
                        //         isCreated: true,
                        //         contact: profile,
                        //       ),
                        //     ),
                        //   );
                        // } else {
                        //   Flushbar(
                        //     margin: EdgeInsets.all(8),
                        //     borderRadius: 8,
                        //     title: 'Thông báo',
                        //     message:
                        //         "Gói khám không phù hợp với bạn, mời bạn đặt gói khám khác",
                        //     duration: Duration(seconds: 3),
                        //   )..show(context);
                        // }
                      },
                    );
                  },
                ),
              );
      },
    );
  }

  _buildTitleText() {
    return Container(
      decoration: BoxDecoration(
        color: AppColor.veryLightPinkFour,
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black12,
            offset: Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity,
      height: 40,
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 21),
      child: Text(AppLocalizations.of(context).selectProfile,
          style: TextStyle(
              fontFamily: 'Montserrat-M',
              fontSize: 16,
              color: AppColor.deepBlue,
              fontWeight: FontWeight.bold)),
    );
  }

  // _buildAge() {
  //   DateTime birthday = DateTime(1950, 1, 20);
  //   DateTime today = DateTime.now(); //2020/1/24

  //   AgeDuration age;

  //   // Find out your age
  //   age = Age.dateDifference(
  //       fromDate: birthday, toDate: today, includeToDate: false);

  //   print('Your age is $age'); // Your age is Years: 30, Months: 0, Days: 4

  //   // // Find out when your next birthday will be.
  //   // DateTime tempDate = DateTime(today.year, birthday.month, birthday.day);
  //   // DateTime nextBirthdayDate = tempDate.isBefore(today)
  //   //     ? Age.add(date: tempDate, duration: AgeDuration(years: 1))
  //   //     : tempDate;
  //   // AgeDuration nextBirthdayDuration =
  //   //     Age.dateDifference(fromDate: today, toDate: nextBirthdayDate);

  //   // print('You next birthday will be on $nextBirthdayDate or in $nextBirthdayDuration');
  // }
}
