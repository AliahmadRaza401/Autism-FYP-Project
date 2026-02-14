import 'dart:developer' as dev;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

class NotificationService extends GetxService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  Future<NotificationService> init() async {
    // =============  Request permissions by phone ok Mohammad
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dev.log('User granted permission', name: 'NOTIFICATION_SERVICE');
    }

    //  ========= Handle background messages ===========
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    //  =========== Get token for not. mohammad
    String? token = await _fcm.getToken();
    dev.log("FCM Token: $token", name: 'NOTIFICATION_SERVICE');

    return this;
  }

  static Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    dev.log("Handling background message: ${message.messageId}", name: 'NOTIFICATION_SERVICE');
  }

  void subscribeToTopic(String topic) {
    _fcm.subscribeToTopic(topic);
  }

  void unsubscribeFromTopic(String topic) {
    _fcm.unsubscribeFromTopic(topic);
  }
}
