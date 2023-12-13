
package com.tutufernandes.ebisu

import com.tutufernandes.ebisu.background.BackgroundPlugin
import com.tutufernandes.ebisu.notification.EbisuNotificationPlugin
import io.flutter.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine

class MainActivity : FlutterActivity() {
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        try {
            flutterEngine.plugins.add(BackgroundPlugin())
        } catch (e: Exception) {
            Log.e("Custom Plugin Manager", "Error registering plugin background, com.tutufernandes.ebisu.background.BackgroundPlugin", e)
        }

        try {
            flutterEngine.plugins.add(EbisuNotificationPlugin())
        } catch (e: Exception) {
            Log.e("Custom Plugin Manager", "Error registering plugin background, com.tutufernandes.ebisu.notification.EbisuNotificationPlugin", e)
        }
    }

}