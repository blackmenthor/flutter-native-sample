
import 'package:flutter/services.dart';

class NativeBridge {

  static const messageChannel = const MethodChannel('com.anggach.flutternativesample/channel');
  static const methodHello = "HELLO";
  static const methodChangeInternetConnectivity = "CHANGE_INTERNET";

  static const eventChannel =
        const EventChannel('com.anggach.flutternativesample/event_channel');

  static bool currentValue = false;
  static Stream<bool> eventStream;

  static Stream<bool> listenToNativeEventChannel() {
    if ( eventStream == null ) eventStream =
        eventChannel.receiveBroadcastStream().cast<bool>();
    return eventStream;
  }
  
  static void changeInternetConnectivity() {
    Map<String, dynamic> params = {};

    currentValue = !currentValue;
    params["connectivity"] = currentValue;

    messageChannel.invokeMethod(methodChangeInternetConnectivity, params);
  }

  static Future<String> sayHiToNative() async {
    String response = "";
    try {
      final String result = await messageChannel.invokeMethod(methodHello);
      response = result;
    } on PlatformException catch (e) {
      response = "Failed to Invoke: '${e.message}'.";
    }
    return response;
  }

}