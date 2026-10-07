import 'package:flutter/material.dart';

class ConnectivityService extends ChangeNotifier {
  bool _isOffline = true; // Default to offline-first design for rural testing
  bool _isBackendConnected = false;

  bool get isOffline => _isOffline;
  bool get isBackendConnected => _isBackendConnected;

  void toggleConnectivity() {
    _isOffline = !_isOffline;
    notifyListeners();
  }

  void setBackendConnected(bool connected) {
    _isBackendConnected = connected;
    notifyListeners();
  }
}
