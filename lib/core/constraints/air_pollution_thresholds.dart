import 'package:envi_metrix/utils/global_variables.dart';

class AirPollutionThresholds {
  static List<int> so2Threshold = [0, 20, 80, 250, 350];

  static List<int> no2Threshold = [0, 40, 70, 150, 200];

  static List<int> pm10Threshold = [0, 20, 50, 100, 200];

  static List<int> pm25Threshold = [0, 10, 25, 50, 75];

  static List<int> o3Threshold = [0, 60, 100, 140, 180];

  static List<int> coThreshold = [0, 4400, 9400, 12400, 15400];

  static int getSO2Threshold(double concentration) {
    if (concentration > 0 && concentration < 20) {
      return 1;
    } else if (concentration >= 20 && concentration < 80) {
      return 2;
    } else if (concentration >= 80 && concentration < 250) {
      return 3;
    } else if (concentration >= 250 && concentration < 350) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getSO2Message(double concentration) {
    if (concentration > 0 && concentration < 20) {
      return PollutionMessage.good;
    } else if (concentration >= 20 && concentration < 80) {
      return PollutionMessage.moderate;
    } else if (concentration >= 80 && concentration < 250) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 250 && concentration < 350) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }

  static int getNO2Threshold(double concentration) {
    if (concentration > 0 && concentration < 40) {
      return 1;
    } else if (concentration >= 40 && concentration < 70) {
      return 2;
    } else if (concentration >= 70 && concentration < 150) {
      return 3;
    } else if (concentration >= 150 && concentration < 200) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getNO2Message(double concentration) {
    if (concentration > 0 && concentration < 40) {
      return PollutionMessage.good;
    } else if (concentration >= 40 && concentration < 70) {
      return PollutionMessage.moderate;
    } else if (concentration >= 70 && concentration < 150) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 150 && concentration < 200) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }

  static int getPM10Threshold(double concentration) {
    if (concentration > 0 && concentration < 20) {
      return 1;
    } else if (concentration >= 20 && concentration < 50) {
      return 2;
    } else if (concentration >= 50 && concentration < 100) {
      return 3;
    } else if (concentration >= 100 && concentration < 200) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getPM10Message(double concentration) {
    if (concentration > 0 && concentration < 20) {
      return PollutionMessage.good;
    } else if (concentration >= 20 && concentration < 50) {
      return PollutionMessage.moderate;
    } else if (concentration >= 50 && concentration < 100) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 100 && concentration < 200) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }

  static int getPM25Threshold(double concentration) {
    if (concentration > 0 && concentration < 10) {
      return 1;
    } else if (concentration >= 10 && concentration < 25) {
      return 2;
    } else if (concentration >= 25 && concentration < 50) {
      return 3;
    } else if (concentration >= 50 && concentration < 75) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getPM25Message(double concentration) {
    if (concentration > 0 && concentration < 10) {
      return PollutionMessage.good;
    } else if (concentration >= 10 && concentration < 25) {
      return PollutionMessage.moderate;
    } else if (concentration >= 25 && concentration < 50) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 50 && concentration < 75) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }

  static int getO3Threshold(double concentration) {
    if (concentration > 0 && concentration < 60) {
      return 1;
    } else if (concentration >= 60 && concentration < 100) {
      return 2;
    } else if (concentration >= 100 && concentration < 140) {
      return 3;
    } else if (concentration >= 140 && concentration < 180) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getO3Message(double concentration) {
    if (concentration > 0 && concentration < 60) {
      return PollutionMessage.good;
    } else if (concentration >= 60 && concentration < 100) {
      return PollutionMessage.moderate;
    } else if (concentration >= 100 && concentration < 140) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 140 && concentration < 180) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }

  static int getCOThreshold(double concentration) {
    if (concentration > 0 && concentration < 4400) {
      return 1;
    } else if (concentration >= 4400 && concentration < 9400) {
      return 2;
    } else if (concentration >= 9400 && concentration < 12400) {
      return 3;
    } else if (concentration >= 12400 && concentration < 15400) {
      return 4;
    } else {
      return 5;
    }
  }

  static String getCOMessage(double concentration) {
    if (concentration > 0 && concentration < 4400) {
      return PollutionMessage.good;
    } else if (concentration >= 4400 && concentration < 9400) {
      return PollutionMessage.moderate;
    } else if (concentration >= 9400 && concentration < 12400) {
      return PollutionMessage.unhealthy;
    } else if (concentration >= 12400 && concentration < 15400) {
      return PollutionMessage.veryUnhealthy;
    } else {
      return PollutionMessage.hazardous;
    }
  }
}
