import 'dart:async';
import 'dart:developer' as dev;
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class NetworkCheckerService extends GetxService {
  final Connectivity _connectivity = Connectivity();
  final Rx<ConnectivityResult> connectionStatus = ConnectivityResult.none.obs;
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      _updateConnectionStatus(results);
    } catch (e) {
      dev.log('Connectivity check failed', name: 'NETWORK_DEBUG', error: e);
    }
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      connectionStatus.value = ConnectivityResult.none;
    } else {
      // In connectivity_plus 6.0.0+, it returns a list. 
      // We'll take the first non-none if available.
      connectionStatus.value = results.first;
    }
    
    dev.log('Network Status Changed: ${connectionStatus.value}', name: 'NETWORK_DEBUG');
    
    if (connectionStatus.value == ConnectivityResult.none) {
      Get.snackbar(
        'Offline',
        'No internet connection detected.',
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: false,
        duration: const Duration(seconds: 3),
      );
    }
  }

  bool get isConnected => connectionStatus.value != ConnectivityResult.none;

  @override
  void onClose() {
    _connectivitySubscription.cancel();
    super.onClose();
  }
}
