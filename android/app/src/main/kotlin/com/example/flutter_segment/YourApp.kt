package com.example.flutter_segment

import android.app.Application
import com.clevertap.android.sdk.ActivityLifecycleCallback
import com.clevertap.android.sdk.CleverTapAPI
import com.segment.analytics.Analytics
import com.segment.analytics.android.integrations.clevertap.CleverTapIntegration

class YourApp : Application() {
    override fun onCreate() {
        super.onCreate()
        
        // Initialize CleverTap
        ActivityLifecycleCallback.register(this)
        CleverTapAPI.setDebugLevel(CleverTapAPI.LogLevel.DEBUG)
        CleverTapAPI.getDefaultInstance(this)
        
        // Initialize Segment Analytics
        // Replace "YOUR_SEGMENT_WRITE_KEY" with your actual Segment write key
        val analytics = Analytics.Builder(this, "xFsG3xwUq9UiOIyeGbtEGLlBE4wBCtEU")
            .use(CleverTapIntegration.FACTORY)
            .trackApplicationLifecycleEvents()
            .recordScreenViews()
            .build()
        
        Analytics.setSingletonInstance(analytics)
    }
}