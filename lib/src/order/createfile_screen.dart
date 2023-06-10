import 'package:age/age.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/qr_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/order/createinfor_screen.dart';
import 'package:suns_med/src/order/session_createfile_bloc.dart';
import 'package:suns_med/src/order/session_dropdownvalue_bloc.dart';
import 'package:suns_med/src/order/session_qrcode_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CreateFileScreen extends StatefulWidget {
  final String staffId,
      staffName,
      address,
      timeSelect,
      servicePackageId,
      branchId;
  final DateTime dateTime;
  final int fromAge, toAge, gender;
  final bool useBookingTime;
  CreateFileScreen(
      {this.dateTime,
      this.staffId,
      this.address,
      this.timeSelect,
      this.useBookingTime,
      this.staffName,
      this.servicePackageId,
      this.fromAge,
      this.toAge,
      this.gender,
      this.branchId});
  @override
  _CreateFileScreenState createState() => _CreateFileScreenState();
}

class _CreateFileScreenState extends State<CreateFileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  QrModel _qrCodeModel = QrModel();
  ContactModel contact;
  DateTime today = DateTime.now();

  bool isValis = false;
  bool emailValid = true;
  var result;

  final relationShipBloc = DropdownValueBloc();

  final bloc = CreateFileBloc();

  final qrCodeBloc = QrCodeBloc();

  TextEditingController dateCtl = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();

      _qrCodeModel.qrCode = qrResult;
      qrCodeBloc.dispatch(GenerateQrCodeEvent(qrModel: _qrCodeModel));
      // bloc.dispatch(EventInputOrdinalNumber(
      //     printOrdinalNumberModel: printOrdinalNumberModel));
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknown Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    } catch (ex) {
      setState(() {
        result = "Unknown Error $ex";
      });
    }
  }

  @override
  void initState() {
    bloc.dispatch(EventResetState());
    relationShipBloc.dispatch(LoadRelationShipEvent());
    contact = ContactModel(
      barcode: "",
      address: "",
      history: "",
    );

    super.initState();
  }

  bool _checkSpaceSpace(String value) {
    Pattern pattern = r'(?=.*?[A-Za-z])';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.white,
      // appBar: AppBar(
      //   centerTitle: true,
      //   title: Text(
      //     AppLocalizations.of(context).addProfile,
      //     style:TextStyle(
      //             fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
      //   ),
      //   backgroundColor: AppColor.orangeColor,
      // ),
      appBar: const TopAppBar(),
      body: SingleChildScrollView(
        child: Form(
          key: globalFormKey,
          child: Column(
            children: [
              CustomAppBar(
                title: AppLocalizations.of(context).addProfile,
                titleSize: 18,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                //padding: const EdgeInsets.all(0),
                child: BlocProvider<CreateFileEvent, CreateFileState,
                    CreateFileBloc>(
                  bloc: bloc,
                  builder: (state) {
                    // return BlocProvider<QrCodeEvent, QrCodeState, QrCodeBloc>(
                    //     bloc: qrCodeBloc,
                    //     builder: (qrState) {
                    //var userFromQr = qrState.userFromQrCode;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitle(AppLocalizations.of(context).name),
                        Container(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  //margin: EdgeInsets.only(right: 15),
                                  child: _buildTextField(
                                    AppLocalizations.of(context).name,
                                    controller: _name,
                                    onChanged: (t) {
                                      contact.fullName = t;
                                    },
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(100),
                                    ],
                                    validator: (input) => input.isEmpty ||
                                            _checkSpaceSpace(input) != true
                                        ? "${AppLocalizations.of(context).notEnter}${AppLocalizations.of(context).name}"
                                        : null,
                                    type: TextInputType.text,
                                  ),
                                ),
                              ),
                              // InkWell(
                              //   onTap: () {
                              //     _scanQR().then((value) => setState(() {
                              //           _name.text = userFromQr.name;
                              //           _address.text = userFromQr.address;
                              //           contact?.gender = userFromQr.gender;
                              //           dateCtl.text = DateFormat.yMMMEd('vi')
                              //               .format(userFromQr.birthday);
                              //         }));
                              //   },
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(bottom: 5),
                              //     child: Image.asset(
                              //       'assets/images/qr.png',
                              //       width: 40,
                              //       height: 40,
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle(
                            AppLocalizations.of(context).selectRelationship),
                        _dropDownRelashiption(),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle(AppLocalizations.of(context).dob),
                        Container(
                          margin: EdgeInsets.only(top: 5),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white,
                              border: Border.all(color: AppColor.lightGray)),
                          padding: const EdgeInsets.only(left: 13),
                          child: InkWell(
                            onTap: () {
                              showDatePicker(
                                      context: context,
                                      initialDate: DateTime.now(),
                                      firstDate: DateTime(1920),
                                      lastDate: DateTime.now())
                                  .then(
                                (date) {
                                  if (date != null &&
                                      date != contact?.birthDay) {
                                    setState(() {
                                      contact.birthDay = date;
                                      dateCtl.text =
                                          DateFormat.yMMMEd('vi').format(date);
                                    });
                                    print(date);
                                  } else {
                                    print(date);
                                  }
                                },
                              );
                            },
                            child: IgnorePointer(
                              child: new TextFormField(
                                decoration: new InputDecoration(
                                  hintText:
                                      '${AppLocalizations.of(context).pleaseEnter}${AppLocalizations.of(context).dob}',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                // maxLength: 10,
                                // validator: validateDob,
                                controller: dateCtl,
                                // onChanged: (t) {
                                //   DateTime day = DateTime.parse(t);
                                //       contact.birthDay = day;
                                //     },
                                // validator: (input) {
                                // DateTime dateTime =
                                //     DateTime.parse(dateCtl?.text);
                                // AgeDuration age = Age.dateDifference(
                                //     fromDate: dateTime,
                                //     toDate: today,
                                //     includeToDate: false);

                                //   if (age.years >= widget.fromAge &&
                                //           age.years <= widget.toAge ||
                                //       age.years >= widget.fromAge &&
                                //           widget.toAge == null ||
                                //       age.years <= widget.toAge &&
                                //           widget.fromAge == null ||
                                //       widget.toAge == null &&
                                //           widget.fromAge == null) {
                                //     return null;
                                //   }
                                //   return "message";
                                // },
                                // validator: (t) {
                                //   DateTime dateTime = DateTime.parse(t);
                                //   AgeDuration age = Age.dateDifference(
                                //       fromDate: dateTime,
                                //       toDate: today,
                                //       includeToDate: false);
                                //   if (age.years <= widget.fromAge || t == null || t.isEmpty || age.years >= widget.toAge) {
                                //     return "Vui lòng chọn năm sinh";
                                //   }
                                //   return null;
                                //   // if (t == null || t.isEmpty) {
                                //   //   return "Vui lòng chọn năm sinh";
                                //   // }
                                //   // return null;
                                // },
                                validator: (t) => t == null || t.isEmpty
                                    ? "${AppLocalizations.of(context).pleaseEnter}${AppLocalizations.of(context).dob}"
                                    : null,
                                // onSaved: (String val) {},
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle('Email'),
                        _buildTextField(
                          'Email',
                          onChanged: (t) {
                            contact.email = t;
                            emailValid = RegExp(
                                    r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                .hasMatch(contact?.email);
                          },
                          validator: (t) => emailValid == true
                              ? null
                              : "Email${AppLocalizations.of(context).invalid}",
                          type: TextInputType.emailAddress,
                        ),

                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle(AppLocalizations.of(context).phoneNumber),
                        // Container(
                        //   margin: EdgeInsets.only(left: 21, right: 21, top: 10),
                        //   child: Row(
                        //     crossAxisAlignment: CrossAxisAlignment.end,
                        //     children: [
                        //       Expanded(
                        //         child: Container(
                        //           margin: EdgeInsets.only(right: 15),
                        //           child:
                        _buildTextField(
                          AppLocalizations.of(context).phoneNumber,
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(10),
                          ],
                          onChanged: (t) {
                            contact.phoneNumber = t;
                          },
                          validator: (input) {
                            var message;
                            if (_checkPhoneNumber(input) != true) {
                              message =
                                  "${AppLocalizations.of(context).phoneNumber}${AppLocalizations.of(context).invalid}";
                            }
                            return message;
                          },
                          type: TextInputType.phone,
                        ),
                        //   ),
                        // ),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle(AppLocalizations.of(context).gender),
                        _dropDownGender(),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle('CMND / CCCD'),
                        _buildTextField(
                          'CMND CCCD',
                          inputFormatters: [
                            new LengthLimitingTextInputFormatter(12),
                          ],
                          onChanged: (t) {
                            contact.personalNumber = t;
                          },
                          validator: (input) {
                            var message;
                            if (_checkPersonalNumber(input) != true) {
                              message =
                                  "CMND/CCCD${AppLocalizations.of(context).invalid}";
                            }
                            return message;
                          },
                          type: TextInputType.number,
                        ),
                        SizedBox(
                          height: 17,
                        ),
                        _buildTitle(
                            AppLocalizations.of(context).specificAddress),
                        _buildTextField(
                          AppLocalizations.of(context).specificAddress,
                          controller: _address,
                          onChanged: (t) {
                            contact.address = t;
                          },
                          validator: (input) => input.isEmpty ||
                                  _checkSpaceSpace(input) != true
                              ? "${AppLocalizations.of(context).notEnter}${AppLocalizations.of(context).specificAddress}"
                              : null,
                          type: TextInputType.text,
                        ),

                        _buildButton(),
                      ],
                    );
                    // });
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  bool _checkPersonalNumber(String personalNumber) {
    if (personalNumber == null || personalNumber.isEmpty) {
      return true;
    } else if (personalNumber.length == 12 &&
            _personalNumberValidator(personalNumber) == true ||
        personalNumber.length == 9 &&
            _personalNumberValidator(personalNumber) == true) {
      return true;
    } else {
      return false;
    }
  }

  bool _personalNumberValidator(String value) {
    Pattern pattern = r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  bool _checkPhoneNumber(String phoneNumber) {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      return true;
    } else if (phoneNumber.length == 10 &&
        phoneNumber.startsWith('0') &&
        _phoneNumberValidator(phoneNumber) == true) {
      return true;
    } else {
      return false;
    }
  }

  bool _phoneNumberValidator(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = new RegExp(pattern);
    if (!regExp.hasMatch(value)) {
      return false;
    } else {
      return true;
    }
  }

  bool validateAndSave() {
    final form = globalFormKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  _dropDownRelashiption() {
    return BlocProvider<DropdownValueEvent, DropdownValueState,
        DropdownValueBloc>(
      bloc: relationShipBloc,
      builder: (output) {
        return Container(
          width: double.infinity,
          margin: EdgeInsets.only(top: 5),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.white,
                border: Border.all(color: AppColor.lightGray)),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: DropdownButtonFormField<int>(
                value: contact == null ? 0 : contact?.relationShip,
                icon: Icon(
                  Icons.keyboard_arrow_down_outlined,
                  color: Colors.black,
                ),
                validator: (value) => value == null
                    ? '${AppLocalizations.of(context).notEnter}${AppLocalizations.of(context).relationship}'
                    : null,
                decoration: InputDecoration(
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white))),
                onChanged: (int newValue) {
                  setState(() {
                    contact?.relationShip = newValue;
                  });
                },
                hint: Text(
                  AppLocalizations.of(context).selectRelationship,
                  style: TextStyle(
                      fontFamily: 'Montserrat-M',
                      fontSize: 16,
                      color: AppColor.lavender),
                ),
                items: output?.relationShip?.map<DropdownMenuItem<int>>(
                      (RelationshipModel value) {
                        return DropdownMenuItem<int>(
                          value: value.key,
                          child: Text(
                            value.value,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        );
                      },
                    )?.toList() ??
                    [],
              ),
            ),
          ),
        );
      },
    );
  }

  _dropDownGender() {
    return BlocProvider<DropdownValueEvent, DropdownValueState,
        DropdownValueBloc>(
      bloc: relationShipBloc,
      builder: (output) {
        return Container(
            width: double.infinity,
            margin: EdgeInsets.only(top: 5),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: AppColor.lightGray)),
              child: Padding(
                padding: const EdgeInsets.only(left: 13.0),
                child: DropdownButtonFormField<int>(
                  value: contact == null ? 0 : contact?.gender,
                  icon: Icon(
                    Icons.keyboard_arrow_down_outlined,
                    color: Colors.black,
                  ),
                  decoration: InputDecoration(
                      enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white))),
                  validator: (value) => value != null
                      //  &&
                      //             value == widget.gender ||
                      //         widget.gender == null
                      ? null
                      : '${AppLocalizations.of(context).gender}${AppLocalizations.of(context).invalid}',
                  onChanged: (int newValue) {
                    setState(() {
                      contact?.gender = newValue;
                    });
                  },
                  hint: Text(
                    AppLocalizations.of(context).gender,
                    style: TextStyle(
                        fontFamily: 'Montserrat-M',
                        fontSize: 16,
                        color: AppColor.lavender),
                  ),
                  items: output?.gender
                          ?.map<DropdownMenuItem<int>>((GenderModel value) {
                        return DropdownMenuItem<int>(
                          value: value.key,
                          child: Text(
                            value.value,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: Colors.black),
                          ),
                        );
                      })?.toList() ??
                      [],
                ),
              ),
            ));
      },
    );
  }

  // Future _scan() async {
  //   await Permission.camera.request();
  //   String barcode = await scanner.scan();
  //   if (barcode == null) {
  //     print('nothing return.');
  //   } else {
  //     this._outputController.text = barcode;
  //   }
  // }
  _buildTitle(String text) {
    return Text(
      text,
      style: TextStyle(
          fontFamily: 'Montserrat-M',
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: AppColor.darkPurple),
    );
  }

  _buildButton() {
    return BlocProvider<CreateFileEvent, CreateFileState, CreateFileBloc>(
        bloc: bloc,
        navigator: (state) {
          if (state.checkState == true) {
            //(widget?.staffId == null)
            //?
            Navigator.pop(context);
            // : Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(
            //       builder: (context) => CreateInforScreen(
            //           timeSelect: widget.timeSelect,
            //           useBookingTime: widget.useBookingTime,
            //           staffId: this.widget.staffId,
            //           servicePackageId: widget.servicePackageId,
            //           isCreated: false,
            //           staffName: this.widget.staffName,
            //           address: this.widget.address,
            //           patientId: state.contactId ?? 0,
            //           contact: contact,
            //           dateTime: this.widget.dateTime,
            //           branchId: widget.branchId),
            //     ),
            //);
          }
        },
        builder: (state) {
          // AgeDuration age = Age.dateDifference(
          //     fromDate: contact?.birthDay == null ? today : contact?.birthDay,
          //     toDate: today,
          //     includeToDate: false);
          return Container(
            margin: EdgeInsets.symmetric(vertical: 20),
            child: CustomButton(
              onPressed: () {
                if (validateAndSave() == true && emailValid == true
                    // &&
                    // widget?.staffId != null
                    ) {
                  //   if (age.years >= widget.fromAge &&
                  //           age.years <= widget.toAge ||
                  //       age.years >= widget.fromAge && widget.toAge == null ||
                  //       age.years <= widget.toAge && widget.fromAge == null ||
                  //       widget.toAge == null && widget.fromAge == null) {
                  bloc.dispatch(
                    EventCreateFile(
                      // dateTime: _dateTime,
                      contact: this.contact,
                    ),
                  );
                }
                // else {
                //   Flushbar(
                //     margin: EdgeInsets.all(8),
                //     borderRadius: 8,
                //     title: 'Thông báo',
                //     message:
                //         AppLocalizations.of(context).servicePackageInvalid,
                //     duration: Duration(seconds: 3),
                //   )..show(context);
                // }
                // }

                // if (validateAndSave() == true && emailValid == true) {
                //   bloc.dispatch(
                //     EventCreateFile(
                //       // dateTime: _dateTime,
                //       contact: this.contact,
                //     ),
                //   );
                // }
              },
              radius: BorderRadius.circular(26),
              color: AppColor.purple,
              text: AppLocalizations.of(context).addProfile,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 16,
                  color: AppColor.white),
            ),
          );
        });
  }

  _buildTextField(
    String hintText, {
    Function(String) onChanged,
    TextEditingController controller,
    String Function(String) validator,
    TextInputType type,
    List<TextInputFormatter> inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          border: Border.all(
            color: AppColor.lightGray,
          )),
      padding: EdgeInsets.only(left: 13),
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
        // key: globalFormKey,
        controller: controller,
        inputFormatters: inputFormatters,
        keyboardType: type,
        onChanged: onChanged,
        // maxLength: maxLength,
        // onSaved: (input) => loginModel.userName = input,
        validator: validator,
        decoration: InputDecoration(
          hintText: hintText,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}

class QrCodeModel {
  final String name, birthday, address;
  QrCodeModel({this.name, this.address, this.birthday});
}
