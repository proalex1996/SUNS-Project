import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/relationship_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/account/medicalrecord/session_medicalrecord_bloc.dart';
import 'package:suns_med/src/account/medicalrecord/session_update_contact_bloc.dart';
import 'package:suns_med/src/order/session_dropdownvalue_bloc.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/src/services/text_formatter.dart';

class UpdateContactScreen extends StatefulWidget {
  final ContactModel contact;
  UpdateContactScreen({this.contact});
  @override
  _UpdateContactScreenState createState() => _UpdateContactScreenState();
}

class _UpdateContactScreenState extends State<UpdateContactScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  ContactModel _updateContact = ContactModel();
  final updateContactBloc = UpdateContactBloc();
  final relationShipBloc = DropdownValueBloc();
  TextEditingController dateCtl = TextEditingController();

  final bloc = MedicalRecordBloc();
  bool isValis = false;

  @override
  void initState() {
    _updateContact = widget.contact;
    dateCtl.text = DateFormat.yMMMd("vi").format(widget?.contact?.birthDay);
    relationShipBloc.dispatch(LoadRelationShipEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColor.whitetwo,
      appBar: const TopAppBar(),
      body: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: CustomAppBar(
            title: language.addProfile,
            titleSize: 18,
            isTopPadding: true,
          ),
        ),
        body: Form(
          key: globalFormKey,
          child: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
            child: BlocProvider<UpdateContactEvent, UpdateContactState,
                    UpdateContactBloc>(
                // navigator: widget.isUpdateAndCreated == true
                //     ? (state) {
                //         if (state.userModel != null) {
                //           Navigator.pop(context);
                //           orderBloc.dispatch(ChooseFileEvent());
                //         }
                //       }
                //     : (state) {
                //         if (state.userModel != null) {
                //           Navigator.pop(context);
                //           bloc.dispatch(EventGetUser());
                //         }
                //       },
                bloc: updateContactBloc,
                builder: (state) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildTitle(AppLocalizations.of(context).name),
                      _buildCustomTextField(
                        "Nhập họ và tên",
                        widget?.contact?.fullName == null ||
                                widget.contact.fullName.isEmpty
                            ? true
                            : false,
                        initalValue: widget?.contact?.fullName,
                        onChange: (t) {
                          _updateContact.fullName = t;
                        },
                        inputFormatters: [
                          UpperCaseTextFormatter(),
                        ],
                        validator: (t) =>
                            t == null || t.isEmpty ? "Cần nhập họ tên" : null,
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle(AppLocalizations.of(context).relationship),
                      _dropDownRelashiption(),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle('Email'),
                      _buildCustomTextField(
                        "Nhập email",
                        // widget?.contact?.email == null ||
                        //         widget?.contact?.email.isEmpty
                        //     ? true
                        //     : false,
                        true,
                        initalValue: widget?.contact?.email,
                        onChange: (t) {
                          _updateContact.email = t;
                        },
                        validator: (t) => t == null || t.isEmpty
                            ? "Cần nhập email"
                            : t.isValidEmail()
                                ? null
                                : "Email không đúng định dạng.",
                      ),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle(AppLocalizations.of(context).address),
                      _buildCustomTextField(
                        "Địa chỉ cụ thể",
                        true,
                        initalValue: widget?.contact?.address,
                        onChange: (t) {
                          _updateContact.address = t;
                        },
                        validator: (t) =>
                            t == null || t.isEmpty ? "Cần nhập " : null,
                      ),
                      // _dropDownProvince(),
                      // _dropDownDistrict(),
                      // _dropDownWards(),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle(AppLocalizations.of(context).dob),
                      _buildSelectedDay(),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle(AppLocalizations.of(context).gender),
                      _dropDownGender(),
                      SizedBox(
                        height: 17,
                      ),
                      _buildTitle('CMND / CCCD'),
                      _buildCustomTextField(
                        "Nhập CMND / CCCD",
                        true,
                        initalValue: widget?.contact?.personalNumber,
                        onChange: (t) {
                          _updateContact.personalNumber = t;
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
                      ),
                      SizedBox(
                        height: 34.5,
                      ),
                      _buildButton()
                    ],
                  );
                }),
          )),
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

  _buildButton() {
    return Container(
      padding: const EdgeInsets.only(left: 31, right: 31, bottom: 20),
      child: CustomButton(
        onPressed: () {
          final form = globalFormKey.currentState;
          if (form.validate()) {
            form.save();
            updateContactBloc.dispatch(UpdateEvent(
                // dateTime: _dateTime,
                // contact: this.contact,
                contactId: widget.contact.id,
                updateContact: _updateContact));
            Navigator.pop(context);
          }
        },
        color: AppColor.purple,
        radius: BorderRadius.circular(26),
        text: AppLocalizations.of(context).update,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.white),
      ),
    );
  }

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

  _dropDownRelashiption() {
    return BlocProvider<DropdownValueEvent, DropdownValueState,
        DropdownValueBloc>(
      bloc: relationShipBloc,
      builder: (output) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGray),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.only(left: 13, right: 13),
          margin: EdgeInsets.only(top: 5),
          child: DropdownButtonFormField<int>(
            value: _updateContact.relationShip == null
                ? widget.contact.relationShip
                : _updateContact?.relationShip,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
            validator: (value) =>
                value == null ? 'Chưa chọn mối quan hệ' : null,
            isExpanded: true,
            decoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white))),
            onChanged: (int newValue) {
              setState(() {
                _updateContact?.relationShip = newValue;
              });
            },
            hint: Text(
              'Chọn mối quan hệ',
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
                            color: Colors.black,
                            letterSpacing: -0.32),
                      ),
                    );
                  },
                )?.toList() ??
                [],
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
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGray),
              borderRadius: BorderRadius.circular(8)),
          padding: EdgeInsets.only(left: 13, right: 13),
          margin: EdgeInsets.only(top: 5),
          child: DropdownButtonFormField<int>(
            value: _updateContact.gender == null
                ? widget.contact?.gender
                : _updateContact?.gender,
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.black,
            ),
            isExpanded: true,

            // decoration: InputDecoration(
            //     enabledBorder: UnderlineInputBorder(
            //         borderSide: BorderSide(color: Colors.white))),
            validator: (value) => value == null ? 'Chưa chọn giới tính' : null,
            onChanged: (int newValue) {
              setState(() {
                _updateContact?.gender = newValue;
              });
            },
            hint: Text(
              'Chọn giới tính',
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  color: Colors.black,
                  fontSize: 16,
                  letterSpacing: -0.32),
            ),
            items: output?.gender?.map<DropdownMenuItem<int>>(
                  (GenderModel value) {
                    return DropdownMenuItem<int>(
                      value: value.key,
                      child: Text(
                        value.value,
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            fontSize: 16,
                            color: Colors.black,
                            letterSpacing: -0.32),
                      ),
                    );
                  },
                )?.toList() ??
                [],
          ),
        );
      },
    );
  }

  // _buildSelectedDay() {
  //   return Container(
  //     decoration: BoxDecoration(
  //         border: Border.all(color: AppColor.lightGray),
  //         borderRadius: BorderRadius.circular(8)),
  //     padding: EdgeInsets.only(left: 13),
  //     margin: EdgeInsets.only(top: 5),
  //     child: Text(
  //       _dateTime == null
  //           ? DateFormat.yMMMd('vi').format(widget.contact?.birthDay) ??
  //               "Vui lòng chọn năm sinh"
  //           : DateFormat.yMMMd('vi').format(_dateTime),
  //       style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
  //     ),
  //   );
  // }
  _buildSelectedDay() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGray),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 13),
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
        //initialValue: widget?.contact?.birthDay?.toIso8601String(),
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            color: AppColor.darkPurple),
        controller: dateCtl,
        validator: (t) =>
            t == null || t.isEmpty ? "Vui lòng chọn năm sinh" : null,
        onTap: () async {
          DateTime date = DateTime(1900);
          FocusScope.of(context).requestFocus(new FocusNode());

          date = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime(2100));
          if (date != null) {
            _updateContact?.birthDay = date;

            dateCtl.text =
                DateFormat.yMMMEd('vi').format(_updateContact?.birthDay);
          }
        },
        // enabled: false,

        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: DateFormat.yMd('vi').format(widget?.contact?.birthDay),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  _buildCustomTextField(String hintext, bool isNotNameAndEmail,
      {Function(String) onChange,
      TextEditingController controller,
      String initalValue,
      List<TextInputFormatter> inputFormatters,
      String Function(String) validator}) {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGray),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 13),
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
        readOnly: !isNotNameAndEmail,
        validator: validator,
        initialValue: initalValue,
        controller: controller,
        decoration: InputDecoration(
          hintText: hintext,
          border: InputBorder.none,
        ),
        inputFormatters: inputFormatters,
        style: TextStyle(
            fontFamily: 'Montserrat-M',
            fontSize: 16,
            color: AppColor.darkPurple),
        onChanged: onChange,
      ),
    );
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text?.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}
