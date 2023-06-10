import 'package:flutter/material.dart';
import 'package:suns_med/shared/service_proxy/service_proxy.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/common/theme/theme_color.dart';
import '../../shared/service_proxy/user_portal/common/dto/province_model.dart';

class LocalDropdown extends StatefulWidget {
  final void Function(ProvinceModel) callback;
  final ProvinceModel provinceModel;
  LocalDropdown({
    Key key,
    this.provinceModel,
    @required this.callback,
  }) : super(key: key);

  @override
  _LocalDropdownState createState() => _LocalDropdownState();
}

class _LocalDropdownState extends State<LocalDropdown> {
  bool selectColor = false;

  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  Future<List<ProvinceModel>> getAllCities() async {
    final service = ServiceProxy();

    return await service.commonService.getAllCities();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: FutureBuilder(
        future: getAllCities(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.data == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                ProvinceModel citiesModel = snapshot.data[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () {
                          this.widget.callback(snapshot.data[index]);

                          snapshot.data.forEach((element) {
                            element.selected = false;
                          });
                          setState(() {
                            selectColor = !selectColor;
                            snapshot.data[index].selected = true;
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Container(child: Text(citiesModel.name)),
                            Container(
                              width: 21,
                              height: 21,
                              child: Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                elevation: 3.0,
                                child: AnimatedContainer(
                                  duration: Duration(milliseconds: 150),
                                  decoration: BoxDecoration(
                                    color: selectColor
                                        ? AppColor.deepBlue
                                        : Color(0xfff2f2fb),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(12)),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.grey[300],
                        height: 5,
                        thickness: 1,
                      ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }
}
