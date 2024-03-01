
import 'package:either_dart/either.dart';
import 'package:weather_sphere/domain/entity/forcast_entity.dart';
import 'package:weather_sphere/domain/entity/weather_entity.dart';

abstract class BaseRemoteDataSource {
  /// get weather for current city
  Future<Either<String, WeatherModel>> getWeatherInfoForCurrentCity(String cityName);
  /// get 4 days weather forecast
  Future<Either<String,List<Daily>>> getDailyForecast();
  /// save current city to database
  Future<Either<String,WeatherModel>> saveCurrentCityWeatherData(WeatherModel weatherModel);
  /// get saved cities
  Future<Either<String,List<WeatherModel>>> saveUserCityData(WeatherModel weatherModel);
  Future<Either<String, WeatherModel>> getWeatherForUserCity(String cityName);
  Future<Either<String,List<WeatherModel>>> getUserCitiesWithWeather();
  /// sync all data
  Future<Either<String,WeatherModel>> syncCitiesWeather(String cityName, bool isCurrentCity);
  Future<Either<String,WeatherModel>> getCurrentCityWeather();


}