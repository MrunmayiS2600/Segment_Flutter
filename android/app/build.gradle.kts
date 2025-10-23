plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter plugin must come after the Android/Kotlin ones
    id("dev.flutter.flutter-gradle-plugin")
    id("com.google.gms.google-services")
}

android {
    namespace = "com.example.flutter_segment"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.flutter_segment"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("debug")
        }
    }

    applicationVariants.all {
        outputs.all {
            if (this is com.android.build.gradle.internal.api.ApkVariantOutputImpl) {
                // Keep the default output location
                outputFileName = "app-${baseName}.apk"
            }
        }
    }
}

flutter {
    source = "../.."
}

dependencies {
    // Segment Analytics core SDK
    implementation("com.segment.analytics.android:analytics:4.9.4")

    // Segment -> CleverTap integration
    implementation("com.clevertap.android:clevertap-segment-android:1.7.0")

    // CleverTap Android SDK
    implementation("com.clevertap.android:clevertap-android-sdk:7.5.2")

    // Firebase & Install Referrer
    implementation("com.android.installreferrer:installreferrer:2.2")
    implementation("com.google.firebase:firebase-messaging:24.0.3")

    // UI & AndroidX essentials
    implementation("com.google.android.material:material:1.12.0")
    implementation("androidx.core:core:1.13.1")
    implementation("androidx.appcompat:appcompat:1.6.1")
    implementation("androidx.viewpager:viewpager:1.0.0")
    implementation("androidx.fragment:fragment:1.3.6")
    implementation("androidx.coordinatorlayout:coordinatorlayout:1.2.0")
}
