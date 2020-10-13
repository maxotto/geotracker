package com.example.background

import io.flutter.app.FlutterApplication
// import io.flutter.embedding.android.FlutterApplication;

class App : FlutterApplication() {
    override fun onCreate() {
        super.onCreate()
        registerActivityLifecycleCallbacks(LifecycleDetector.activityLifecycleCallbacks)
    }
}