import 'package:food_app/configs/resources/const/app_environment.dart';

/// Every API endpoint in the app. Nothing else should build a URL.
class ApiConfig {
  static final String baseUrl = Environment.dev;

  // Authentication
  static final String login = "${baseUrl}auth/login";
  static final String register = "${baseUrl}auth/signup";
  static final String logout = "${baseUrl}auth/logout";
  static final String forgotPassword = "${baseUrl}auth/forgot-password";
  static final String resetPassword = "${baseUrl}auth/reset-password";
  static final String verifyOtp = "${baseUrl}auth/verify-otp";
  static final String resendOtp = "${baseUrl}auth/resend-otp";

  // Home
  static final String dishes = "${baseUrl}dishes";

  // Profile
  static final String getUser = "${baseUrl}user-details";
  static final String updateProfile = "${baseUrl}auth/update-profile";
}
