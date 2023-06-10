import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/session_detail_hospital_bloc.dart';
import 'package:suns_med/src/Widgets/hospital_item/hospital_item.dart';
import 'package:suns_med/src/Widgets/detail_hospital_item.dart/detail_hopital_item_screen.dart';
import 'package:suns_med/src/Widgets/location/location.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/src/Widgets/search_screen.dart/search_listcompany.dart';

class ListDoctorScreen extends StatefulWidget {
  @override
  _ListDoctorScreenState createState() => _ListDoctorScreenState();
}

class _ListDoctorScreenState extends State<ListDoctorScreen> {
  final locationBloc = LocationBloc();
  ProvinceModel _province;
  CompanyType companyType;
  @override
  void initState() {
    if (locationBloc.state.doctorNew == null)
      locationBloc.dispatch(SelectLocationOfDoctorEvent(
          province: this.locationBloc.state.provinceSelected));

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
                  if (_province != null) {
                    locationBloc.dispatch(SelectLocationOfDoctorEvent(
                        province: _province ?? 701, type: 1));
                  }
                  Navigator.pop(context);
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
          'Danh sách bác sĩ',
          style: TextStyle(
              fontFamily: 'Montserrat-M', fontSize: 18, color: Colors.white),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SearchListCompanyScreen(
                              type: "Doctor",
                            )));
              }),
        ],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.only(left: 21, top: 16, right: 21, bottom: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'Bác sĩ',
                  style: TextStyle(fontFamily: 'Montserrat-M', fontSize: 16),
                ),
                RaisedButton(
                  onPressed: () => _showAlert(context, 'message').then((t) {
                    setState(() {});
                  }),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 7,
                      ),
                      BlocProvider<LocationEvent, LocationState, LocationBloc>(
                        bloc: locationBloc,
                        builder: (state) {
                          var checkName = state.provinceSelected.name == null;
                          return Text(
                            checkName ? "Gần đây" : state.provinceSelected.name,
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
          _buildListDoctor(),
        ],
      ),
    );
  }

  _buildListDoctor() {
    return BlocProvider<LocationEvent, LocationState, LocationBloc>(
        bloc: locationBloc,
        builder: (state) {
          var checkState = state.doctorNew == null;
          return checkState
              ? Container()
              : Expanded(
                  child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.doctorNew?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      var data = state.doctorNew[index];
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 17, right: 16, bottom: 8),
                        child: HospitalItem(
                          press: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => DetailHospitalItemScreen(
                                  id: data?.id,
                                  city: this
                                      .locationBloc
                                      .state
                                      .provinceSelected
                                      .id,
                                  type: CompanyType.Doctor,
                                ),
                              ),
                            );
                          },
                          companyId: data?.id,
                          companyType: CompanyType.Doctor,
                          provinceId:
                              this.locationBloc.state.provinceSelected.id,
                          name: data?.name,
                          image: data?.image,
                          specialist: data?.specialized,
                          address: data?.address,
                          favorite: data?.totalLike,
                          totalRate: data?.rating?.toDouble(),
                        ),
                      );
                    },
                  ),
                );
        });
  }
}
