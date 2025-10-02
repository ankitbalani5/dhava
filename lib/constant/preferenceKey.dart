

class PreferenceKey {
  static const String isLogin = 'isLogin';
  static const String deviceId = 'deviceId';
}


class ProfileData {
  static const String basicPlan = "basic";
  static const String premiumPlan = "premium";



  static String firstName = "";
  static String email = "";
  //static String lastName = "";
  static String gender = "";
  static String dateOfBirth = "";
  static double height = 60;
  static double weight = 60;
  static String userBio = "";
  static String countryName = "Select Country";
  static int countryId = 0;
  static String stateName = "Select State";
  static int stateId = 0;
  static String cityName = "Select City";
  static int cityId = 0;
  static String address = "";
  static String userType = "";
  static String associateSchoolCollegeName = "";
  static String associateSchoolCollegeId = "";
  static List<int> expertiseSportsId = [];
  static String otherSports = "";
  //Trainer
  static int numberOfPlayers = 0;
  static String summary = "";
  static String certificationName = "";
  static bool isCertified = false;
  //Coaches
  static int numberOfCoaches = 0;
  static int noOfClients = 0;
  static int noOfYearsExperience = 0;

}