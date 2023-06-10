import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/user/dto/contact_model.dart';
import 'package:suns_med/src/Widgets/contact_item.dart';
import 'package:suns_med/src/account/medicalrecord/addprofile_screen.dart';
import 'package:suns_med/src/account/medicalrecord/search_medical_record_screen.dart';
import 'package:suns_med/src/account/medicalrecord/session_medicalrecord_bloc.dart';
import 'package:suns_med/src/account/medicalrecord/update-contact.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:suns_med/src/contacts/detailcontact_screen.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/order/createfile_screen.dart';

class MedicalRecordScreen extends StatefulWidget {
  // final ContactModel contactModel;
  // final String relationShipValue;

  // const MedicalRecordScreen(
  //     {Key key, this.contactModel, this.relationShipValue})
  //     : super(key: key);
  @override
  _MedicalRecordScreenState createState() => _MedicalRecordScreenState();
}

class _MedicalRecordScreenState extends State<MedicalRecordScreen>
    with TickerProviderStateMixin<MedicalRecordScreen> {
  final bloc = ContactBloc();
  SlidableController _slidableController;

  @override
  void initState() {
    bloc.dispatch(LoadContactEvent());
    bloc.dispatch(LoadRelationship());
    bloc.dispatch(LoadGenderEvent());
    // if (bloc.state.contact == null || bloc.state.contact.isEmpty) {
    //   bloc.dispatch(LoadContactEvent());
    //   bloc.dispatch(LoadRelationship());
    //   bloc.dispatch(LoadGenderEvent());
    // }
    super.initState();
  }
  // final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();
  // final bloc = MedicalRecordBloc();

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
  //   bloc.dispatch(LoadMedicalRecordEvent());
  //   bloc.dispatch(LoadRelationshipMedicalEvent());
  //   initScroll();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TopAppBar(),
      body: Scaffold(
        // key: scaffoldState,
        // appBar: AppBar(
        //   backgroundColor: AppColor.deepBlue,
        //   centerTitle: true,
        //   title: Text(
        //     'Danh sách người thân',
        //     style:TextStyle(
        //       fontFamily: 'Montserrat-M',fontSize: 18, color: Colors.white),
        //   ),
        //   actions: [
        //     IconButton(
        //       icon: Icon(
        //         Icons.search,
        //         color: Colors.white,
        //       ),
        //       onPressed: () {
        //         Navigator.push(
        //             context,
        //             MaterialPageRoute(
        //                 builder: (context) => SearchMedicalRecordScreen(
        //                       id: bloc.state.medicalRecord[0].id,
        //                     )));
        //       },
        //     ),
        //   ],
        // ),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(76),
          child: CustomAppBar(
            title: AppLocalizations.of(context).listRecords,
            titleSize: 18,
            isTopPadding: true,
            hasAcctionIcon: true,
            actionIcon: Icon(
              Icons.add_circle_rounded,
            ),
            onActionTap: () async {
              await Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreateFileScreen()));
              bloc.dispatch(LoadContactEvent());
            },
          ),
        ),
        body: RefreshIndicator(
          onRefresh: _refreshHome,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                color: AppColor.whitetwo,
                child: _getContact(),
              ),
              // StreamBuilder<bool>(
              //     stream: _visibleChange.stream,
              //     builder:
              //         (BuildContext context, AsyncSnapshot<bool> snapshot) {
              //       return SlideTransition(
              //         position: _offset,
              //         child: Container(
              //           padding: const EdgeInsets.only(
              //             left: 20,
              //             right: 20,
              //           ),
              //           margin: const EdgeInsets.only(bottom: 20),
              //           width: 312,
              //           height: 46,
              //           child: RaisedButton(
              //             color: AppColor.deepBlue,
              //             onPressed: () {
              //               Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (context) => AddProfileScreen(),
              //                 ),
              //               );
              //             },
              //             shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(26),
              //             ),
              //             child: Text(
              //               AppLocalizations.of(context).addProfile,
              //               style: TextStyle(
              //                   fontFamily: 'Montserrat-M',
              //                   fontSize: 16,
              //                   color: Colors.white),
              //             ),
              //           ),
              //         ),
              //       );
              //     }),
            ],
          ),
        ),
      ),
    );
  }

  Future<Null> _refreshHome() async {
    bloc.dispatch(LoadContactEvent());
    // bloc.dispatch(LoadRelationship());
    // bloc.dispatch(LoadGenderEvent());
  }

  _getContact() {
    return BlocProvider<ContactEvent, ContactState, ContactBloc>(
      bloc: bloc,
      builder: (output) {
        return output.contact == null || output.contact.isEmpty
            ? Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height * 0.3),
                child: Center(
                  child: Text(AppLocalizations.of(context).notData),
                ),
              )
            : Container(
                //margin: EdgeInsets.only(bottom: 10),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: output?.contact?.length ?? 0,
                  itemBuilder: (BuildContext context, index) {
                    var contact = output.contact[index];
                    var relationShipId = contact.relationShip ?? 0;
                    var item = output?.relationship?.firstWhere(
                        (element) => element?.key == relationShipId,
                        orElse: () => null);
                    var genderId = contact?.gender ?? 0;
                    var genderValue = output?.gender
                        ?.firstWhere((element) => element?.key == genderId);

                    return contact == output.contact[0]
                        ? ContactItem(
                            contactModel: contact,
                            relationShip: item?.value ?? '0',

                            // avatar:
                            //     contact?.avatar == null ? null : contact?.avatar,
                            press: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailContactScreen(
                                  relationShipValue: item?.value,
                                  contactModel: contact,
                                  genderValue: genderValue?.value,
                                ),
                              ),
                            ),
                          )
                        : Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            child: ContactItem(
                              contactModel: contact,
                              relationShip: item?.value ?? '0',
                              press: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailContactScreen(
                                    relationShipValue: item?.value,
                                    contactModel: contact,
                                    genderValue: genderValue?.value,
                                  ),
                                ),
                              ),
                            ),
                            // actions: <Widget>[
                            //   new IconSlideAction(
                            //     caption: 'Xoá',
                            //     color: Colors.red,
                            //     icon: Icons.delete,
                            //     onTap: () => _showAlert(context, ""),
                            //   ),
                            // ],
                            secondaryActions: [
                              new IconSlideAction(
                                caption: 'Xoá',
                                color: Colors.red,
                                icon: Icons.delete,
                                onTap: () => _showAlert(context, "", () {
                                  bloc.dispatch(
                                      DeleteContactEvent(userId: contact.id));
                                  Navigator.pop(context);
                                }),
                              ),
                            ],
                          );
                  },
                ),
              );
      },
    );
  }

  _showAlert(BuildContext context, String message, Function ontap) async {
    return showDialog(
      context: context,
      child: Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          padding: const EdgeInsets.only(top: 20),
          height: 100,
          // decoration: BoxDecoration(
          //   borderRadius: BorderRadius.circular(11),
          //   color: AppColor.white,
          // ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(
                child: Text(
                  "Bạn có muốn xoá không?",
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
              ),
              Center(
                child: MaterialButton(
                  onPressed: ontap,
                  child: Text("OK",
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: AppColor.deepBlue)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
