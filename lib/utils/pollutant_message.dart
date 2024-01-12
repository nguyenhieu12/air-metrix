import 'package:envi_metrix/utils/global_variables.dart';

class PollutantMessage {
  static String getPollutantMessage(int pollutionValue) {
    switch (pollutionValue) {
      case 1:
        return PollutionMessage.good;
      case 2:
        return PollutionMessage.moderate;
      case 3:
        return PollutionMessage.unhealthy;
      case 4:
        return PollutionMessage.veryUnhealthy;
      case 5:
        return PollutionMessage.hazardous;
      default:
        return PollutionMessage.good;
    }
  }
}
