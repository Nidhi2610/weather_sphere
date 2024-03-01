import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/font_sizes.dart';

import '../app_fonts.dart';

class WeatherAppBar extends StatelessWidget {
  final String cityNames;
  final Function onTap;

  const WeatherAppBar({
    super.key,
    required this.cityNames, required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.transparentColor,
      leading: GestureDetector(
          onTap: () {
            onTap.call();
          },
          child: Icon(FontAwesomeIcons.list,
              color: AppColors.white)),
      title: Text(
        cityNames,
        style: AppFonts.medium(
            fontWeight: FontWeight.w400, color:AppColors.white)
            .copyWith(fontSize: AppFontSize.s18),
      ),
      elevation: 0,
    );
  }
}
