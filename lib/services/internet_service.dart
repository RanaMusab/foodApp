import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

//Singleton class
class InternetService {
  static final InternetService _internetService = InternetService._();
  final _networkConnectivity = Connectivity();

  InternetService._();

  factory InternetService() {
    return _internetService;
  }

  void startListening(Function(bool) onOnlineChange) async {
    _networkConnectivity.onConnectivityChanged.listen((result) {
      onOnlineChange(result.last != ConnectivityResult.none);
    });
  }

  Future<bool> isInternetConnected() async {
    List<ConnectivityResult> result = await _networkConnectivity.checkConnectivity();
    if (result.isNotEmpty) {
      return result[0] == ConnectivityResult.mobile || result[0] == ConnectivityResult.wifi || result[0] == ConnectivityResult.ethernet;
    }
    return false;
  }
}
