import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_sphere/controller/HomeController/home_controller_bloc.dart';
import 'package:weather_sphere/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:weather_sphere/routes/weather_routes.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/app_utils.dart';

class HomeUtils {
  static void goToSavedList(bool status, BuildContext context) {
    Navigator.pushNamed(context, WeatherRoutes.savedCitiesRoute,
        arguments: [status]);
  }

  static Future<void> showLocationServiceDialog(
      BuildContext context, bool mounted) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppString.locationDisabled),
          content: Text(AppString.pleaseEnableLocation),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                await Geolocator.openLocationSettings();
                if (mounted) {
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppString.openSettings),
            ),
          ],
        );
      },
    );
  }

  static List<String> getDailyForecast(BuildContext context) {
    List<String> upcomingDays = AppUtils.getNextFourDays();
    final forecastBloc = BlocProvider.of<GetDailyForecastBloc>(context);
    forecastBloc.add(GetDailyForCast());
    return upcomingDays;
  }

  static void permissionDialog(
      BuildContext context,
      GlobalKey<State<StatefulWidget>> permissionDialogKey,
      bool mounted,
      bool isGettingUserPosition,
      bool? showDataFromSavedCities) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          key: permissionDialogKey,
          title: Text(AppString.locationServicesDisabled),
          content: Text(AppString.locationEnable),
          actions: <Widget>[
            MaterialButton(
              onPressed: () {
                Navigator.of(context).pop();

                getPosition(context, mounted, permissionDialogKey,
                    isGettingUserPosition, showDataFromSavedCities);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(AppString.okay),
                  ),
                  GestureDetector(
                    onTap: () {
                      exit(0);
                    },
                    child: Text(AppString.cancel),
                  ),
                ],
              ),
            )
          ],
        );
      },
    );
  }

  static Future<void> getPosition(
      BuildContext context,
      bool mounted,
      GlobalKey<State<StatefulWidget>> permissionDialogKey,
      bool isGettingUserPosition,
      bool? showDataFromSavedCities) async {
    try {
      await getUserPosition(
          isGettingUserPosition, context, mounted, showDataFromSavedCities);
    } catch (e) {
      if (mounted) {
        permissionDialog(context, permissionDialogKey, mounted,
            isGettingUserPosition, showDataFromSavedCities);
      }
    }
  }

  static Future<void> getUserPosition(
      bool isGettingUserPosition,
      BuildContext context,
      bool isMounted,
      bool? showDataFromSavedCities) async {
    if (isGettingUserPosition) {
      return;
    }
    isGettingUserPosition = true;
    try {
      if (!await Geolocator.isLocationServiceEnabled()) return;

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) return;

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);
      List<Placemark> locationPlaceMark =
          await placemarkFromCoordinates(position.latitude, position.longitude);
      Placemark place = locationPlaceMark[0];

      if (isMounted) {
        if (showDataFromSavedCities == false) {
          final weatherCityBloc = BlocProvider.of<HomeControllerBloc>(context);
          weatherCityBloc.add(GetCurrentCityWeatherInfo(place.locality!));
        }
      }
    } finally {
      isGettingUserPosition = false;
    }
  }
}
