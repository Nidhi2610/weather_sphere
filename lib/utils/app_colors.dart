import 'package:flutter/material.dart';

class AppColors {
  static Color transparentColor = Colors.transparent;
  static Color whiteWOpacity = const Color(0xffFFFFFF).withOpacity(0.25);
  static Color white = const Color(0xffFFFFFF);
  static Color colorForCard = const Color(0xffECECEC);
  static Color violateColor= const Color(0xff452c63);
  static Color cardB=const Color(0xffDDA0DD).withOpacity(0.3);
  static LinearGradient linearGradientBackground = const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    stops: [0.1121, 0.3242, 0.5592, 0.6939, 0.8957],
    colors: [
      Color(0xff452c63),
      Color(0xffC160A7),
      Color(0xff452c63),
      Color(0xffC160A7),
      Color(0xff452c63),
    ],
    transform: GradientRotation(192.33),
  );
  static Color yellow = const Color(0xffFFFF22);
  static Color red= Colors.redAccent;
  static Color splashButtonColor =const Color(0xffBF360C);
  static Color grey = const Color(0xffE6E6FA);
  static Color black =const Color(0xff000000);

}
