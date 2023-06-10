import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/payment/billorder_screen.dart';
import 'package:suns_med/src/Widgets/payment/session_payment_bloc.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:suns_med/src/model/image_model.dart';
import 'package:suns_med/src/order/session_confirminfo_bloc.dart';
import 'package:suns_med/src/order/session_mapgender_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ConfirmInforScreen extends StatefulWidget {
  final ContactModel contact;
  final List<Object> images;
  final int patientId;
  final bool useBookingTime;
  final String note,
      servicePackageId,
      history,
      staffId,
      companyId,
      staffName,
      address,
      branchId,
      timeSelect;
  final DateTime dateTime;
  final CompanyType companyType;

  ConfirmInforScreen(
      {this.contact,
      @required this.dateTime,
      this.images,
      this.useBookingTime,
      this.staffId,
      this.patientId,
      this.companyId,
      this.address,
      this.staffName,
      this.companyType,
      this.note,
      this.history,
      this.timeSelect,
      this.branchId,
      this.servicePackageId});

  @override
  _ConfirmInforScreenState createState() => _ConfirmInforScreenState();
}

class _ConfirmInforScreenState extends State<ConfirmInforScreen> {
  ContactModel _contact;
  final sessionBloc = SessionBloc();
  final bloc = ConfirmBloc();
  final contactBloc = ContactBloc();
  final genderBloc = GenderBloc();
  final appointmentBloc = AppointmentBloc();
  final paymentBloc = PaymentBloc();
  bool isExpanded1 = false;
  bool isExpanded2 = false;
  // PostAppointmentModel _postAppointmentModel = PostAppointmentModel();
  @override
  void initState() {
    if (genderBloc.state.mapGenders == null) {
      genderBloc.dispatch(GetGenderEvent());
    }
    contactBloc.dispatch(LoadGenderEvent());
    bloc.dispatch(EventResetStateCheckAppointment());
    // bloc.dispatch(EventReset());
    paymentBloc.dispatch(EventResetStatePayment());
    _contact = this.widget.contact;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: AppColor.white,
      // appBar: AppBar(
      //   backgroundColor: AppColor.orangeColorDeep,
      //   centerTitle: true,
      //   title: Text(
      //     AppLocalizations.of(context).confirmInformation,
      //     style:TextStyle(
      //          fontFamily: 'Montserrat-M',
      //       color: Colors.white,
      //       fontSize: 18,
      //     ),
      //   ),
      // ),
      appBar: const TopAppBar(),
      body: _body(),
    );
  }

  _body() {
    return BlocProvider<ConfirmEvent, ConfirmState, ConfirmBloc>(
        navigator: (state) {
          if (state.checkStateApointment == true) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BillOrderScreen(
                  idOrder: state.orderId,
                ),
              ),
            );
          }
        },
        bloc: bloc,
        builder: (state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomAppBar(
                  title: AppLocalizations.of(context).confirmInformation,
                  titleSize: 18,
                ),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColor.lightGray,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          margin: EdgeInsets.all(10),
                          padding: const EdgeInsets.only(left: 10),
                          alignment: Alignment.centerLeft,
                          height: 35,
                          child: Text(
                            AppLocalizations.of(context).patientInformation,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.darkPurple),
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 35,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/user1.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: Text(
                                            _contact.fullName,
                                            style: TextStyle(
                                                fontFamily: 'Montserrat-M',
                                                fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/telephone1.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          _contact.phoneNumber ?? "",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/cmnd.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          _contact.personalNumber ?? "",
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width:
                                    MediaQuery.of(context).size.width / 2 - 35,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/calendar.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          DateFormat.yMMMd('vi')
                                              .format(_contact.birthDay),
                                          style: TextStyle(
                                              fontFamily: 'Montserrat-M',
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 11,
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/gender1.png',
                                          width: 20,
                                          height: 20,
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        BlocProvider<ContactEvent, ContactState,
                                                ContactBloc>(
                                            bloc: contactBloc,
                                            builder: (state) {
                                              var genderId =
                                                  _contact?.gender ?? 0;
                                              var genderValue = state?.gender
                                                  ?.firstWhere((element) =>
                                                      element.key == genderId);
                                              return Text(
                                                genderValue?.value == null
                                                    ? ""
                                                    : genderValue?.value,
                                                style: TextStyle(
                                                    fontFamily: 'Montserrat-M',
                                                    fontSize: 14),
                                              );
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 35,
                        //alignment: Alignment.centerLeft,
                        child: Text(
                          AppLocalizations.of(context).examinationInfo,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.darkPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/user1.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              (widget?.staffName == null)
                                  ? AppLocalizations.of(context).undefined
                                  : '${widget.staffName}',
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M', fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/calendar.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            _date(),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.fromLTRB(10, 0, 10, 15),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/location.png',
                              width: 20,
                              height: 20,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                              child: Text(
                                '${widget.address}',
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ])),
                Container(
                    margin: EdgeInsets.fromLTRB(25, 0, 25, 20),
                    decoration: BoxDecoration(
                      color: AppColor.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          color: AppColor.lightGray,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        margin: EdgeInsets.all(10),
                        padding: const EdgeInsets.only(left: 10),
                        alignment: Alignment.centerLeft,
                        height: 35,
                        //alignment: Alignment.centerLeft,

                        child: Text(
                          AppLocalizations.of(context).checkOut,
                          style: TextStyle(
                              fontFamily: 'Montserrat-M',
                              fontSize: 16,
                              color: AppColor.darkPurple,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 21, bottom: 15, top: 16),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/note.png',
                              width: 14,
                              height: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).note,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold,
                                  color: AppColor.purple),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 30),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: isExpanded1
                                      ? new BoxConstraints()
                                      : new BoxConstraints(maxHeight: 110.0),
                                  child: Text(
                                    widget.note,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    isExpanded1 ? 'Rút gọn' : 'Xem thêm',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            onTap: () =>
                                setState(() => isExpanded1 = !isExpanded1)),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                          left: 21,
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/note.png',
                              width: 14,
                              height: 16,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              AppLocalizations.of(context).symptoms,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  fontSize: 14,
                                  //fontWeight: FontWeight.bold,
                                  color: AppColor.purple),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.only(
                            left: 21, right: 20, top: 15, bottom: 24),
                        alignment: Alignment.centerLeft,
                        child: InkWell(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ConstrainedBox(
                                  constraints: isExpanded2
                                      ? new BoxConstraints()
                                      : new BoxConstraints(maxHeight: 110.0),
                                  child: Text(
                                    widget.history,
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        fontSize: 14),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text(
                                    isExpanded2 ? 'Rút gọn' : 'Xem thêm',
                                    style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                        color: AppColor.darkPurple,
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                            onTap: () =>
                                setState(() => isExpanded2 = !isExpanded2)),
                      ),
                      // Container(
                      //   padding: const EdgeInsets.only(left: 21),
                      //   child: Row(
                      //     children: [
                      //       Image.asset(
                      //         'assets/images/prescription.png',
                      //         width: 14,
                      //         height: 20,
                      //       ),
                      //       SizedBox(
                      //         width: 10,
                      //       ),
                      //       Text(
                      //         'TOA THUỐC',
                      //         style:TextStyle(
                      //       fontFamily: 'Montserrat-M',
                      //             fontSize: 13,
                      //             fontWeight: FontWeight.bold,
                      //             color: AppColor.veryLightPinkTwo),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      buildGridView(),
                    ])),
                // Container(
                //   padding: const EdgeInsets.only(left: 21, top: 10.3),
                //   child: GestureDetector(
                //     onTap: () => _showAlert(context, "message",
                //         widget.images == null ? "" : widget.images),
                //     child: widget.images == null
                //         ? Container()
                //         : Image.file(
                //             widget.images,
                //             width: 111,
                //             height: 111,
                //           ),
                //   ),
                // ),
                Container(
                  height: 46,
                  width: double.infinity,
                  margin: const EdgeInsets.only(
                      left: 23, right: 23, top: 20, bottom: 10),
                  child: RaisedButton(
                    onPressed: () {
                      if (state.checkStateOrder != true) {
                        bloc.dispatch(EventPostCreateAppointment(
                            patientId: this.widget.patientId,
                            firstHistory: this.widget.history,
                            prescriptionFiles: this.widget.images,
                            name: this.widget.contact.fullName,
                            appoinmentTime:
                                this.widget.dateTime ?? DateTime.now(),
                            note: this.widget.note,
                            staffId: this.widget.staffId,
                            servicePackageId: widget.servicePackageId,
                            branchId: widget.branchId));
                      }
                    },
                    color: AppColor.purple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Text(
                      AppLocalizations.of(context).confirmInformation,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget buildGridView() {
    var count = widget.images.length;
    return GridView.count(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      crossAxisCount: 3,
      childAspectRatio: 1,
      children: List.generate(count, (index) {
        ImageUploadModel uploadModel = widget.images[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(10, 15, 0, 20),
          child: Image.file(
            uploadModel.imageFile,
            width: 80,
            height: 80,
            fit: BoxFit.cover,
          ),
        );
      }),
    );
  }

  // _showAlert(BuildContext context, String message, File img) async {
  //   return showDialog(
  //     context: context,
  //     child: Dialog(
  //         shape:
  //             RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  //         child: Container(
  //           // padding: const EdgeInsets.all(10),
  //           // height: do,
  //           decoration: BoxDecoration(
  //             borderRadius: BorderRadius.circular(11),
  //             color: AppColor.white,
  //           ),
  //           child: PhotoView(imageProvider: FileImage(img)),
  //         )),
  //   );
  // }

  _date() {
    if (widget.dateTime == null) {
      return Text(
        '${DateTime.now()}'.substring(0, 10),
        style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
      );
    }
    return Text(
      widget.useBookingTime == false || widget.useBookingTime == null
          ? "${DateFormat.yMd('vi').format(widget.dateTime)}"
          : "${DateFormat.yMd('vi').add_Hm().format(widget.dateTime)}",
      style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
    );
  }
}
