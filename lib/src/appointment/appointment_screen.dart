import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/appointment/appointment_service_proxy.dart';
import 'package:suns_med/src/Widgets/appointment_item.dart';
import 'package:suns_med/src/Widgets/payment/session_payment_bloc.dart';
import 'package:suns_med/src/appointment/session_appointment_bloc.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/appointment/appointment_detail.dart';

class AppointmentScreen extends StatefulWidget {
  final int stateNumber;
  AppointmentScreen({this.stateNumber});
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  ScrollController _scrollController = ScrollController();
  // TextEditingController _controller = TextEditingController();
  AppointmentFilterQuery _appointmentFilterQuery = AppointmentFilterQuery();

  // bool inprogress = false;
  // bool approve = false;
  // bool reject = false;

  final bloc = AppointmentBloc();
  final sessionBloc = SessionBloc();
  DateTime _dateTime;
  String result = "Please scan the QR code or Barcode";
  // InputPrintOrdinalNumberModel _printOrdinalNumberModel =
  //     InputPrintOrdinalNumberModel();

  // Future _scanQR(InputPrintOrdinalNumberModel printOrdinalNumberModel) async {
  //   try {
  //     String qrResult = await BarcodeScanner.scan();
  //     // setState(() {
  //     //   result = qrResult;
  //     // });
  //     _printOrdinalNumberModel.qrCode = qrResult;
  //     bloc.dispatch(EventInputOrdinalNumber(
  //         printOrdinalNumberModel: printOrdinalNumberModel));
  //   } on PlatformException catch (ex) {
  //     if (ex.code == BarcodeScanner.CameraAccessDenied) {
  //       setState(() {
  //         result = "Camera permission was denied";
  //       });
  //     } else {
  //       setState(() {
  //         result = "Unknown Error $ex";
  //       });
  //     }
  //   } on FormatException {
  //     setState(() {
  //       result = "You pressed the back button before scanning anything";
  //     });
  //   } catch (ex) {
  //     setState(() {
  //       result = "Unknown Error $ex";
  //     });
  //   }
  // }

  var dateNow = DateTime.now();
  final paymentBloc = PaymentBloc();

  @override
  void initState() {
    // if (bloc.state.pagingAppointment == null) {
    //   _appointmentFilterQuery.appointmentStatuses = [widget.stateNumber];
    //   bloc.dispatch(EventLoadAppointment(
    //       filterQuery: _appointmentFilterQuery, type: widget.stateNumber));
    // }
    _appointmentFilterQuery.appointmentStatuses = [widget.stateNumber];
    bloc.dispatch(EventLoadAppointment(
        filterQuery: _appointmentFilterQuery, type: widget.stateNumber));

    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _appointmentFilterQuery.appointmentTime = _dateTime;
        _appointmentFilterQuery.appointmentStatuses = [widget.stateNumber];
        bloc.dispatch(EventLoadAppointment(
            filterQuery: _appointmentFilterQuery, type: widget.stateNumber));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshHome,
        child: Scrollbar(
          child: CustomScrollView(
            // controller: _scrollController,
            slivers: [
              SliverAppBar(
                pinned: false,
                floating: true,
                backgroundColor: Colors.white,
                automaticallyImplyLeading: false,
                //expandedHeight: 65,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: false,
                    titlePadding: const EdgeInsets.only(right: 10, left: 20),
                    title: Container(
                      height: 45,
                      width: 170,
                      padding: EdgeInsets.only(left: 11),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: AppColor.warmGrey)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime(2100))
                                  .then(
                                (date) {
                                  setState(
                                    () {
                                      _dateTime = date;
                                      _appointmentFilterQuery.appointmentTime =
                                          _dateTime;
                                      bloc.dispatch(
                                        EventLoadAppointment(
                                            filterQuery:
                                                _appointmentFilterQuery,
                                            type: widget.stateNumber),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: Text(
                              _dateTime == null
                                  ? AppLocalizations.of(context).selectDate
                                  : DateFormat.yMMMd('vi').format(_dateTime),
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: AppColor.warmGrey,
                                  fontSize: 13),
                            ),
                          ),
                          _dateTime == null
                              ? IconButton(
                                  icon: Icon(Icons.keyboard_arrow_down),
                                  onPressed: () {
                                    showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1920),
                                            lastDate: DateTime(2100))
                                        .then((date) {
                                      setState(() {
                                        _dateTime = date;
                                        _appointmentFilterQuery
                                            .appointmentTime = _dateTime;
                                        bloc.dispatch(
                                          EventLoadAppointment(
                                              filterQuery:
                                                  _appointmentFilterQuery,
                                              type: widget.stateNumber),
                                        );
                                      });
                                    });
                                  },
                                )
                              : IconButton(
                                  icon: Icon(
                                    Icons.close,
                                    size: 10,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _dateTime = null;
                                      _appointmentFilterQuery.appointmentTime =
                                          _dateTime;
                                      bloc.dispatch(
                                        EventLoadAppointment(
                                            filterQuery:
                                                _appointmentFilterQuery,
                                            type: widget.stateNumber),
                                      );
                                    });
                                  })
                        ],
                      ),
                    )),
                // actions: <Widget>[
                //   IconButton(
                //     icon: Icon(
                //       Icons.filter_alt_outlined,
                //       color: AppColor.deepBlue,
                //     ),
                //     onPressed: () => filterDialog(context),
                //   )
                // ],
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  <Widget>[
                    _getAppointment(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _refreshHome() async {
    _appointmentFilterQuery.appointmentStatuses = [widget.stateNumber];
    bloc.dispatch(EventLoadAppointment(
        filterQuery: _appointmentFilterQuery, type: widget.stateNumber));
  }

  _getAppointment() {
    return BlocProvider<AppointmentEvent, AppointmentState, AppointmentBloc>(
      bloc: bloc,
      builder: (output) {
        var appointment = output.pagingAppointment[widget.stateNumber]?.data;
        return appointment == null || appointment.isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: Text(AppLocalizations.of(context).notData),
                ),
              )
            : Wrap(
                children: List.generate(appointment?.length ?? 0, (index) {
                  var appointmentNews = appointment[index];

                  var nameId = appointmentNews?.contactId ?? 0;
                  var itemName = output.contact?.firstWhere(
                      (element) => element?.id == nameId,
                      orElse: () => null);

                  var contactId = appointmentNews?.contactId ?? 0;
                  var itemContact = output.contact?.firstWhere(
                      (element) => element?.id == contactId,
                      orElse: () => null);

                  var relationshipId = itemContact?.relationShip ?? 0;
                  var itemRelationship = output.relationship?.firstWhere(
                      (element) => element?.key == relationshipId,
                      orElse: () => null);

                  return Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: AppointmentItem(
                      name: itemName?.fullName ?? "",
                      id: appointmentNews?.code,
                      datetime: appointmentNews?.appointmentTime,
                      doctor: appointmentNews?.staffName ?? "",
                      idDoctor: appointmentNews?.staffId ?? '',
                      department: null,
                      relationship: itemRelationship?.value ?? "",
                      appointmentOrder: appointmentNews?.appointmentOrder,
                      isAppointmentDateTime:
                          appointmentNews.isAppointmentDateTime,
                      status: appointmentNews?.status,
                      currentOrder: appointmentNews?.currentOrder,
                      staffId: appointmentNews?.staffUserId,
                      // button: SizedBox(
                      //   child: Text('abcabc'),
                      // ),
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApponitmentDetail(
                              appointmentFilterQuery: _appointmentFilterQuery,
                              appointmentId: appointmentNews.id,
                              name: itemName.fullName,
                              appointmentNews: appointmentNews,
                              stateNumber: widget.stateNumber,
                            ),
                          ),
                        );
                      },
                    ),
                  );
                }),
              );
      },
    );
  }
}
