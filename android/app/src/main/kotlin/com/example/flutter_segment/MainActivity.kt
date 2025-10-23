package com.example.flutter_segment

import android.app.NotificationManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.segment.analytics.Analytics
import com.segment.analytics.Traits
import com.segment.analytics.Properties
import com.clevertap.android.sdk.CleverTapAPI

class MainActivity : FlutterActivity() {
    private val CHANNEL = "segment_clevertap"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.DEBUG)

        CleverTapAPI.createNotificationChannel(
            applicationContext,
            "fluttersegment",
            "FlutterSegmentChannel",
            "TestChannel",
            NotificationManager.IMPORTANCE_MAX,
            true
        )

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->

                when (call.method) {

                    "init" -> {
                        // Segment is already initialized in YourApp.kt
                        // This just acknowledges the init call from Dart
                        result.success(null)
                    }

                    "identify" -> {
                        val userId: String = call.argument<String>("userId") ?: ""
                        val traitsMap: Map<String, Any> =
                            (call.argument<Any>("traits") as? Map<String, Any>) ?: emptyMap()

                        val traits = Traits()
                        traitsMap.forEach { (k, v) -> traits.putValue(k, v) }

                        Analytics.with(this).identify(userId, traits, null)
                        result.success(null)
                    }

                    "track" -> {
                        val eventName: String = call.argument<String>("eventName") ?: ""
                        val propsMap: Map<String, Any> =
                            (call.argument<Any>("properties") as? Map<String, Any>) ?: emptyMap()

                        val props = Properties()
                        propsMap.forEach { (k, v) -> props.put(k, v) }

                        Analytics.with(this).track(eventName, props)
                        result.success(null)
                    }

                    "screen" -> {
                        val screenName: String = call.argument<String>("screenName") ?: ""
                        val propsMap: Map<String, Any> =
                            (call.argument<Any>("properties") as? Map<String, Any>) ?: emptyMap()

                        val props = Properties()
                        propsMap.forEach { (k, v) -> props.put(k, v) }

                        Analytics.with(this).screen(screenName, null, props)
                        result.success(null)
                    }

                    "reset" -> {
                        Analytics.with(this).reset()
                        result.success(null)
                    }

                    else -> result.notImplemented()
                }
            }
    }
}
