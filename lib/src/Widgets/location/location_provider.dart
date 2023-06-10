import 'package:flutter/material.dart';
import 'package:suns_med/shared/service_proxy/user_portal/common/dto/province_model.dart';

class LocationProvider extends InheritedWidget {
  final ProvinceModel location;
  final Function(ProvinceModel location) onSelectedLocation;

  LocationProvider({
    Key key,
    this.location,
    this.onSelectedLocation,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static LocationProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<LocationProvider>();
  }

  @override
  bool updateShouldNotify(LocationProvider old) {
    return location != old.location;
  }
}
