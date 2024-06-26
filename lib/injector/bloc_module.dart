import 'package:dio/dio.dart';
import 'package:envi_metrix/core/connection/internet_cubit.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/air_pollution_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/data/data_sources/weather_remote_data_source.dart';
import 'package:envi_metrix/features/air_pollution/data/repositories/air_pollution_repository_impl.dart';
import 'package:envi_metrix/features/air_pollution/data/repositories/weather_repository_impl.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_air_pollution.dart';
import 'package:envi_metrix/features/air_pollution/domain/use_cases/get_current_weather.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_compare_cubit.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/features/chatbot/cubits/chatbot_cubit.dart';
import 'package:envi_metrix/features/dashboard/presentation/cubits/dashboard_cubit.dart';
import 'package:envi_metrix/features/disaster/data/data_sources/disaster_remote_datasource.dart';
import 'package:envi_metrix/features/disaster/data/repositories/disaster_repository_impl.dart';
import 'package:envi_metrix/features/disaster/domain/use_cases/get_current_disaster.dart';
import 'package:envi_metrix/features/disaster/presentation/cubits/disaster_cubit.dart';
import 'package:envi_metrix/features/news/data/data_sources/news_remote_data_source.dart';
import 'package:envi_metrix/features/news/data/repositories/news_repository_impl.dart';
import 'package:envi_metrix/features/news/domain/use_cases/get_news.dart';
import 'package:envi_metrix/features/news/presentation/cubits/news_cubit.dart';
import 'package:envi_metrix/features/watchlist/cubits/watchlist_cubit.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location_search_bar/location_search_bar_cubit.dart';

class BlocModule {
  BlocModule._();

  static void init() {
    final injector = Injector.instance;

    injector
      ..registerSingleton<AppCubit>(AppCubit())
      ..registerSingleton<WatchlistCubit>(WatchlistCubit())
      ..registerSingleton<AirPollutionCubit>(AirPollutionCubit(
          getCurrentWeather: GetCurrentWeather(
              weatherRepository: WeatherRepositoryImpl(
                  remoteDataSource: WeatherRemoteDataSourceImpl(Dio()))),
          getCurrentAirPollution: GetAirPollutionInformation(
              airPollutionRepository: AirPollutionRepositoryImpl(
                  remoteDataSource: AirPollutionRemoteDataSourceImpl(Dio())))))
      ..registerSingleton<AirCompareCubit>(AirCompareCubit(
          getCurrentAirPollution: GetAirPollutionInformation(
              airPollutionRepository: AirPollutionRepositoryImpl(
                  remoteDataSource: AirPollutionRemoteDataSourceImpl(Dio())))))
      ..registerSingleton<DisasterCubit>(DisasterCubit(
          getCurrentDisaster: GetCurrentDisaster(
              disasterRepository: DisasterRepositoryImpl(
                  disasterRemoteDatasource:
                      DisasterRemoteDatasourceImpl(dio: Dio())))))
      ..registerSingleton<DashboardCubit>(DashboardCubit())
      ..registerSingleton<ChatbotCubit>(ChatbotCubit())
      ..registerSingleton<InternetCubit>(InternetCubit())
      ..registerSingleton<LocationSearchBarCubit>(LocationSearchBarCubit())
      ..registerLazySingleton<NewsCubit>(() => NewsCubit(
          getNews: GetNews(
              newsRepository: NewsRepositoryImpl(
                  newsRemoteDataSource: NewsRemoteDataSourceImpl(Dio())))));
  }
}
