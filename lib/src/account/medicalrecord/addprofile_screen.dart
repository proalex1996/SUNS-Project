import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/management_portal_new/common/dto/qr_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';

import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/account/medicalrecord/session_medicalrecord_bloc.dart';
import 'package:suns_med/src/order/session_createfile_bloc.dart';
import 'package:suns_med/src/order/session_dropdownvalue_bloc.dart';
import 'package:suns_med/src/order/session_qrcode_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddProfileScreen extends StatefulWidget {
  @override
  _AddProfileScreenState createState() => _AddProfileScreenState();
}

class _AddProfileScreenState extends State<AddProfileScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  // TextEditingController dateCtl = TextEditingController();
  TextEditingController _name = TextEditingController();
  TextEditingController _address = TextEditingController();

  ContactModel contact = ContactModel();
  QrModel _qrCodeModel = QrModel();

  final addProfileBloc = CreateFileBloc();
  final relationShipBloc = DropdownValueBloc();
  final bloc = MedicalRecordBloc();

  final qrCodeBloc = QrCodeBloc();

  bool isValis = false;
  var result;

  bool emailValid = true;
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

  bool _checkSpaceSpace(String value) {
    Pattern pattern = r'(?=.*?[A-Za-z])';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }

  @override
  void initState() {
    relationShipBloc.dispatch(LoadRelationShipEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitetwo,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context).addProfile,
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        backgroundColor: AppColor.orangeColorDeep,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Form(
            key: globalFormKey,
            child:
                BlocProvider<CreateFileEvent, CreateFileState, CreateFileBloc>(
              bloc: addProfileBloc,
              navigator: (state) {
                if (state?.checkState == true) {
                  Navigator.pop(context);
                  //Todo remove bloc.dispatch
                  bloc.dispatch(LoadMedicalRecordEvent());
                }
              },
              builder: (output) {
                return BlocProvider<QrCodeEvent, QrCodeState, QrCodeBloc>(
                  bloc: qrCodeBloc,
                  builder: (qrState) {
                    var userFromQr = qrState.userFromQrCode;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                blurRadius: 6,
                                spreadRadius: 0,
                                offset: Offset(0, 3),
                                color: Colors.black12,
                              ),
                            ],
                            color: AppColor.veryLightPinkFour,
                          ),
                          height: 40,
                          padding: const EdgeInsets.only(left: 21, top: 10),
                          child: Text(
                            'Điền thông tin để thêm hồ sơ',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColor.deepBlue),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          padding: const EdgeInsets.only(left: 21, right: 21),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: _buildTextField(
                                    AppLocalizations.of(context).name,
                                    onChanged: (t) {
                                      contact.fullName = t;
                                    },
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(100),
                                    ],
                                    validator: (input) => input.isEmpty ||
                                            _checkSpaceSpace(input) != true
                                        ? "Chưa nhập họ và tên"
                                        : null,
                                    type: TextInputType.text,
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  _scanQR().then((value) => setState(() {
                                        _name.text = userFromQr.name;
                                        _address.text = userFromQr.address;
                                        contact?.gender = userFromQr.gender;
                                        dateCtl.text = DateFormat.yMMMEd('vi')
                                            .format(userFromQr.birthday);
                                      }));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 5),
                                  child: Image.asset(
                                    'assets/images/qr.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        _dropDownRelashiption(),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 21, right: 21),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 15,
                                  offset: Offset(0, 0),
                                ),
                              ],
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.white),
                          padding: const EdgeInsets.only(left: 13),
                          child: InkWell(
                            onTap: () {
                              // _selectDate();
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
                                  hintText: 'Vui lòng chọn năm sinh',
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                // maxLength: 10,
                                // validator: validateDob,
                                controller: dateCtl,

                                validator: (t) => t == null || t.isEmpty
                                    ? "Vui lòng chọn năm sinh"
                                    : null,
                                // onSaved: (String val) {},
                              ),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 21, left: 21, top: 10),
                          child: _buildTextField(
                            'Email',
                            onChanged: (t) {
                              contact.email = t;
                              emailValid = RegExp(
                                      r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                  .hasMatch(contact?.email);
                            },
                            type: TextInputType.emailAddress,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 21, right: 21, top: 10),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Container(
                                  margin: EdgeInsets.only(right: 15),
                                  child: _buildTextField(
                                    'Số điện thoại',
                                    onChanged: (t) {
                                      contact.phoneNumber = t;
                                    },
                                    inputFormatters: [
                                      new LengthLimitingTextInputFormatter(10),
                                    ],
                                    validator: (input) {
                                      var message;
                                      if (_checkPhoneNumber(input) != true) {
                                        message = "Số điện thoại không hợp lệ";
                                      }
                                      return message;
                                    },
                                    type: TextInputType.phone,
                                  ),
                                ),
                              ),
                              _dropDownGender(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 21, left: 21, top: 10),
                          child: _buildTextField(
                            'Số CMND',
                            onChanged: (t) {
                              contact.personalNumber = t;
                            },
                            inputFormatters: [
                              new LengthLimitingTextInputFormatter(12),
                            ],
                            validator: (input) {
                              var message;
                              if (_checkPersonalNumber(input) != true) {
                                message = "Chứng minh thư không hợp lệ";
                              }
                              return message;
                            },
                            type: TextInputType.number,
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(right: 21, left: 21, top: 10),
                          child: _buildTextField(
                            'Địa chỉ cụ thể',
                            onChanged: (t) {
                              contact.address = t;
                            },
                            validator: (input) =>
                                input.isEmpty || _checkSpaceSpace(input) != true
                                    ? "Cần nhập địa chỉ cụ thể"
                                    : null,
                            type: TextInputType.text,
                            // controller: _addressController,
                          ),
                        ),
                        _buildButton(),
                      ],
                    );
                  },
                );
              },
            ),
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

  _buildButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: CustomButton(
        onPressed: () {
          final form = globalFormKey.currentState;
          if (form.validate()) {
            form.save();
            addProfileBloc.dispatch(
              EventCreateFile(
                contact: this.contact,
              ),
            );
          }
        },
        radius: BorderRadius.circular(26),
        color: AppColor.orangeColorDeep,
        text: "Thêm thông tin",
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: AppColor.white),
      ),
    );
  }

  // bool validateAndSave() {
  //   final form = globalFormKey.currentState;
  //   if (form.validate()) {
  //     form.save();
  //     return true;
  //   }
  //   return false;
  // }

  // _buildTextField(
  //   String hintText, {
  //   Function(String) onChanged,
  //   // TextEditingController controller,
  //   Function(String) validator,
  //   TextInputType type,
  // }) {
  //   return Container(
  //     decoration: BoxDecoration(boxShadow: [
  //       BoxShadow(
  //         color: Colors.black12,
  //         blurRadius: 15,
  //         offset: Offset(0, 0),
  //       ),
  //     ], borderRadius: BorderRadius.circular(6), color: Colors.white),
  //     padding: const EdgeInsets.only(left: 13),
  //     child: TextFormField(
  //       // key: globalFormKey,
  //       keyboardType: type,
  //       onChanged: onChanged,
  //       // onSaved: (input) => loginModel.userName = input,
  //       validator: validator,
  //       decoration: InputDecoration(
  //         hintText: hintText,
  //         enabledBorder: InputBorder.none,
  //         focusedBorder: InputBorder.none,
  //       ),
  //     ),
  //   );
  // }

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
          margin: EdgeInsets.only(left: 21, right: 21, top: 10),
          child: Container(
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 15,
                offset: Offset(0, 0),
              ),
            ], borderRadius: BorderRadius.circular(6), color: Colors.white),
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: DropdownButtonFormField<int>(
                value: contact == null ? 0 : contact?.relationShip,
                icon: Icon(
                  Icons.arrow_drop_down,
                  color: Color(0xffb7b7b7),
                ),
                validator: (value) =>
                    value == null ? 'Chưa chọn mối quan hệ' : null,
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
          width: 140,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 15,
              offset: Offset(0, 0),
            ),
          ], borderRadius: BorderRadius.circular(6), color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: DropdownButtonFormField<int>(
              value: contact == null ? 0 : contact?.gender,
              icon: Icon(
                Icons.arrow_drop_down,
                color: Color(0xffb7b7b7),
              ),
              decoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white))),
              validator: (value) =>
                  value == null ? 'Chưa chọn giới tính' : null,
              onChanged: (int newValue) {
                setState(() {
                  contact?.gender = newValue;
                });
              },
              hint: Text(
                'Giới tính',
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
        );
      },
    );
  }

  // _buildSelectedDay() {
  //   return Container(
  //     width: double.infinity,
  //     height: 50,
  //     alignment: Alignment.centerLeft,
  //     margin: EdgeInsets.only(left: 20, right: 20),
  //     decoration: BoxDecoration(boxShadow: [
  //       BoxShadow(
  //         color: Colors.black12,
  //         blurRadius: 15,
  //         offset: Offset(0, 0),
  //       ),
  //     ], borderRadius: BorderRadius.circular(6), color: Colors.white),
  //     padding: const EdgeInsets.all(13),
  //     child: Text(
  //       contact?.birthDay == null
  //           ? "Vui lòng chọn năm sinh"
  //           : DateFormat.yMMMd('vi').format(contact?.birthDay),
  //       style:TextStyle(
  //          fontFamily: 'Montserrat-M',fontSize: 16),
  //     ),
  //   );
  // }

  _buildTextField(
    String hintText, {
    Function(String) onChanged,
    // TextEditingController controller,
    String Function(String) validator,
    TextInputType type,
    List<TextInputFormatter> inputFormatters,
  }) {
    return Container(
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 15,
          offset: Offset(0, 0),
        ),
      ], borderRadius: BorderRadius.circular(6), color: Colors.white),
      padding: const EdgeInsets.only(left: 13),
      child: TextFormField(
          // key: globalFormKey,
          keyboardType: type,
          onChanged: onChanged,
          inputFormatters: inputFormatters,
          // onSaved: (input) => loginModel.userName = input,
          validator: validator,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          )),
    );
  }
}
