import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_sphere/routes/weather_routes.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/app_fonts.dart';
import 'package:weather_sphere/utils/app_resources.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/font_sizes.dart';
import 'package:weather_sphere/utils/weather_paddings.dart';

class NewSplash extends StatefulWidget {
  const NewSplash({super.key});

  @override
  State<NewSplash> createState() => _NewSplashState();
}

class _NewSplashState extends State<NewSplash> with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    _navigateToMainScreen();
  }

  Future<void> _navigateToMainScreen() async {
    await Future.delayed(const Duration(seconds: 7));

    if (mounted) {
      Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
          arguments: [false, null]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.violateColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Lottie.asset(WeatherAppResources.splashLottie),
          Center(
            child: Text(
              AppString.weatherCast,
              style: AppFonts.large(
                      fontWeight: FontWeight.w700,
                      color: AppColors.violateColor)
                  .copyWith(fontSize: AppFontSize.s30),
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: (){
                  Navigator.pushReplacementNamed(context, WeatherRoutes.homePageRoute,
                      arguments: [false, null]);
                },
                child: SizedBox(
                  width: 300.w,
                  child: Card(
                    elevation: 10,
                    color: AppColors.grey,
                    child: Padding(
                      padding: const EdgeInsets.all(WeatherAppPaddings.s8),
                      child: Center(
                        child: Text(
                          AppString.continueToPage,
                          style: AppFonts.large(
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.black)
                              .copyWith(fontSize: AppFontSize.s19),
                        ),
                      ),
                    ),
                  ),
                ),
              ))
        ],
      ),
    );
  }
}

/// dont spin add screen shots and video thats all
/// ping medium

