package com.anggach.flutternativesample

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import io.flutter.plugin.common.EventChannel

class FlutterStreamHandler: EventChannel.StreamHandler {

    private var receiver: BroadcastReceiver? = null

    fun handleIntent(context: Context, intent: Intent?) {
        if (this.receiver != null && intent != null)
            receiver!!.onReceive(context, intent)
    }

    override fun onCancel(p0: Any?) {
        receiver = null
    }

    override fun onListen(p0: Any?, events: EventChannel.EventSink?) {
        receiver = createReceiver(events)
    }

    private fun createReceiver(events: EventChannel.EventSink?): BroadcastReceiver {
        return object : BroadcastReceiver() {

            override fun onReceive(context: Context, intent: Intent) {
                val connectivity = intent.getBooleanExtra("connectivity", false)
                events?.success(connectivity)
            }
        }
    }

}