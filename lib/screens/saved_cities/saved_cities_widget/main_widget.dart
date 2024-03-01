import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weather_sphere/controller/local_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:weather_sphere/controller/sync_data_controller/sync_database_bloc.dart';
import 'package:weather_sphere/routes/weather_routes.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/app_fonts.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/app_utils.dart';
import 'package:weather_sphere/utils/common_widgets/saved_cities_card.dart';
import 'package:weather_sphere/utils/font_sizes.dart';

import '../../../domain/entity/weather_entity.dart';


class MainUIWidget extends StatelessWidget {
  final List<WeatherModel> cityNamesData;
  final bool isSyncing;
  final TextEditingController saveNewCityTextController;
  final bool isCurrentCityNotFound;

  const MainUIWidget({super.key,
    required this.cityNamesData,
    required this.isSyncing,
    required this.saveNewCityTextController,
    required this.isCurrentCityNotFound,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 20,
          child: AppBar(
            automaticallyImplyLeading: true,
            foregroundColor: AppColors.white,
            backgroundColor: Colors.transparent,
            title: Text(
              AppString.savedLocations,
              style:
                  AppFonts.medium(fontWeight: FontWeight.w400).copyWith(
                fontSize: AppFontSize.s18,
                color: AppColors.white,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  Icons.sync,
                  color: AppColors.white,
                  size: 30,
                ),
                onPressed: () {
                  if (cityNamesData.isNotEmpty) {
                    print("Sync Started");
                    final syncBloc = BlocProvider.of<SyncDatabaseBloc>(context);
                    syncBloc.add(SyncMyData(cityNamesData));
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding:
              EdgeInsets.only(top: 80.h, left: 2.w, right: 0.w, bottom: 73.h),
          child: Center(
            child:
                BlocConsumer<UserCityControllerBloc, UserCityControllerState>(
              builder: (context, state) {
                if (state is UserCityLoading) {
                  return Center(child: AppUtils().loadingSpinner);
                }
                if (state is UserCityLoaded) {
                  if (isSyncing) {
                    final currentCityWeatherModel = state.usermodel.firstWhere(
                      (element) => element.isCurrentCity == true,
                      orElse: () => state.usermodel.first,
                    );

                    AppUtils.updateHomeScreenWidget(currentCityWeatherModel);
                  }
                  return ListView.builder(
                    itemCount: state.usermodel.length,
                    itemBuilder: (context, index) {
                      cityNamesData.add(state.usermodel[index]);
                      return Padding(
                        padding:
                            EdgeInsets.only(left: 12.w, right: 12.w, top: 15.h),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacementNamed(
                              context,
                              WeatherRoutes.homePageRoute,
                              arguments: [true, state.usermodel[index]],
                            );
                          },
                          child: SavedCitiesCard(
                            cityName: state.usermodel[index].name,
                            weatherCondition:
                                state.usermodel[index].weather[0].description,
                            humidity:
                                state.usermodel[index].main.humidity.toString(),
                            windSpeed:
                                state.usermodel[index].wind.speed.toString(),
                            statusImage: state.usermodel[index].weather[0].icon,
                            temprature:
                                state.usermodel[index].main.temp.toString(),
                            isHomeCity:
                                state.usermodel[index].isCurrentCity ?? false,
                          ),
                        ),
                      );
                    },
                  );
                }

                return Text(state.toString());
              },
              listener: (context, listenerState) {
                if (listenerState is UserCitySaveSuccess) {
                  final userCityBloc =
                      BlocProvider.of<UserCityControllerBloc>(context);
                  userCityBloc.add(const FetchSavedCitiesData());
                }


                if (listenerState is UserCityFetchingError) {
                  saveNewCityTextController.clear();
                  AppUtils.showToastMessage(
                    AppString.noWeatherInfo,
                    Toast.LENGTH_SHORT,
                  );
                  final userCityBloc =
                      BlocProvider.of<UserCityControllerBloc>(context);
                  userCityBloc.add(const FetchSavedCitiesData());
                }
              },
            ),
          ),
        ),
        Positioned(
          bottom: 10.h,
          left: 10.w,
          right: 10.w,
          child: InkWell(
            onTap: () {
              _showSaveDialog(context);
            },
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: AppColors.cardB,
                borderRadius: const BorderRadius.all(Radius.circular(24)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 25,
                    color: AppColors.white,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    AppString.addNew,
                    style: AppFonts.medium(
                      fontWeight: FontWeight.w500,
                    ).copyWith(
                      color: AppColors.white,
                      fontSize: AppFontSize.s24,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void getCityWeather(String result, BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(GetCityWeather(result,context,isCurrentCityNotFound));
  }



  void _showSaveDialog(BuildContext context) async {
    final currentContext = context; // Store the current context

    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text(AppString.saveCity),
          content: TextField(
            controller: saveNewCityTextController,
            decoration: InputDecoration(
              hintText: AppString.enterCity,
            ),
          ),
          actions: [
            TextButton(
              child: Text(AppString.cancel),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Use dialogContext here
              },
            ),
            TextButton(
              child: Text(AppString.save),
              onPressed: () {
                String text = saveNewCityTextController.text;
                Navigator.of(dialogContext).pop(text); // Use dialogContext here
              },
            ),
          ],
        );
      },
    );

    if (result != null) {
      getCityWeather(result, currentContext); // Use the stored context
    }
  }
}
