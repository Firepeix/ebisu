package com.tutufernandes.ebisu

import com.tutufernandes.ebisu.background.BackgroundPlugin
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            flutterEngine.plugins.add(BackgroundPlugin())
        } catch (e: Exception) {
            Log.e("Custom Plugin Manager", "Error registering plugin background, com.tutufernandes.ebisu.background.BackgroundPlugin", e)
        }
    }

}