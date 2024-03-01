import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:weather_icons/weather_icons.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/app_fonts.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/app_utils.dart';
import 'package:weather_sphere/utils/font_sizes.dart';
import 'package:weather_sphere/utils/font_sizes.dart';

class SavedCitiesCard extends StatelessWidget {
  final String cityName;
  final String weatherCondition;
  final String humidity;
  final String windSpeed;
  final String statusImage;
  final String temprature;
  final bool isHomeCity;

  const SavedCitiesCard(
      {Key? key,
      required this.cityName,
      required this.weatherCondition,
      required this.humidity,
      required this.windSpeed,
      required this.statusImage,
      required this.temprature,
        required this.isHomeCity,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration:BoxDecoration(
          color: AppColors.cardB,
          borderRadius: const BorderRadius.all(Radius.circular(16))
        ),
        child: Column(
          children: [

            
            Row(
              children: [
                /// display city name weather condition and humidity and wind
                /// home icon

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          cityName,
                          style: AppFonts.large().copyWith(
                              color: AppColors.white,
                              fontSize: AppFontSize.s22,
                              fontWeight: FontWeight.w700),
                        ),
                        Text(
                          weatherCondition,
                          style: AppFonts.medium().copyWith(
                              color: AppColors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500,
                              fontSize: AppFontSize.s16),
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Row(
                          children: [
                            Text(
                              "${AppString.humidityText}: ",
                              style: AppFonts.medium().copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: AppFontSize.s16),
                            ),
                            Text(
                              humidity,
                              style: AppFonts.medium().copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppFontSize.s16),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text(
                              "${AppString.windText}:",
                              style: AppFonts.medium().copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w300,
                                  fontSize: AppFontSize.s16),
                            ),
                            Text(
                              windSpeed,
                              style: AppFonts.medium().copyWith(
                                  color: AppColors.white.withOpacity(0.8),
                                  fontWeight: FontWeight.w400,
                                  fontSize: AppFontSize.s16),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 8.0.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //// image
                      AppUtils().getWeatherIcon(statusImage) != WeatherIcons.refresh
                          ? Icon(
                              AppUtils().getWeatherIcon(statusImage),
                              size: 50.0,
                               color: AppColors.yellow,
                            )
                          : Image.network(
                              AppUtils().getWeatherIconURL(statusImage),color: AppColors.yellow,),

                      SizedBox(
                        height: 14.h,
                      ),
                      Row(
                        children: [
                          Text(
                            temprature,
                            style: AppFonts.medium().copyWith(
                                color: AppColors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w500,
                                fontSize: AppFontSize.s30),
                          ),
                          Text(
                            AppString.degreeCelsius,
                            style: AppFonts.medium().copyWith(
                                color: AppColors.white.withOpacity(0.8),
                                fontWeight: FontWeight.w400,
                                fontFeatures: [
                                  const FontFeature.enable('sups'),
                                ],
                                fontSize: AppFontSize.s16),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

              ],
            ),
          ],
        ));
  }
}
