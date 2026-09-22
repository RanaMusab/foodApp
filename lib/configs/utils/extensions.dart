import 'package:food_app/configs/resources/const/enums.dart';

extension StringExtensions on String {
  /// Capitalizes the first letter of the string
  String capitalizeFirst() {
    if (isEmpty) return this; // Return the string as is if empty
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeEachFirst() {
    if (isEmpty) return this; // Return the string as is if empty
    return split(' ') // Split the string into words
        .map((word) => word.isNotEmpty ? word.capitalizeFirst() : '') // Capitalize each word
        .join(' '); // Join the words back into a single string
  }

  /// Converts the string to lower camelCase
  String toLowerCamelCase() {
    if (isEmpty) return this; // Return the string as is if empty

    // Split by whitespace or `/` and remove empty parts
    List<String> words = split(RegExp(r'[\s/]+'))
        .where((word) => word.isNotEmpty)
        .toList();

    if (words.isEmpty) return this;

    // Process the words for lower camel case
    String firstWord = words.first.toLowerCase(); // Keep the first word lowercase
    String remainingWords = words
        .skip(1) // Skip the first word
        .map((word) => word.capitalizeFirst()) // Capitalize each subsequent word
        .join('');

    return firstWord + remainingWords;
  }
}

extension ODDThemeExtension on ODDTheme {
  String get label {
    switch (this) {
      case ODDTheme.noPoverty:
        return 'No Poverty';
      case ODDTheme.zeroHunger:
        return 'Zero Hunger';
      case ODDTheme.goodHealthAndWellbeing:
        return 'Good Health and Wellbeing';
      case ODDTheme.qualityEducation:
        return 'Quality Education';
      case ODDTheme.genderEquality:
        return 'Gender Equality';
      case ODDTheme.cleanWaterAndSanitation:
        return 'Clean Water and Sanitation';
      case ODDTheme.affordableAndCleanEnergy:
        return 'Affordable and Clean Energy';
      case ODDTheme.decentWorkAndEconomicGrowth:
        return 'Decent Work and Economic Growth';
    }
  }
}
