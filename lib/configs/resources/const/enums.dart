enum ActiveStatus{
  active, inactive;

  String get statusText {
    switch (this) {
      case ActiveStatus.active:
        return "Active";
      case ActiveStatus.inactive:
        return "Inactive";
    }
  }
}


enum UploadState {
  idle,
  uploading,
  analyzing,
  success,
  error,
}

enum EventType {
  online,
  onsite,
}


enum ODDTheme {
  noPoverty,
  zeroHunger,
  goodHealthAndWellbeing,
  qualityEducation,
  genderEquality,
  cleanWaterAndSanitation,
  affordableAndCleanEnergy,
  decentWorkAndEconomicGrowth,
}

enum OtpType { email, forgot }
enum ChallengeType { video, image, checkBox, videoWithQuiz }



