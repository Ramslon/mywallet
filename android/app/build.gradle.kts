plugins {
    id("com.android.application")
    // START: FlutterFire Configuration
    id("com.google.gms.google-services")
    // END: FlutterFire Configuration
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
    // Firebase App Distribution plugin
    id("com.google.firebase.appdistribution")
}

android {
    namespace = "com.example.mywallet"
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
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.example.mywallet"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            // TODO: Add your own signing config for the release build.
            // Signing with the debug keys for now, so `flutter run --release` works.
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

// Firebase App Distribution configuration for one-command uploads
firebaseAppDistribution {
    // Firebase Android App ID (from firebase_options.dart or firebase.json)
    appId = "1:804074582835:android:cd78ebd076c7b9be45c446"
    // Upload APK to avoid Play integration requirements for AAB
    artifactType = "APK"
    // Tester groups defined in Firebase Console
    groups = "internal-testers"
    // Optional: provide release notes or a file path
    releaseNotes = "Automated upload via Gradle"
    // Use FIREBASE_TOKEN env var or serviceCredentialsFile for CI when needed
    // firebaseCliToken = System.getenv("FIREBASE_TOKEN")
    // serviceCredentialsFile = file("/absolute/path/to/service-account.json").path
}
