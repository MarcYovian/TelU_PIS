import 'package:flutter/material.dart';

class AppUtils {
  static MediaQueryData mediaQueryData(BuildContext context) {
    return MediaQuery.of(context);
  }

  static double width(BuildContext context) {
    return mediaQueryData(context).size.width;
  }

  static double height(BuildContext context) {
    return mediaQueryData(context).size.height;
  }
}
