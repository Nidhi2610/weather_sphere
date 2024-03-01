
import 'package:get_it/get_it.dart';
import 'package:weather_sphere/controller/HomeController/home_controller_bloc.dart';
import 'package:weather_sphere/controller/get_daily_forecast_controller/get_daily_forecast_bloc.dart';
import 'package:weather_sphere/controller/get_user_city_controller/get_user_city_weather_controller_bloc.dart';
import 'package:weather_sphere/controller/local_database/get_current_city_weather/load_current_city_weather_bloc.dart';
import 'package:weather_sphere/controller/local_database/user_city_controller/user_city_controller_bloc.dart';
import 'package:weather_sphere/controller/save_current_city%20controller/save_current_city_bloc.dart';
import 'package:weather_sphere/controller/sync_data_controller/sync_database_bloc.dart';
import 'package:weather_sphere/data/data_source/remote_data_source.dart';
import 'package:weather_sphere/data/remote_repository/remote_repository.dart';
import 'package:weather_sphere/domain/base_data_source/base_remote_data_source.dart';
import 'package:weather_sphere/domain/base_repository/base_repository.dart';
import 'package:weather_sphere/domain/usecases/weatherapp_usecases.dart';
import 'package:weather_sphere/utils/database/app_database.dart';
import 'package:weather_sphere/utils/sharedPrefs/sharedprefsservice.dart';

GetIt appServiceLocator = GetIt.instance;

class ServicesLocator {
  Future<void> init() async {
    appServiceLocator.registerFactory(() => LoadCurrentCityWeatherBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => SyncDatabaseBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => SaveCurrentCityBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => HomeControllerBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => UserCityControllerBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => GetDailyForecastBloc(appServiceLocator()));
    appServiceLocator.registerFactory(() => GetUserCityWeatherControllerBloc(appServiceLocator()));
    appServiceLocator.registerLazySingleton(() =>WeatherAppUseCases(appServiceLocator()));
    appServiceLocator.registerLazySingleton<BaseRemoteRepository>(() => WeatherRepository(appServiceLocator()));
    appServiceLocator.registerLazySingleton<BaseRemoteDataSource>(() => RemoteDataSource());
    appServiceLocator.registerLazySingleton(() => AppDatabase.instance);
    var instance = await LocalStorageServices.getinstance();
    appServiceLocator.registerLazySingleton<LocalStorageServices>(() => instance);

  }
}