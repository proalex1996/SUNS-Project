import 'package:flutter/material.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/src/Widgets/location/location.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/src/Widgets/medical_item.dart';
import 'package:suns_med/src/Widgets/search_screen.dart/search_listcompany.dart';
import 'package:suns_med/src/equipment/detailequipment_screen.dart';

class ListEquipmentScreen extends StatefulWidget {
  @override
  _ListEquipmentScreenState createState() => _ListEquipmentScreenState();
}

class _ListEquipmentScreenState extends State<ListEquipmentScreen> {
  // final bloc = MedicalBloc();
  final bloc = LocationBloc();
  ProvinceModel _province;

  @override
  void initState() {
    // bloc.dispatch(LoadMedicalEvent());
    bloc.dispatch(SelectLocationOfEquipmentEvent(
        province: this.bloc.state.provinceSelected));
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
                    bloc.dispatch(SelectLocationOfEquipmentEvent(
                        province: this.bloc.state.provinceSelected));
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
        backgroundColor: AppColor.paleGreyThree,
        appBar: AppBar(
          title: Text(
            'Vật tư y tế',
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
                                type: "equipment",
                              )));
                })
          ],
          centerTitle: true,
          backgroundColor: AppColor.deepBlue,
        ),
        body: BlocProvider<LocationEvent, LocationState, LocationBloc>(
          bloc: bloc,
          builder: (state) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  margin:
                      EdgeInsets.only(left: 15, right: 15, top: 11, bottom: 10),
                  padding: const EdgeInsets.only(
                      left: 12, right: 12, top: 17, bottom: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColor.lightBlueGrey,
                  ),
                  child: Container(
                    height: 37,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/ic_location3.png',
                                width: 19,
                                height: 23,
                              ),
                              SizedBox(width: 15),
                              Container(
                                width: 206,
                                child: Text(
                                  'Bạn đang xem danh sách dịch vụ tại : ${state.provinceSelected.name}',
                                  style: TextStyle(
                                      fontFamily: 'Montserrat-M',
                                      fontSize: 15,
                                      color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showAlert(context, 'message').then((t) {
                            setState(() {});
                          }),
                          child: Text(
                            'Thay đổi',
                            style: TextStyle(
                                fontFamily: 'Montserrat-M',
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                _getMedical(),
              ],
            );
          },
        ));
  }

  _getMedical() {
    return BlocProvider<LocationEvent, LocationState, LocationBloc>(
      bloc: bloc,
      builder: (output) {
        var checkState = output?.listEquipment?.length == null;
        return checkState
            ? Container()
            : Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: output.listEquipment?.length ?? 0,
                  itemBuilder: (context, index) {
                    var medical = output.listEquipment[index];
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 10, right: 10, bottom: 5),
                      child: MedicalItem(
                        title: medical?.name,
                        image: medical?.image,
                        totalRates: medical?.rating,
                        price: medical?.price?.toDouble(),
                        medicalModel: medical,
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
                ),
              );
      },
    );
  }
}
