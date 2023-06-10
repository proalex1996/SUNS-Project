import 'package:flutter/material.dart';
import 'package:suns_med/shared/bloc_provider.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';
import 'package:suns_med/src/Widgets/location/session_location_bloc.dart';
import 'package:suns_med/common/theme/theme_color.dart';

class LocationDropdown extends StatefulWidget {
  final String title;
  final Function onTap;
  final String id;
  final bool selectColor;

  LocationDropdown({
    this.title,
    this.onTap,
    this.id,
    this.selectColor = true,
  });

  @override
  _LocalDropdownState createState() => _LocalDropdownState();
}

class _LocalDropdownState extends State<LocationDropdown> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 25),
      child: InkWell(
        onTap: () {
          setState(() {
            widget.onTap();
          });
        },
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(child: Text(widget.title)),
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
                        color: widget.selectColor
                            ? AppColor.deepBlue
                            : Color(0xfff2f2fb),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              color: Colors.grey[300],
              height: 5,
              thickness: 1,
            ),
          ],
        ),
      ),
    );
  }
}

class LocationScreen extends StatefulWidget {
  final Function(ProvinceModel location) onSelectedLocation;
  LocationScreen({@required this.onSelectedLocation});
  @override
  _LocationState createState() => _LocationState();
}

class _LocationState extends State<LocationScreen> {
  String provinceIdSelected;

  final bloc = LocationBloc();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationEvent, LocationState, LocationBloc>(
      bloc: bloc,
      builder: (state) {
        return ListView.builder(
          itemCount: state.listProvince?.length ?? 0,
          itemBuilder: (BuildContext context, int index) {
            var province = state.listProvince[index];

            return LocationDropdown(
              title: province.name,
              id: province.id,
              selectColor: state.provinceSelected != null &&
                  province.id == state.provinceSelected.id,
              onTap: () {
                setState(() {
                  state.provinceSelected = province;
                  this.widget.onSelectedLocation(province);
                });
                // luu y k dung` lai cach nay
              },
            );
          },
        );
      },
    );
  }
}
