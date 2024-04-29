import 'package:envi_metrix/bootstrap.dart';
import 'package:envi_metrix/core/keys/app_keys.dart';
import 'package:envi_metrix/features/air_pollution/presentation/cubits/air_pollution_cubit.dart';
import 'package:envi_metrix/features/app/cubits/app_cubit.dart';
import 'package:envi_metrix/features/app/pages/landing_page.dart';
import 'package:envi_metrix/injector/injector.dart';
import 'package:envi_metrix/services/location/default_location.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

void main() {
  late AirPollutionCubit airPollutionCubit;

  setUpAll(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Injector.init();

    await Injector.instance.allReady();

    Gemini.init(apiKey: AppKeys.geminiApiKey);

    await Injector.instance<AppCubit>().initCityData();

    airPollutionCubit = Injector.instance();
  });

  testWidgets('Test global search feature', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Air quality'), findsNothing);

    await airPollutionCubit.fetchAirPollutionData(
        DefaultLocation.lat, DefaultLocation.long);

    expect(find.text('Air quality'), findsOneWidget);
  });
}
