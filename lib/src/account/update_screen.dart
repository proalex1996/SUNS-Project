import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/district_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/ward_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_update_model.dart';
import 'package:suns_med/src/Widgets/button.dart';
import 'package:suns_med/src/account/session_updateinfo_bloc.dart';
import 'package:suns_med/src/order/session_order_bloc.dart';
import 'package:suns_med/src/order/session_dropdownvalue_bloc.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/gender_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateScreen extends StatefulWidget {
  final bool isUpdateAndCreated;
  UpdateScreen({Key key, @required this.isUpdateAndCreated});
  @override
  _UpdateScreenState createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  //int _index;
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  TextEditingController dateCtl = TextEditingController();
  // ProvinceModel _province;
  // DistrictModel _district;
  // WardModel _ward;
  DateTime _dateTime;
  final orderBloc = OrderBloc();
  final bloc = SessionBloc();
  final updateBloc = UpdateBloc();
  final relationShipBloc = DropdownValueBloc();

  TextEditingController provinceController = TextEditingController();
  TextEditingController districsController = TextEditingController();
  TextEditingController wardController = TextEditingController();

  UserUpdateModel userUpdate = UserUpdateModel();

  @override
  void initState() {
    updateBloc.dispatch(LoadProvincesEvent());
    bloc.dispatch(EventGetUser());
    if (bloc.state.user.provinceId != null) {
      updateBloc
          .dispatch(LoadDistrictEvent(provinceId: bloc.state.user.provinceId));
    }
    if (bloc.state.user.districtId != null) {
      updateBloc
          .dispatch(LoadWardsEvent(districtId: bloc.state.user.districtId));
    }
    if (relationShipBloc.state.gender == null) {
      relationShipBloc.dispatch(LoadRelationShipEvent());
    }

    //_index = bloc.state.user?.gender ?? 0;
    var a = DateFormat.yMMMd("vi").format(bloc.state.user?.birthDay);
    dateCtl.text = a;
    provinceController.text = bloc.state.user.province;
    districsController.text = bloc.state.user.district;
    wardController.text = bloc.state.user.ward;
    super.initState();
    userUpdate = UserUpdateModel(
      phoneNumber: bloc.state.user?.phoneNumber,
      avatar: bloc.state.user?.avatar == null ? "" : bloc.state.user?.avatar,
      birthDay: bloc.state.user?.birthDay?.toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).updateInformation,
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppColor.deepBlue,
      ),
      body: Form(
        key: globalFormKey,
        child: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
          child: BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
              navigator: widget.isUpdateAndCreated == true
                  ? (state) {
                      if (state.userModel != null) {
                        Navigator.pop(context);
                        orderBloc.dispatch(ChooseFileEvent());
                      }
                    }
                  : (state) {
                      if (state.userModel != null) {
                        Navigator.pop(context);
                        bloc.dispatch(EventGetUser());
                      }
                    },
              bloc: updateBloc,
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildTitle(AppLocalizations.of(context).name),
                    _buildCustomTextField(
                      "Nhập họ và tên",
                      bloc.state.user.fullName == null ||
                              bloc.state.user.fullName.isEmpty
                          ? true
                          : false,
                      initalValue: bloc.state.user?.fullName,
                      onChange: (t) {
                        userUpdate.fullName = t;
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
                    _buildTitle('Email'),
                    _buildCustomTextField(
                      "Nhập email",
                      // bloc.state.user.email == null ||
                      //         bloc.state.user.email.isEmpty
                      //     ? true
                      //     : false,
                      true,
                      initalValue: bloc.state.user?.email,
                      onChange: (t) {
                        userUpdate.email = t;
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
                      initalValue: bloc.state.user.address,
                      onChange: (t) {
                        userUpdate.address = t;
                      },
                      validator: (t) =>
                          t == null || t.isEmpty ? "Cần nhập " : null,
                    ),
                    _dropDownProvince(),
                    _dropDownDistrict(),
                    _dropDownWards(),
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
                      initalValue: bloc.state.user.personalNumber,
                      onChange: (t) {
                        userUpdate.personalNumber = t;
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
                    _buildCustomButton()
                  ],
                );
              }),
        )),
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

  _buildSelectedDay() {
    return Container(
      decoration: BoxDecoration(
          border: Border.all(color: AppColor.lightGray),
          borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 13),
      margin: EdgeInsets.only(top: 5),
      child: TextFormField(
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
          _dateTime = date;
          if (_dateTime != null)
            dateCtl.text = DateFormat.yMMMEd('vi').format(_dateTime);
        },
        // enabled: false,

        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: "Vui lòng chọn năm sinh",
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
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
              child: DropdownButton<int>(
                value: userUpdate.gender == null
                    ? bloc?.state?.user?.gender
                    : userUpdate.gender,
                underline: SizedBox(),
                icon: Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.black,
                ),
                isExpanded: true,
                // validator: (value) =>
                //     value == null ? 'Chưa chọn trạng thái' : null,
                // decoration: InputDecoration(
                //     enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(color: Colors.white))),
                onChanged: (int newValue) {
                  setState(() {
                    userUpdate?.gender = newValue;
                    //_index = newValue;
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
              ));
        });
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

  _buildCustomButton() {
    return Container(
      padding: const EdgeInsets.only(left: 31, right: 31, bottom: 20),
      child: CustomButton(
        color: AppColor.purple,
        onPressed: () {
          final form = globalFormKey.currentState;
          if (form.validate()) {
            form.save();
            updateBloc.dispatch(UpdateInForEvent(
              dateTime: _dateTime == null
                  ? bloc.state.user?.birthDay?.toIso8601String()
                  : _dateTime.toIso8601String(),
              address: userUpdate.address ?? bloc.state.user.address,
              email: userUpdate.email ?? bloc.state.user.email,
              index: userUpdate?.gender ?? bloc?.state?.user?.gender,
              name: userUpdate.fullName ?? bloc.state.user.fullName,
              personID:
                  userUpdate.personalNumber ?? bloc.state.user.personalNumber,
              province: userUpdate.province ?? bloc.state.user.provinceId,
              district: userUpdate.district ?? bloc.state.user.districtId,
              ward: userUpdate.ward ?? bloc.state.user.wardId,
              phone: bloc.state.user.phoneNumber,
            ));
          }
        },
        radius: BorderRadius.circular(26),
        text: AppLocalizations.of(context).update,
        style: TextStyle(
            fontFamily: 'Montserrat-M', fontSize: 16, color: Colors.white),
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

  _dropDownProvince() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGray),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: TypeAheadFormField<ProvinceModel>(
              textFieldConfiguration: TextFieldConfiguration(
                controller: provinceController,
                autofocus: false,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.darkPurple),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        provinceController.clear();
                      });
                    },
                    color: Colors.black12,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                  hintText: AppLocalizations.of(context).province,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) => state.provinces.where(
                (e) => e.name.toLowerCase().contains(pattern.toLowerCase()),
              ),
              itemBuilder: (context, ProvinceModel province) {
                return ListTile(
                  title: Text(province.name),
                );
              },
              onSuggestionSelected: (suggestion) {
                districsController.clear();
                wardController.clear();
                userUpdate.province = suggestion.id;
                updateBloc
                    .dispatch(LoadDistrictEvent(provinceId: suggestion.id));
                provinceController.text = suggestion.name;
              },
              getImmediateSuggestions: true,
            ),
          ),
        );
      },
    );
  }

  // _dropDownProvince() {
  //   return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
  //     bloc: updateBloc,
  //     builder: (state) {
  //       return Container(
  //         margin: EdgeInsets.only(top: 10),
  //         decoration: BoxDecoration(boxShadow: [
  //           BoxShadow(
  //             color: Colors.black12,
  //             blurRadius: 15,
  //             offset: Offset(0, 0),
  //           ),
  //         ], borderRadius: BorderRadius.circular(6), color: Colors.white),
  //         child: Padding(
  //           padding: const EdgeInsets.only(left: 13.0),
  //           child: DropdownButtonFormField<String>(
  //             value: _province != null
  //                 ? _province.id
  //                 : bloc.state.user.provinceId == null
  //                     ? null
  //                     : bloc.state.user.provinceId,
  //             icon: Icon(
  //               Icons.arrow_drop_down,
  //               color: Color(0xffb7b7b7),
  //             ),
  //             validator: (value) =>
  //                 value == null || value.isEmpty ? 'Chọn Tỉnh/Thành' : null,
  //             decoration: InputDecoration(
  //                 enabledBorder: UnderlineInputBorder(
  //                     borderSide: BorderSide(color: Colors.white))),
  //             onChanged: (String newValue) {
  //               setState(() {
  //                 // _province.id = newValue;
  //                 userUpdate.province = newValue;
  //                 _province =
  //                     state.provinces?.firstWhere((e) => e.id == newValue);
  //                 // userUpdate.province = _province.name;
  //                 bloc.state.user.districtId = null;
  //                 bloc.state.user.wardId = null;
  //                 _district = null;
  //                 _ward = null;
  //               });
  //               updateBloc.dispatch(LoadDistrictEvent(provinceId: newValue));
  //             },
  //             hint: Text(
  //               'Chọn Tỉnh/Thành',
  //               style:TextStyle(
  //     fontFamily: 'Montserrat-M',fontSize: 16, color: AppColor.lavender),
  //             ),
  //             items: state?.provinces?.map<DropdownMenuItem<String>>(
  //                   (ProvinceModel value) {
  //                     return DropdownMenuItem<String>(
  //                       value: value.id,
  //                       child: Text(
  //                         value.name,
  //                         style:TextStyle(
  //       fontFamily: 'Montserrat-M',fontSize: 16, color: Colors.black),
  //                       ),
  //                     );
  //                   },
  //                 )?.toList() ??
  //                 [],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }

  _dropDownDistrict() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGray),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: TypeAheadFormField<DistrictModel>(
              // initialValue: bloc.state.user.districtId ?? "",
              textFieldConfiguration: TextFieldConfiguration(
                controller: districsController,
                autofocus: false,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.darkPurple),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        districsController.clear();
                      });
                    },
                    color: Colors.black12,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Quận / Huyện",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) => state.districs.where(
                (e) => e.name.toLowerCase().contains(pattern.toLowerCase()),
              ),
              itemBuilder: (context, DistrictModel district) {
                return ListTile(
                  title: Text(district.name),
                );
              },
              onSuggestionSelected: (suggestion) {
                wardController.clear();
                userUpdate.district = suggestion.id;
                updateBloc.dispatch(LoadWardsEvent(districtId: suggestion.id));
                districsController.text = suggestion.name;
              },
              getImmediateSuggestions: true,
            ),
          ),
        );
      },
    );
  }

  _dropDownWards() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Container(
          margin: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              border: Border.all(color: AppColor.lightGray),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white),
          child: Padding(
            padding: const EdgeInsets.only(left: 13.0),
            child: TypeAheadFormField<WardModel>(
              // initialValue: bloc.state.user.wardId ?? "",
              textFieldConfiguration: TextFieldConfiguration(
                controller: wardController,
                autofocus: false,
                style: TextStyle(
                    fontFamily: 'Montserrat-M',
                    fontSize: 16,
                    color: AppColor.darkPurple),
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        wardController.clear();
                      });
                    },
                    color: Colors.black12,
                    icon: Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ),
                  hintText: "Phường / Xã",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              suggestionsCallback: (pattern) => state.wards.where(
                (e) => e.name.toLowerCase().contains(pattern.toLowerCase()),
              ),
              itemBuilder: (context, WardModel wards) {
                return ListTile(
                  // leading: Icon(Icons.shopping_cart),
                  title: Text(wards.name),
                  // subtitle: Text('\$${suggestion['price']}'),
                );
              },
              // hideOnEmpty: true,
              onSuggestionSelected: (suggestion) {
                // Navigator.of(context).push(MaterialPageRoute(
                //     builder: (context) => ProductPage(product: suggestion)));
                userUpdate.ward = suggestion.id;
                wardController.text = suggestion.name;
              },
              getImmediateSuggestions: true,
            ),
          ),
        );
      },
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
