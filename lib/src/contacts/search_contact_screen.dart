import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/contact_item.dart';
import 'package:suns_med/src/contacts/detailcontact_screen.dart';
import 'package:suns_med/src/contacts/session_contacts_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SearchContactScreen extends StatefulWidget {
  const SearchContactScreen({Key key}) : super(key: key);

  @override
  _SearchContactScreenState createState() => _SearchContactScreenState();
}

class _SearchContactScreenState extends State<SearchContactScreen> {
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldState = GlobalKey<ScaffoldState>();

  final bloc = ContactBloc();
  @override
  Widget build(BuildContext context) {
    var language = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: AppColor.deepBlue,
        title: _buildCustomSearchBar(
          '${language.relativeName}...',
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
      body: _getContact(),
    );
  }

  _getContact() {
    return BlocProvider<ContactEvent, ContactState, ContactBloc>(
      bloc: bloc,
      builder: (output) {
        return output.searchContact == null
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
                    child: Text(AppLocalizations.of(context).relativeNote,
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
            : output.searchContact.isEmpty
                ? Center(
                    child: Container(
                      child: Text(AppLocalizations.of(context).notData),
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: output?.searchContact?.length ?? 0,
                    itemBuilder: (BuildContext context, index) {
                      var contact = output.searchContact[index];
                      var relationShipId = contact.relationShip ?? 0;
                      var item = output?.relationship?.firstWhere(
                          (element) => element?.key == relationShipId,
                          orElse: () => null);
                      var genderId = contact?.gender ?? 0;
                      var genderValue = output?.gender
                          ?.firstWhere((element) => element?.key == genderId);

                      return ContactItem(
                        contactModel: contact,
                        relationShip: item?.value ?? 0,
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
