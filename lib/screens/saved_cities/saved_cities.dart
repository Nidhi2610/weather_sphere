import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:weather_sphere/controller/connectivity/internate_connectivity_bloc.dart';
import 'package:weather_sphere/controller/local_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:weather_sphere/controller/sync_data_controller/sync_database_bloc.dart';
import 'package:weather_sphere/domain/entity/weather_entity.dart';
import 'package:weather_sphere/utils/app_colors.dart';
import 'package:weather_sphere/utils/app_resources.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/app_utils.dart';

import 'saved_cities_widget/main_widget.dart';

class CitiesList extends StatelessWidget {
  final bool isCurrentCityNotFound;

  const CitiesList({super.key, required this.isCurrentCityNotFound});

  @override
  Widget build(BuildContext context) {
    final userCityBloc = BlocProvider.of<UserCityControllerBloc>(context);
    userCityBloc.add(const FetchSavedCitiesData());
    return UserCities(isCurrentCityNotFound: isCurrentCityNotFound);
  }
}

class UserCities extends StatefulWidget {
  final bool isCurrentCityNotFound;

  const UserCities({super.key, required this.isCurrentCityNotFound});

  @override
  State<UserCities> createState() => _UserCitiesState();
}

class _UserCitiesState extends State<UserCities> {
  TextEditingController saveNewCityTextController = TextEditingController();
  List<WeatherModel> cityNamesData = [];
  bool isSyncing = false;

  @override
  void dispose() {
    saveNewCityTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InternateConnectivityBloc, InternateConnectivityState>(
      builder: (context, state) {
        if (state is ConnectedState) {
          return BlocListener<SyncDatabaseBloc, SyncDatabaseState>(
            listener: (context, state) {
              if (state is SyncSuccessfull) {
                isSyncing = true;
                int currentIndex = 0;

                for (int i = 0; i < state.newModel.length; i++) {
                  if (state.newModel[i].isCurrentCity == true) {
                    currentIndex = i;
                    AppUtils.updateHomeScreenWidget(state.newModel[currentIndex]);
                  }
                  else{
                    if (currentIndex == 0 && state.newModel.isNotEmpty) {
                      currentIndex = state.newModel.length - 1;
                      AppUtils.updateHomeScreenWidget(state.newModel[currentIndex]);

                    }
                  }

                  AppUtils.saveUserCity(state.newModel[i], context);
                }
                cityNamesData = [];
                AppUtils.showToastMessage(
                    AppString.syncDone, Toast.LENGTH_SHORT);
              }
            },
            child: WillPopScope(
              onWillPop: () async {
                cityNamesData = [];
                if (widget.isCurrentCityNotFound) {
                  return false;
                } else {
                  return true;
                }
              },
              child: Scaffold(
                resizeToAvoidBottomInset: true,
                key: const ValueKey("user_city_widget"),
                body: Container(
                  decoration: BoxDecoration(
                    gradient: AppColors.linearGradientBackground,
                  ),
                  child: MainUIWidget(
                    cityNamesData: cityNamesData,
                    isSyncing: isSyncing,
                    saveNewCityTextController: saveNewCityTextController,
                    isCurrentCityNotFound: widget.isCurrentCityNotFound,
                  ),
                ),
              ),
            ),
          );
        } else if (state is NotConnectedState) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset(WeatherAppResources.connectivityLottie),
            ],
          );
        }
        return Container();
      },
    );
  }
}
