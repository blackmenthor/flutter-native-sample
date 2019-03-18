package com.anggach.flutternativesample

import android.content.Intent
import android.os.Bundle

import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

  private val CHANNEL = "com.anggach.flutternativesample/channel"
  private val METHOD_HELLO = "HELLO"
  private val METHOD_CHANGE_INTERNET_CONNECTIVITY = "CHANGE_INTERNET"
  private val METHOD_LONG_ASYNC = "LONG_ASYNC"

  private val EVENT_CHANNEL = "com.anggach.flutternativesample/event_channel"

  private var streamHandler: FlutterStreamHandler? = null

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    GeneratedPluginRegistrant.registerWith(this)

    setUpMethodChannel()
    setUpEventChannel()
  }

  // EVENT CHANNEL SECTION

  private fun setUpEventChannel() {
    val eventChannel = EventChannel(flutterView, EVENT_CHANNEL)
    this.streamHandler = this.streamHandler
            ?: FlutterStreamHandler()
    eventChannel.setStreamHandler(this.streamHandler)
  }

  // METHOD CHANNEL SECTION

  private fun setUpMethodChannel() {
    MethodChannel(flutterView, CHANNEL).setMethodCallHandler {
      methodCall, result ->
        when(methodCall.method) {
          METHOD_HELLO -> hello(methodCall, result)
          METHOD_CHANGE_INTERNET_CONNECTIVITY -> changeInternetConnectivity(methodCall, result)
          else -> result.notImplemented()
        }
    }
  }

  private fun hello(methodCall: MethodCall, result: MethodChannel.Result) {
    result.success("HELLO WORLD")
  }

  private fun changeInternetConnectivity(methodCall: MethodCall,
                                         result: MethodChannel.Result) {
    val connectivity = methodCall.argument<Boolean>("connectivity")

    if (this.streamHandler == null || connectivity == null) return

    val intent = Intent()
    intent.putExtra("connectivity", connectivity)
    this.streamHandler?.handleIntent(this, intent)
  }

  // TODO: METHOD CALL WITH AWAIT
  private fun veryLongAsyncCall(methodCall: MethodCall,
                                result: MethodChannel.Result) {

  }

}
