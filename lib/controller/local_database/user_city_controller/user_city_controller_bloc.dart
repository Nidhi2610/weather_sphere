import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:weather_sphere/domain/entity/weather_entity.dart';
import 'package:weather_sphere/domain/usecases/weatherapp_usecases.dart';
import 'package:weather_sphere/utils/app_utils.dart';

part 'user_city_controller_event.dart';
part 'user_city_controller_state.dart';

class UserCityControllerBloc extends Bloc<UserCityControllerEvent, UserCityControllerState> {
  final WeatherAppUseCases getMedaUseCase;

  UserCityControllerBloc(this.getMedaUseCase) : super( UserCityControllerInitial()) {
    //

    on<UserCityInitial>((event, emit) async {
      emit(UserCityControllerInitial());


    });
    on<SaveUserCity>((event, emit) async {
      emit(UserCityLoading());
      final result=await getMedaUseCase.saveUserCity(event.weatherModel);
     result.fold((left) => emit(UserCitySavingError(left)),
             (right) => emit(UserCitySaveSuccess(right)));

    });
    on<FetchSavedCitiesData>((event, emit) async {
      emit(UserCityLoading());
      final result=await getMedaUseCase.loadSavedUserCities();
      result.fold((left) => emit(UserCityFetchingError(left)),
              (right) => emit(UserCityLoaded(right)));
    });
    on<GetCityWeather>((event,emit) async{
      emit(UserCityLoading());
      try {
        final weatherResult =
        await getMedaUseCase.getUserCityWeather(event.cityName);
        weatherResult.fold((leftWeatherError) {
          emit(UserCityFetchingError(leftWeatherError));
        }, (rightWeather) {
          WeatherModel newModel = rightWeather;
          newModel.cityImageURL = rightWeather.cityImageURL;
          newModel.isCurrentCity = false;
          AppUtils.saveUserCity(newModel, event.context);
          if(event.cityNotFound)
            {
              AppUtils.updateHomeScreenWidget(newModel);
            }
        });
      } catch (error) {
        emit(UserCityFetchingError(error.toString()));
      }
    });





  }
}
