import 'package:flutter/material.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/app_resources.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/app_utils.dart';
import 'package:weather_sphere/utils/weather_paddings.dart';

class DefaultUIWidget extends StatelessWidget {
  final bool isLocationServiceInitialized;
  const DefaultUIWidget({super.key, required this.isLocationServiceInitialized});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              WeatherAppResources.background,
              fit: BoxFit.cover,
            ),
          ),
         Align(
            alignment: Alignment.center,
            child: AppUtils().loadingSpinner,
          ),
          isLocationServiceInitialized? Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(WeatherAppPaddings.s30),
              child: Text(
                AppString.loading,
                style: TextStyle(color: AppColors.red),
              ),
            ),
          ):Container(),
        ],
      ),
    );
  }
}