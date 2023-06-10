import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/detail_hopital_item_screen.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/hospital_item/hospital_item.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/src/Widgets/medical_item.dart';
import 'package:suns_med/src/equipment/detailequipment_screen.dart';

class SearchListCompanyScreen extends StatefulWidget {
  // final String value;
  final String type;
  final String provinceId;
  SearchListCompanyScreen({this.provinceId, this.type});

  @override
  _SearchListCompanyScreenState createState() =>
      _SearchListCompanyScreenState();
}

class _SearchListCompanyScreenState extends State<SearchListCompanyScreen> {
  FocusNode _focusNode = new FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final bloc = LocationBloc();
  @override
  void initState() {
    // bloc.dispatch(EventSearch(keyword: this.widget.value));
    bloc.dispatch(EventResetKeyword());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 1,
        backgroundColor: AppColor.deepBlue,
        title: _buildCustomSearchBar(
          'Tìm kiếm',
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
                bloc.dispatch(EventSearchCompay(
                    companyType: this.widget.type,
                    keyword: _searchController.text));
              }
            },
          ),
        ],
      ),
      body: _getCompany(),
    );
  }

  _getCompany() {
    return BlocProvider<LocationEvent, LocationState, LocationBloc>(
      bloc: bloc,
      builder: (state) {
        return state.listSearch == null
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
                    child: Text('Lưu ý: Cần nhập 2 ký tự trở lên để tỉm kiếm.',
                        style: TextStyle(
                            fontFamily: 'Montserrat-M',
                            color: AppColor.deepBlue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                  ),
                  // Text("Lưu ý: Cần nhập 3 ký tự trở lên để tỉm kiếm."),
                  SizedBox(
                    height: 30,
                  ),
                  Image.asset("assets/images/searchImg.png"),
                ],
              )
            : state.listSearch.isEmpty
                ? Center(
                    child: Container(
                      child: Text('Chưa có dữ liệu về từ khoá này'),
                    ),
                  )
                : this.widget.type == 'equipment'
                    ? ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: state.listEquipment?.length ?? 0,
                        itemBuilder: (context, index) {
                          var medical = state.listEquipment[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 5, top: 10),
                            child: MedicalItem(
                              title: medical?.name,
                              image: medical?.image,
                              totalRates: medical?.rating,
                              price: medical?.price?.toDouble(),
                              onPress: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailEquipmentScreen(
                                      medicalModel: medical,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      )
                    : Container(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: state.listSearch?.length ?? 0,
                          itemBuilder: (BuildContext context, int index) {
                            var item = state.listSearch[index];
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 17, right: 16, bottom: 8),
                              child: HospitalItem(
                                name: item?.name,
                                image: item?.image,
                                specialist: item?.specialized,
                                address: item?.address,
                                favorite: item?.totalLike,
                                totalRate: item?.rating?.toDouble(),
                                companyId: item?.id,
                                companyType: item?.type == 1
                                    ? CompanyType.Doctor
                                    : item?.type == 2
                                        ? CompanyType.Clinic
                                        : CompanyType.Hospital,
                                press: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        DetailHospitalItemScreen(
                                      id: item?.id,
                                      city: this.widget.provinceId,
                                      type: item?.type == 1
                                          ? CompanyType.Doctor
                                          : item?.type == 2
                                              ? CompanyType.Clinic
                                              : CompanyType.Hospital,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
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
      padding: const EdgeInsets.only(left: 20),
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
      ),
      child: RawKeyboardListener(
        focusNode: _focusNode,
        onKey: (event) {
          if (event.runtimeType == RawKeyDownEvent &&
              (event.logicalKey.keyId == 54)) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(EventSearchCompay(
                  companyType: this.widget.type,
                  keyword: _searchController.text));
            }
          }
        },
        child: TextFormField(
          controller: controller,
          onChanged: onChange,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            if (_searchController.text.length >= 2) {
              bloc.dispatch(EventSearchCompay(
                  companyType: this.widget.type,
                  keyword: _searchController.text));
            }
          },
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ),
    );
  }
}
