import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter/services.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/contact_item.dart';
import 'package:suns_med/src/account/medicalrecord/session_medicalrecord_bloc.dart';
import 'package:suns_med/src/account/medicalrecord/update-contact.dart';

class SearchMedicalRecordScreen extends StatefulWidget {
  final int id;
  const SearchMedicalRecordScreen({Key key, this.id}) : super(key: key);

  @override
  _SearchMedicalRecordScreenState createState() =>
      _SearchMedicalRecordScreenState();
}

class _SearchMedicalRecordScreenState extends State<SearchMedicalRecordScreen>
    with TickerProviderStateMixin<SearchMedicalRecordScreen> {
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  final bloc = MedicalRecordBloc();

  // var _isVisible = true;

  // AnimationController animationController;
  // Animation<Offset> _offset;

  // StreamController<bool> _visibleChange = StreamController<bool>();

  // ScrollController _hideButtonController;

  // initScroll() {
  //   _isVisible = true;
  //   animationController =
  //       AnimationController(vsync: this, duration: kThemeAnimationDuration);
  //   _offset = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
  //       .animate(animationController);
  //   _hideButtonController = new ScrollController();
  //   _hideButtonController.addListener(() {
  //     if (_hideButtonController.position.userScrollDirection ==
  //         ScrollDirection.reverse) {
  //       if (_isVisible == true) {
  //         print("**** $_isVisible up");
  //         _isVisible = false;
  //         _visibleChange.add(_isVisible);
  //         animationController.forward();
  //       }
  //     } else {
  //       if (_hideButtonController.position.userScrollDirection ==
  //           ScrollDirection.forward) {
  //         if (_isVisible == false) {
  //           print("**** $_isVisible down");
  //           _isVisible = true;
  //           _visibleChange.add(_isVisible);
  //           animationController.reverse();
  //         }
  //       }
  //     }
  //   });
  // }

  // @override
  // void initState() {
  //   initScroll();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: AppColor.deepBlue,
        title: _buildCustomSearchBar(
          'Tên người thân...',
          controller: _searchController,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              if (_searchController.text.length >= 2) {
                bloc.dispatch(
                    EventSearchContact(keyWord: _searchController.text));
              }
            },
          ),
        ],
      ),
      body: _getMedicalRecord(),
    );
  }

  _getMedicalRecord() {
    return BlocProvider<MedicalRecordEvent, MedicalRecordState,
        MedicalRecordBloc>(
      bloc: bloc,
      builder: (state) {
        return state.contact == null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 12, left: 21),
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppColor.veryLightPinkFour,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black26,
                              offset: Offset(0, 3),
                              blurRadius: 6)
                        ]),
                    child: Text('Lưu ý: Cần nhập 2 ký tự trở lên để tìm kiếm.',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset("assets/images/searchImg.png"),
                ],
              )
            : state.contact.isEmpty
                ? Center(
                    child: Container(
                      child: Text('Chưa có dữ liệu về từ khoá này'),
                    ),
                  )
                : ListView.builder(
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: state.contact?.length ?? 0,
                    itemBuilder: (BuildContext context, index) {
                      var contact = state.contact[index];
                      var relationShipId = contact.relationShip ?? 0;
                      var item = state.relationship.firstWhere(
                          (element) => element.key == relationShipId,
                          orElse: () => null);

                      return ContactItem(
                        contactModel: contact,
                        relationShip: item?.value ?? 0,
                        press: state.contact[index].id == widget?.id
                            ? null
                            : () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => UpdateContactScreen(
                                      contact: contact,
                                    ),
                                  ),
                                ),
                      );
                    },
                  );
      },
    );
  }

  _buildCustomSearchBar(
    String hintText, {
    Function(String) onChange,
    TextEditingController controller,
  }) {
    return Container(
      margin: EdgeInsets.only(right: 25),
      // alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 20),
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent &&
              (event.logicalKey.keyId == 54)) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(
                  EventSearchContact(keyWord: _searchController.text));
            }
          }
        },
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          onChanged: onChange,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(
                  EventSearchContact(keyWord: _searchController.text));
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            suffixIcon: IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.grey,
                ),
                onPressed: () => controller.clear()),
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
