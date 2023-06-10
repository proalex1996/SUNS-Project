import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/detail_hopital_item_screen.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/hospital_item/hospital_item.dart';
import 'package:suns_med/src/Widgets/location/location.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/src/special/search_special.dart';

class ListSpecialScreen extends StatefulWidget {
  final int departmentId;
  final String department;
  final CompanyType type;
  final String id;
  final String city;
  ListSpecialScreen(
      {this.departmentId, this.department, this.type, this.id, this.city});
  @override
  _ListSpecialScreenState createState() => _ListSpecialScreenState();
}

class _ListSpecialScreenState extends State<ListSpecialScreen> {
  final locationBloc = LocationBloc();
  ProvinceModel _province;

  @override
  void initState() {
    locationBloc.dispatch(SelectLocationOfDoctorEvent(
        province: this.locationBloc.state.provinceSelected, type: 1));
    locationBloc.dispatch(
        EventLoadCompanyBydepartmentId(departmentId: this.widget.departmentId));
    super.initState();
  }

  Future _showAlert(BuildContext context, String message) async {
    await showDialog(
        context: context,
        child: Container(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          child: Stack(
            alignment: Alignment.topCenter,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 20),
                child: Dialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  child: _buildChild(context),
                ),
              ),
              Positioned(
                top: 10,
                width: 108,
                height: 68,
                child: Image.asset(
                  'assets/images/ic_location.png',
                ),
              ),
            ],
          ),
        ));
  }

  _buildChild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 30),
            child: Text(
              'Hãy chọn tỉnh thành để hiện dịch vụ phù hợp với bạn',
              style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
            ),
          ),
          Expanded(
            child: LocationScreen(
              onSelectedLocation: (location) {
                _province = location;
              },
            ),
          ),
          Container(
            width: 312,
            height: 46,
            child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context);
                  locationBloc.dispatch(SelectLocationOfDoctorEvent(
                      province: _province, type: 1));
                },
                color: AppColor.deepBlue,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                child: Text(
                  "Xác Nhận",
                  style: TextStyle(
                      fontFamily: 'Montserrat-M', color: Colors.white),
                )),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.deepBlue,
        centerTitle: true,
        title: Text(
          widget.department,
          style: TextStyle(
              fontFamily: 'Montserrat-M', color: Colors.white, fontSize: 18),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SearchSpecialScreen(
                            departmentId: this.widget.departmentId,
                          )));
            },
          )
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: [
                    Text(
                      'Bác sĩ khám',
                      style:
                          TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    Text(
                      widget.department,
                      style: TextStyle(
                          fontFamily: 'Montserrat-M',
                          fontSize: 16,
                          color: AppColor.deepBlue,
                          decoration: TextDecoration.underline),
                    ),
                  ],
                ),
                RaisedButton(
                  onPressed: () => _showAlert(context, 'message').then((t) {
                    setState(() {});
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Image.asset(
                        'assets/images/ic_location2.png',
                        width: 11,
                        height: 16,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      BlocProvider<LocationEvent, LocationState, LocationBloc>(
                        bloc: locationBloc,
                        builder: (state) {
                          return Text(
                            state.provinceSelected.name,
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 16,
                                color: Colors.white),
                          );
                        },
                      ),
                    ],
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(9),
                  ),
                  color: AppColor.darkSkyBlue,
                )
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          _loadDoctorPopular(),
        ],
      ),
    );
  }

  _loadDoctorPopular() {
    return BlocProvider<LocationEvent, LocationState, LocationBloc>(
        bloc: locationBloc,
        builder: (state) {
          return state?.listCompany?.length == 0
              ? Padding(
                  padding: const EdgeInsets.only(top: 300.0),
                  child: Center(
                    child: Text("Không có dữ liệu."),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state?.listCompany?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var itemCompany = state.listCompany[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 17, right: 16, bottom: 8),
                        child: HospitalItem(
                          name: itemCompany?.name,
                          image: itemCompany?.image,
                          specialist: itemCompany?.specialized,
                          address: itemCompany?.address,
                          favorite: itemCompany?.totalLike,
                          totalRate: itemCompany?.rating?.toDouble(),
                          companyId: itemCompany.id,
                          companyType: itemCompany?.type == 1
                              ? CompanyType.Doctor
                              : itemCompany?.type == 2
                                  ? CompanyType.Clinic
                                  : CompanyType.Hospital,
                          press: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailHospitalItemScreen(
                                type: itemCompany?.type == 1
                                    ? CompanyType.Doctor
                                    : itemCompany?.type == 2
                                        ? CompanyType.Clinic
                                        : CompanyType.Hospital,
                                id: itemCompany?.id,
                                // city: itemCompany?.city,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
        });
  }
}
