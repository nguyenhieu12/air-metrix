class AirPollutionThresholds {
  static int getSO2Threshold(double concentration) {
    if(concentration > 0 && concentration < 20) {
      return 1;
    } else if(concentration >= 20 && concentration < 80) {
      return 2;
    } else if(concentration >= 80 && concentration < 250) {
      return 3;
    } else if(concentration >= 250 && concentration < 350) {
      return 4;
    } else {
      return 5;
    }
  }

  static int getNO2Threshold(double concentration) {
    if(concentration > 0 && concentration < 40) {
      return 1;
    } else if(concentration >= 40 && concentration < 70) {
      return 2;
    } else if(concentration >= 70 && concentration < 150) {
      return 3;
    } else if(concentration >= 150 && concentration < 200) {
      return 4;
    } else {
      return 5;
    }
  }

  static int getPM10Threshold(double concentration) {
    if(concentration > 0 && concentration < 20) {
      return 1;
    } else if(concentration >= 20 && concentration < 50) {
      return 2;
    } else if(concentration >= 50 && concentration < 100) {
      return 3;
    } else if(concentration >= 100 && concentration < 200) {
      return 4;
    } else {
      return 5;
    }
  }

  static int getPM25Threshold(double concentration) {
    if(concentration > 0 && concentration < 10) {
      return 1;
    } else if(concentration >= 10 && concentration < 25) {
      return 2;
    } else if(concentration >= 25 && concentration < 50) {
      return 3;
    } else if(concentration >= 50 && concentration < 75) {
      return 4;
    } else {
      return 5;
    }
  }

  static int getO3Threshold(double concentration) {
    if(concentration > 0 && concentration < 60) {
      return 1;
    } else if(concentration >= 60 && concentration < 100) {
      return 2;
    } else if(concentration >= 100 && concentration < 140) {
      return 3;
    } else if(concentration >= 140 && concentration < 180) {
      return 4;
    } else {
      return 5;
    }
  }

  static int getCOThreshold(double concentration) {
    if(concentration > 0 && concentration < 4400) {
      return 1;
    } else if(concentration >= 4400 && concentration < 9400) {
      return 2;
    } else if(concentration >= 9400 && concentration < 12400) {
      return 3;
    } else if(concentration >= 12400 && concentration < 15400) {
      return 4;
    } else {
      return 5;
    }
  }

    
}