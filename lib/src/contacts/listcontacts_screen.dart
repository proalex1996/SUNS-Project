import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/Appbar/appbar.dart';
import 'package:suns_med/src/Widgets/contact_item.dart';
import 'package:suns_med/src/contacts/detailcontact_screen.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:suns_med/src/order/createfile_screen.dart';
import 'package:suns_med/src/account/medicalrecord//addprofile_screen.dart';

class ListContactsScreen extends StatefulWidget {
  @override
  _ListContactsScreenState createState() => _ListContactsScreenState();
}

class _ListContactsScreenState extends State<ListContactsScreen> {
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

  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
        backgroundColor: AppColor.lightBlue,
        appBar: const TopAppBar(),
        body: //SingleChildScrollView(
            Stack(
          children: [
            Container(
              height: 133,
              child: CustomAppBar(
                title: language.profile,
                titleSize: 18,
                isOrangeAppBar: true,
                hasAcctionIcon: true,
                hasBackButton: false,
                actionIcon: Icon(
                  Icons.add_circle_rounded,
                ),
                onActionTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateFileScreen()));
                  bloc.dispatch(LoadContactEvent());
                },
              ),
            ),
            RefreshIndicator(
              onRefresh: () => _refreshHome(),
              child: Scrollbar(
                child: Container(
                  //height: MediaQuery.of(context).size.height,
                  margin: EdgeInsets.fromLTRB(28, 80, 28, 46),
                  color: Colors.transparent,

                  //   onRefresh: _refreshHome,
                  child: _getContact(),
                ),
              ),
            )
          ],
        ));
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
