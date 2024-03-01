import 'package:envi_metrix/injector/bloc_module.dart';
import 'package:get_it/get_it.dart';

class Injector {
  Injector._();

  static GetIt instance = GetIt.instance;

  static void init() {
    BlocModule.init();
  }
}
