import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_icons/weather_icons.dart';

import '../../domain/entity/forcast_entity.dart';
import '../app_colors.dart';
import '../app_fonts.dart';
import '../app_utils.dart';
import '../font_sizes.dart';

class NextWeekCard extends StatelessWidget {
  final String daysOfWeek;
  final Daily forecastModel;

  const NextWeekCard({Key? key, required this.daysOfWeek, required this.forecastModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          daysOfWeek,
          style: AppFonts.large().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400).copyWith(fontSize: AppFontSize.s14),
        ),
        SizedBox(
          height: 10.h,
        ),
        AppUtils().getWeatherIcon(
          forecastModel.weather[0].icon)!=WeatherIcons.refresh?
        Icon(
          AppUtils().getWeatherIcon(
              forecastModel.weather[0].icon),
          size: 35.0,
          color: AppColors.yellow,


        ):Image.network(AppUtils().getWeatherIconURL( forecastModel.weather[0].icon),color: AppColors.yellow,),
        SizedBox(
          height: 10.h,
        ),
      /// temp
        Text(
          forecastModel.temp.day.toString(),
          style: AppFonts.large().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400).copyWith(fontSize: AppFontSize.s16),
        ),
        SizedBox(
          height: 10.h,
        ),

        // wind speed
        Text(
          forecastModel.windSpeed.toString(),
          style: AppFonts.large().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400).copyWith(fontSize: AppFontSize.s10),
        ),

        Text(
          "km/h",
          style: AppFonts.large().copyWith(
              color: AppColors.white,
              fontWeight: FontWeight.w400).copyWith(fontSize: AppFontSize.s10),
        ),

      ],
    );

  }
}
