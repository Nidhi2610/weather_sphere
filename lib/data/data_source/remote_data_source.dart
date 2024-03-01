import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:either_dart/src/either.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:sembast/sembast.dart';
import 'package:weather_sphere/domain/base_data_source/base_remote_data_source.dart';
import 'package:weather_sphere/domain/entity/forcast_entity.dart';
import 'package:weather_sphere/domain/entity/weather_entity.dart';
import 'package:weather_sphere/utils/app_resources.dart';
import 'package:weather_sphere/utils/app_strings.dart';
import 'package:weather_sphere/utils/database/app_database.dart';
import 'package:weather_sphere/utils/services.dart';

class RemoteDataSource extends BaseRemoteDataSource {
  final AppDatabase _appDatabase;
  Dio dio = Dio();
  static const String CityName = 'cities';
  final cityNameStore = intMapStoreFactory.store(CityName);

  RemoteDataSource() : _appDatabase = GetIt.instance<AppDatabase>();

  Future<Database> get _db async => await _appDatabase.database;

  @override
  Future<Either<String, List<Daily>>> getDailyForecast() async {
    // TODO: implement getDailyForecast
    try {
      /// a 2-second delay to mock web response
      await Future.delayed(const Duration(seconds: 1));
      final String response =
          await rootBundle.loadString(WeatherAppResources.dailyForecastMock);
      final data = json.decode(response);

      if (data is Map<String, dynamic> &&
          data.containsKey(AppString.daily)) {
        final dailyData =
            List<Map<String, dynamic>>.from(data[AppString.daily]);
        List<Daily> dailyList =
            dailyData.map((json) => Daily.fromJson(json)).toList();
        return Right(dailyList);
      } else {
        return const Left(AppString.invalidJson);
      }
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherInfoForCurrentCity(
      String cityName) async {
    // TODO: implement getWeatherInfoForCurrentCity
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': AppServices.apiKey,
    };
    try {
      Response response = await Dio()
          .get(AppServices.baseURL, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        final cityImage = await getCityImage(cityName);
        data.cityImageURL = cityImage;
        return Right(data);
      } else {
        return Left(AppString.weatherAppError +
            (response.statusCode).toString());
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return Left(
              AppString.weatherAppError + AppString.notFound);
        } else {
          return Left(
              '${AppString.weatherAppError}${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return Left(AppString.weatherAppError +
            AppString.unExpectedError);
      }
    }
  }

  @override
  Future<Either<String, WeatherModel>> saveCurrentCityWeatherData(
      WeatherModel weatherModel) async {
    // TODO: implement saveCurrentCityWeatherData
    try {
      final cityNameNormalized = normalizeCityName(weatherModel.name);
      final existingRecords = await cityNameStore.find(
        await _db,
        finder: Finder(
          filter: Filter.custom((record) {
            final recordNameNormalized =
                normalizeCityName(record['name'] as String);
            return recordNameNormalized == cityNameNormalized;
          }),
        ),
      );

      if (existingRecords.isNotEmpty) {
        final existingWeatherModel =
            WeatherModel.fromJson(existingRecords.first.value);
        return Right(existingWeatherModel);
      }

      await cityNameStore.add(await _db, weatherModel.toJson());
      return Right(weatherModel);
    } catch (e) {
      return Left('${AppString.dataInsertionFailed}${e.toString()}');
    }
  }

  String normalizeCityName(String name) {
    return name.toLowerCase().trim();
  }

  /// unslplash city images
  Future<String> getCityImage(String cityName) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        '${AppServices.unSplashBaseURL}?query=$cityName&client_id=${AppServices.unSplashApiKey}',
      );

      if (response.statusCode == 200) {
        var responseData = response.data;
        if (responseData['results'] != null &&
            responseData['results'].isNotEmpty) {
          var firstImage = responseData['results'][0];
          String imageUrl = firstImage['urls']['regular'];
          return imageUrl;
        } else {
          return "";
        }
      } else if (response.statusCode == 404) {
        return "";
      } else {
        return "";
      }
    } catch (e) {
      if (e is DioException && e.response?.statusCode == 404) {
        return "";
      } else {
        return "";
      }
    }
  }

  @override
  Future<Either<String, List<WeatherModel>>> saveUserCityData(
      WeatherModel weatherModel) async {
    // TODO: implement saveUserCityData

    try {
      final cityNameNormalized = normalizeCityName(weatherModel.name);
      final existingRecords = await cityNameStore.find(
        await _db,
        finder: Finder(
          filter: Filter.custom((record) {
            final recordNameNormalized =
                normalizeCityName(record['name'] as String);
            return recordNameNormalized == cityNameNormalized;
          }),
        ),
      );

      if (existingRecords.isNotEmpty) {
        // Update now we will do updates
        final existingRecord = existingRecords.first;
        await cityNameStore.update(
          await _db,
          weatherModel.toJson(),
          finder: Finder(
            filter: Filter.byKey(existingRecord.key),
          ),
        );

        final allRecords = await cityNameStore.find(await _db);
        final weatherModels = allRecords.map((snapshot) {
          return WeatherModel.fromJson(snapshot.value);
        }).toList();

        return Right(weatherModels);
      }
      await cityNameStore.add(await _db, weatherModel.toJson());
      final allRecords = await cityNameStore.find(await _db);
      final weatherModels = allRecords.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('${AppString.dataInsertionFailed}${e.toString()}');
    }
  }

  @override
  Future<Either<String, WeatherModel>> getWeatherForUserCity(
      String cityName) async {
    // TODO: implement getWeatherForUserCity
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': AppServices.apiKey,
    };
    try {
      Response response = await Dio()
          .get(AppServices.baseURL, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        final cityImage = await getCityImage(cityName);
        data.cityImageURL = cityImage;
        return Right(data);
      } else {
        return Left(
            '${AppString.unExpectedStatusCode} ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return const Left(AppString.notFound);
        } else {
          return Left(
              '${AppString.weatherAppError} ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return const Left(AppString.unExpectedError);
      }
    }
  }

  @override
  Future<Either<String, List<WeatherModel>>> getUserCitiesWithWeather() async {
    return await populateWeatherDatabase();
  }

  Future<Either<String, List<WeatherModel>>> populateWeatherDatabase() async {
    try {
      final recordSnapshots = await cityNameStore.find(await _db);
      final weatherModels = recordSnapshots.map((snapshot) {
        return WeatherModel.fromJson(snapshot.value);
      }).toList();

      return Right(weatherModels);
    } catch (e) {
      return Left('${AppString.weatherAppError} ${e.toString()}');
    }
  }

  @override
  Future<Either<String, WeatherModel>> syncCitiesWeather(
      String cityName, bool isCurrentCity) async {
    // TODO: implement syncCitiesWeather
    Map<String, dynamic> queryParameters = {
      'q': cityName,
      'units': 'metric',
      'appid': AppServices.apiKey,
    };
    try {
      Response response = await Dio()
          .get(AppServices.baseURL, queryParameters: queryParameters);
      if (response.statusCode == 200) {
        final data = WeatherModel.fromJson(response.data);
        final cityImage = await getCityImage(cityName);
        data.cityImageURL = cityImage;
        updateCurrentCityWeatherData(data);
        return Right(data);
      } else {
        return Left(
            'Error: Server responded with status code ${response.statusCode}');
      }
    } catch (e, s) {
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          return const Left(AppString.notFound);
        } else {
          return Left(
              '${AppString.weatherAppError} ${e.response?.data['message'] ?? e.message}');
        }
      } else {
        return const Left(AppString.unExpectedError);
      }
    }
  }

  /// update data
  ///
  Future<Either<String, WeatherModel>> updateCurrentCityWeatherData(
      WeatherModel weatherModel) async {
    try {
      final cityNameNormalized = normalizeCityName(weatherModel.name);
      final existingRecords = await cityNameStore.find(
        await _db,
        finder: Finder(
          filter: Filter.custom((record) {
            final recordNameNormalized =
                normalizeCityName(record['name'] as String);
            return recordNameNormalized == cityNameNormalized;
          }),
        ),
      );

      if (existingRecords.isNotEmpty) {
        final existingWeatherModel =
            WeatherModel.fromJson(existingRecords.first.value);

        // Update the existing record with the new data
        await cityNameStore.update(
          await _db,
          weatherModel.toJson(),
          finder: Finder(
            filter: Filter.custom((record) {
              final recordNameNormalized =
                  normalizeCityName(record['name'] as String);
              return recordNameNormalized == cityNameNormalized;
            }),
          ),
        );

        return Right(existingWeatherModel); // Return the existing weather model
      }

      await cityNameStore.add(await _db, weatherModel.toJson());
      return Right(weatherModel);
    } catch (e) {
      return Left('${AppString.dataInsertionFailed} ${e.toString()}');
    }
  }

  /// get current city Data

  @override
  Future<Either<String, WeatherModel>> getCurrentCityWeather() async {
    try {
      final recordSnapshots = await cityNameStore.find(await _db);

      if (recordSnapshots.isEmpty) {
        return Left(AppString.noData);
      }

      final recordSnapshot = recordSnapshots.first;
      final weatherModel = WeatherModel.fromJson(recordSnapshot.value);
      weatherModel.isCurrentCity = true;

      return Right(weatherModel);
    } catch (e) {
      return Left('${AppString.weatherAppError} ${e.toString()}');
    }
  }
}
