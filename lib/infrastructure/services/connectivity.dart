 import 'package:connectivity_plus/connectivity_plus.dart';

class AppConnectivity {
  Future<bool> connectivity() async {
    final connect = await Connectivity().checkConnectivity();
    if (connect == ConnectivityResult.ethernet ||
        connect == ConnectivityResult.wifi ||
        connect == ConnectivityResult.mobile) {
      return true;
    } else {
      return false;
    }
  }
} 