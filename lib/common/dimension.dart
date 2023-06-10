import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:suns_med/common/theme/theme_color.dart';

double width(BuildContext context) {
  double width = MediaQuery.of(context).size.width;
  return width;
}

bool isTablet(BuildContext context) {
  var shortest = MediaQuery.of(context).size.shortestSide;
  if (shortest < 600) {
    return true;
  } else {
    return false;
  }
}

double height(BuildContext context) {
  double height = MediaQuery.of(context).size.height;
  return height;
}

class Dimension {
  static double height = 0.0;
  static double width = 0.0;
  static double statusBarHeight = 0.0;
  static double bottomPadding = 0.0;

  static double getWidth(double size) {
    return width * size;
  }

  static double getHeight(double size) {
    return height * size;
  }

  static double getSafeHeightVerticalArea() {
    return height - statusBarHeight - bottomPadding;
  }

  static void setup(MediaQueryData data) {
    height = data.size.height;
    width = data.size.width;
    statusBarHeight = data.padding.top;
    bottomPadding = data.padding.bottom;
  }
}

showToastMessage(String message) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.SNACKBAR,
    timeInSecForIosWeb: 3,
    backgroundColor: AppColor.deepBlue.withOpacity(0.9),
    textColor: Colors.white,
    fontSize: 15,
  );
}
