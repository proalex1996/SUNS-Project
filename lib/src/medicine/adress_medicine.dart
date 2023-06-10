import 'package:carousel_slider/carousel_controller.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:suns_med/common/dimension.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/auth/session_bloc.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/ward_model.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/district_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/user_update_model.dart';
import 'package:suns_med/src/account/notification/session_notification_bloc.dart';
import 'package:suns_med/src/account/session_updateinfo_bloc.dart';
import 'package:suns_med/src/medicine/provider/medicine_session_bloc.dart';
import 'package:suns_med/src/medicine/dto/adress_shipping_model.dart';
import 'package:suns_med/src/medicine/dto/place_order_model.dart';
import 'package:suns_med/src/medicine/shoppingcart_medicine.dart';
import 'completed_adress.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AdressMedicine extends StatefulWidget {
  final listCart;

  AdressMedicine({@required this.listCart});

  @override
  _AdressMedicine createState() => _AdressMedicine();
}

class _AdressMedicine extends State<AdressMedicine> {
  final notifyBloc = NotificationBloc();
  int _current = 0;
  int inSearch = 0;
  int value = 0;
  TextEditingController name = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController address = TextEditingController();
  List _listCart = [];
  String cityId;
  String provinceId;
  String adressId = '';
  String wardId;
  final updateBloc = UpdateBloc();
  final bloc = SessionBloc();
  TextEditingController provinceController = TextEditingController();
  TextEditingController districsController = TextEditingController();
  TextEditingController wardController = TextEditingController();
  UserUpdateModel userUpdate = UserUpdateModel();
  List provine = [];
  List listtemp = [];
  List<Medicines> listModel = [];
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  final medicineBloc = MedicineBloc();
  final medicineState = MedicineState();
  @override
  @override
  void initState() {
    updateBloc.dispatch(LoadProvincesEvent());
    if (bloc.state.user.provinceId != null) {
      updateBloc
          .dispatch(LoadDistrictEvent(provinceId: bloc.state.user.provinceId));
    }
    if (bloc.state.user.districtId != null) {
      updateBloc
          .dispatch(LoadWardsEvent(districtId: bloc.state.user.districtId));
    }

    _listCart = widget.listCart;
    for (int i = 0; i < _listCart.length; i++) {
      listModel.add(Medicines(
          medicineId: _listCart[i].first.id, quantity: _listCart[i].last));
    }

    name.text = bloc.state.user.fullName;
    phoneNumber.text = bloc.state.user.phoneNumber;
    address.text = bloc.state.user.address;
    provinceController.text = bloc.state.user.province;
    cityId = bloc.state.user.provinceId;
    districsController.text = bloc.state.user.district;
    provinceId = bloc.state.user.districtId;
    wardId = bloc.state.user.wardId;
    wardController.text = bloc.state.user.ward;

    super.initState();
  }

  Future submit() async {
    if (name.text == '' ||
        phoneNumber.text == '' ||
        address.text == '' ||
        cityId == '' ||
        cityId == null ||
        provinceId == '' ||
        provinceId == null ||
        wardId == '' ||
        wardId == null) {
      showToastMessage('Vui lòng điền đầy đủ thông tin');
    } else {
      medicineBloc.dispatch(CompletedEvent(
          adressModel: AdressModel(
              name: name.text,
              phone: phoneNumber.text,
              address: address.text,
              cityId: cityId,
              provinceId: provinceId,
              wardId: wardId)));
      medicineBloc.dispatch(LoadAddressEvent());
      Future.delayed(Duration(seconds: 10));
      await fishned();
      ShoppingCartMedicine.cart.clear();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => CompletedMedicine()),
      );
    }
  }

  Future fishned() async {
    await medicineBloc.dispatch(OrderEvent(
        orderModel: PlaceOrdersModel(
            shippingAddressId: medicineBloc.state.resultAdress,
            medicines: listModel)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
          appBar: AppBar(
            toolbarHeight: height(context) * 0.13,
            backgroundColor: AppColor.deepBlue,
            flexibleSpace: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/images/orange-appbar.png'),
                  fit: BoxFit.fitWidth,
                ),
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(
                        width(context) * 0.58, height(context) * 0.1, 0, 0),
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/images/profile/pattern_part_circle.png'),
                          fit: BoxFit.none,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          width(context) * 0.2, height(context) * 0.01, 0, 0),
                      child: IconButton(
                          icon: ImageIcon(
                            AssetImage(
                                "assets/images/profile/ic_trash_bin.png"),
                            color: Colors.white,
                          ),
                          onPressed: () {
                            //showToastMessage('Đã xóa khỏi giỏ hàng');
                          }),
                    ),
                  )
                ],
              ),
            ),
            title: Text(
              AppLocalizations.of(context).addressForReceiving,
              style: TextStyle(
                  fontFamily: 'Montserrat-M',
                  fontSize: 18,
                  color: Colors.white),
            ),
            leading: BlocProvider<NotificationEvent, NotificationState,
                NotificationBloc>(
              bloc: notifyBloc,
              builder: (state) {
                return IconButton(
                    icon: Icon(Icons.arrow_back),
                    onPressed: () {
                      notifyBloc.dispatch(CountNotifyEvent());
                      Navigator.pop(context);
                    });
              },
            ),
            centerTitle: true,
          ),
          body:
              RefreshIndicator(onRefresh: _refreshHome, child: bodyBuilding())),
    );
  }

  Future<Null> _refreshHome() async {
    setState(() {});
  }

  Widget bodyBuilding() {
    return BlocProvider<EventSession, StateSession, SessionBloc>(
        bloc: bloc,
        builder: (state) {
          name.selection.copyWith(extentOffset: name.text.length);
          return Form(
            key: _formKey,
            child: GestureDetector(
              onTap: () {
                FocusScope.of(context).requestFocus(new FocusNode());
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Stack(children: [
                  SingleChildScrollView(
                    child: Container(
                      height: height(context),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            Colors.white,
                            Colors.white54,
                            Color(0xFFF2F8FF)
                          ],
                        ),
                      ),
                      child: Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTile(AppLocalizations.of(context).name),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: name,
                                      autocorrect: false,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                      ),
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      decoration: InputDecoration(
                                          // hintText: 'What do people call you?',
                                          hintText:
                                              AppLocalizations.of(context).name,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hasFloatingPlaceholder: false),
                                      onChanged: (String value) {
                                        setState(() {
                                          name.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: name.text.length +
                                                          1));
                                        });
                                        if (value != '' || value != null) {
                                          name.text = value;
                                        } else {
                                          showToastMessage(
                                              AppLocalizations.of(context)
                                                  .fillAll);
                                        }
                                      },
                                      validator: (String value) {
                                        return (value != null &&
                                                value.contains('@'))
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    )),
                              ),
                              // textField(),
                              SizedBox(
                                height: 10,
                              ),
                              buildTile(
                                  AppLocalizations.of(context).phoneNumber),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: phoneNumber,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                      ),
                                      autocorrect: false,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                          // hintText: 'What do people call you?',
                                          hintText: AppLocalizations.of(context)
                                              .phoneNumber,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hasFloatingPlaceholder: false),
                                      onSaved: (String value) {},
                                      onChanged: (String value) {
                                        setState(() {
                                          phoneNumber.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset: phoneNumber
                                                              .text.length +
                                                          1));
                                        });
                                        phoneNumber.text = value;
                                      },
                                      validator: (String value) {
                                        return (value != null &&
                                                value.contains('@'))
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    )),
                              ),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildTile(AppLocalizations.of(context).address),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 0, 10),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            spreadRadius: 1),
                                      ],
                                    ),
                                    child: TextFormField(
                                      controller: address,
                                      style: TextStyle(
                                        fontFamily: 'Montserrat-M',
                                      ),
                                      decoration: InputDecoration(
                                          // hintText: 'What do people call you?',
                                          hintText: AppLocalizations.of(context)
                                              .specificAddress,
                                          focusedBorder: InputBorder.none,
                                          enabledBorder: InputBorder.none,
                                          hasFloatingPlaceholder: false),
                                      onSaved: (String value) {},
                                      onChanged: (String value) {
                                        setState(() {
                                          address.selection =
                                              TextSelection.fromPosition(
                                                  TextPosition(
                                                      offset:
                                                          address.text.length +
                                                              1));
                                        });
                                        if (value != '') {
                                          address.text = value;
                                        } else {
                                          showToastMessage(
                                              'Vui lòng điền đầy đủ thông tin');
                                        }
                                      },
                                      validator: (String value) {
                                        return (value != null &&
                                                value.contains('@'))
                                            ? 'Do not use the @ char.'
                                            : null;
                                      },
                                    )),
                              ),
                              // textField(),
                              SizedBox(
                                height: 10,
                              ),
                              dropDownProvince(),
                              SizedBox(
                                height: 20,
                              ),
                              dropDownDistrict(),
                              SizedBox(
                                height: 20,
                              ),
                              dropDownWards()
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      color: Color(0xFFF2F8FF),
                      padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                      child: GestureDetector(
                        onTap: () async {
                          await submit();
                        },
                        child: Container(
                          height: height(context) * 0.08,
                          width: width(context),
                          decoration: BoxDecoration(
                            color: Color(0xFF616C9A),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(color: Colors.black12, blurRadius: 10),
                            ],
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              AppLocalizations.of(context).done,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontFamily: 'Montserrat-M',
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }

  dropDownProvince() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 10, 0, 0),
              child: TypeAheadFormField<ProvinceModel>(
                textFieldConfiguration: TextFieldConfiguration(
                  controller: provinceController,
                  autofocus: false,
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          provinceController.clear();
                        });
                      },
                      color: Colors.black,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
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
                  cityId = suggestion.id;
                  userUpdate.province = suggestion.id;
                  updateBloc
                      .dispatch(LoadDistrictEvent(provinceId: suggestion.id));
                  provinceController.text = suggestion.name;
                },
                getImmediateSuggestions: true,
              ),
            ),
          ),
        );
      },
    );
  }

  dropDownDistrict() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 10, 0, 0),
              child: TypeAheadFormField<DistrictModel>(
                // initialValue: bloc.state.user.districtId ?? "",
                textFieldConfiguration: TextFieldConfiguration(
                  controller: districsController,
                  autofocus: false,
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          districsController.clear();
                        });
                      },
                      color: Colors.black,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                    hintText: AppLocalizations.of(context).district,
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
                  provinceId = suggestion.id;
                  updateBloc
                      .dispatch(LoadWardsEvent(districtId: suggestion.id));
                  districsController.text = suggestion.name;
                },
                getImmediateSuggestions: true,
              ),
            ),
          ),
        );
      },
    );
  }

  dropDownWards() {
    return BlocProvider<UpdateEvent, UpdateState, UpdateBloc>(
      bloc: updateBloc,
      builder: (state) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: [
                BoxShadow(color: Colors.black12, spreadRadius: 1),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(13.0, 10, 0, 0),
              child: TypeAheadFormField<WardModel>(
                // initialValue: bloc.state.user.wardId ?? "",
                textFieldConfiguration: TextFieldConfiguration(
                  controller: wardController,
                  autofocus: false,
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          wardController.clear();
                        });
                      },
                      color: Colors.black,
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        size: 30,
                      ),
                    ),
                    hintText: AppLocalizations.of(context).ward,
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
                  wardId = suggestion.id;
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => ProductPage(product: suggestion)));
                  userUpdate.ward = suggestion.id;
                  wardController.text = suggestion.name;
                },
                getImmediateSuggestions: true,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildTile(String title) {
    return Text(
      '$title',
      overflow: TextOverflow.fade,
      maxLines: 2,
      style: TextStyle(
          fontFamily: 'Montserrat-M',
          fontSize: 16,
          color: AppColor.darkPurple,
          fontWeight: FontWeight.bold),
      textAlign: TextAlign.left,
    );
  }
}
