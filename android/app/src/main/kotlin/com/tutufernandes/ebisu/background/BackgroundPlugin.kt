package com.tutufernandes.ebisu.background

import android.content.Context
import android.content.Intent
import android.os.Build
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

class BackgroundPlugin : FlutterPlugin, MethodChannel.MethodCallHandler {
    companion object {
        const val BACKGROUND_PLUGIN_CHANNEL = "ebisu.firepeix.com/background_plugin"
        const val BACKGROUND_PLUGIN_STREAM  = "ebisu.firepeix.com/background_plugin/stream"
    }

    var context: Context? = null
    var service: Intent? = null


    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.getApplicationContext()
        val channel = MethodChannel(binding.getBinaryMessenger(), BACKGROUND_PLUGIN_CHANNEL)
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = null
    }

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        val args = call.arguments<ArrayList<*>>()
        when(call.method) {
            "BackgroundPlugin.installService" -> {
                try {
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                        service = Intent(context, BackgroundService::class.java)
                        context?.startService(service)
                        result.success(true)
                    }
                } catch (e: Error) {
                    result.error("STOP", "Couldn't stop the battery service", e.message)
                }
            }
            "BackgroundPlugin.uninstallService" ->  {
                try {
                    context?.stopService(service)
                    result.success(null)
                } catch (e: Error) {
                    result.error("STOP", "Couldn't stop the battery service", e.message)
                }
            }
            else -> result.notImplemented()
        }
    }
}