import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter plugin MUST be above Firebase plugins
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase plugin MUST be at the bottom
    id("com.google.gms.google-services")
}

val flutterVersionCode = 1
val flutterVersionName = "1.0.0"

android {
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(FileInputStream(keystorePropertiesFile))
    }

    namespace = "com.coherentlab.dhava"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.coherentlab.dhava"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }

    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"]!!)
            storePassword = keystoreProperties["storePassword"]!!.toString()
            keyAlias = keystoreProperties["keyAlias"]!!.toString()
            keyPassword = keystoreProperties["keyPassword"]!!.toString()
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
        }
    }
}

flutter {
    source = "../.."
}




dependencies {
    // Import the Firebase BoM
    implementation(platform("com.google.firebase:firebase-bom:32.7.2"))

    // Add the Firebase Analytics dependency
    implementation("com.google.firebase:firebase-analytics")

    // Multidex
    implementation("androidx.multidex:multidex:2.0.1")
}








/*

import java.util.Properties
import java.io.FileInputStream


plugins {
    id("com.android.application")
    id("kotlin-android")

    // Flutter plugin MUST be above Firebase plugins
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase plugin MUST be at the bottom
    id("com.google.gms.google-services")
}


val flutterVersionCode = 1
val flutterVersionName = "1.0.0"
android {
    val keystorePropertiesFile = rootProject.file("key.properties")
    val keystoreProperties = java.util.Properties()
    if (keystorePropertiesFile.exists()) {
        keystoreProperties.load(java.io.FileInputStream(keystorePropertiesFile))
    }

    namespace = "com.coherentlab.dhava"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "27.0.12077973"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.coherentlab.dhava"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutterVersionCode
        versionName = flutterVersionName
        multiDexEnabled = true
    }
    signingConfigs {
        create("release") {
            storeFile = file(keystoreProperties["storeFile"]!!)
            storePassword = keystoreProperties["storePassword"]!!.toString()
            keyAlias = keystoreProperties["keyAlias"]!!.toString()
            keyPassword = keystoreProperties["keyPassword"]!!.toString()
        }
    }
    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            // Agar proguard use karna ho to yeh add kar sakte ho:
            // proguardFiles(
            //     getDefaultProguardFile("proguard-android-optimize.txt"),
            //     file("proguard-rules.pro")
            // )
        }
    }

}

flutter {
    source = "../.."
}
dependencies {
    implementation("com.google.firebase:firebase-analytics")
    implementation("androidx.multidex:multidex:2.0.1")

}
*/
