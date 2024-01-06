
class PollutantMessage {
  static String getPollutantMessage(int pollutionValue) {
    switch(pollutionValue) {
      case 1:
        return 'Good';
      case 2:
        return 'Moderate';
        case 3:
        return 'Unhealthy for some groups';
        case 4:
        return 'Unhealthy';
        case 5:
        return 'Hazardous';
        default:
        return 'Good';
    }
  }

}