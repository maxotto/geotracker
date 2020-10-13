package com.example.background

import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugins.GeneratedPluginRegistrant;

class MainActivity : FlutterActivity() {
    /*
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        GeneratedPluginRegistrant.registerWith(this)

        Notifications.createNotificationChannels(this)

        MethodChannel(flutterView, "com.example/background_service").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "startService") {
                    val callbackRawHandle = method.arguments as Long
                    BackgroundService.startService(this@MainActivity, callbackRawHandle)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }

        MethodChannel(flutterView, "com.example/app_retain").apply {
            setMethodCallHandler { method, result ->
                if (method.method == "sendToBackground") {
                    moveTaskToBack(true)
                    result.success(null)
                } else {
                    result.notImplemented()
                }
            }
        }
    }

     */
}
