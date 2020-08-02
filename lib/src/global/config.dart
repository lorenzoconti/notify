import 'package:flutter/widgets.dart';

class Config {
  static MediaQueryData _mediaQueryData;
  static double dw;
  static double dh;

  void init(BuildContext context){
    _mediaQueryData = MediaQuery.of(context);
    dw = _mediaQueryData.size.width;
    dh = _mediaQueryData.size.height;
  }
}