package com.tutufernandes.ebisu.notification

import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import android.text.TextUtils
import android.util.Log
import androidx.annotation.RequiresApi
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.FlutterPlugin.FlutterPluginBinding
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink

class EbisuNotificationPlugin : FlutterPlugin, EventChannel.StreamHandler {

  companion object {
    const val BACKGROUND_PLUGIN_STREAM  = "ebisu.firepeix.com/notifications_plugin"
    private const val TAG = "EbisuNotificationsPlugin"
  }

  private var eventChannel: EventChannel? = null
  private var context: Context? = null

  fun requestPermission() {
    /// Sort out permissions for notifications
    if (!permissionGranted()) {
      val permissionScreen = Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS")
      permissionScreen.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
      context!!.startActivity(permissionScreen)
    }
  }

  private fun permissionGranted(): Boolean {
    val packageName = context?.packageName
    val flat = Settings.Secure.getString(context!!.contentResolver,"enabled_notification_listeners")
    if (!TextUtils.isEmpty(flat)) {
      val names = flat.split(":".toRegex()).toTypedArray()
      for (name in names) {
        val componentName = ComponentName.unflattenFromString(name)
        val nameMatch = TextUtils.equals(packageName, componentName!!.packageName)
        if (nameMatch) {
          return true
        }
      }
    }
    return false
  }

  @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
  override fun onAttachedToEngine(binding: FlutterPluginBinding) {
    eventChannel = EventChannel(binding.getBinaryMessenger(), BACKGROUND_PLUGIN_STREAM)
    eventChannel?.setStreamHandler(this)
    context = binding.getApplicationContext()
  }

  override fun onDetachedFromEngine(binding: FlutterPluginBinding) {
    eventChannel?.setStreamHandler(null)
    context = null
  }

  @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
  override fun onListen(arguments: Any?, events: EventSink) {
    if (permissionGranted()) {
      /// Set up receiver
      val intentFilter = IntentFilter()
      intentFilter.addAction(NotificationListener.NOTIFICATION_INTENT)
      val receiver = NotificationReceiver(events)
      context?.registerReceiver(receiver, intentFilter)

      context?.startService(Intent(context, NotificationListener::class.java))
      Log.i(TAG, "Iniciando serviço de notificação contexto iniciado = ${context != null}")
    } else {
      requestPermission()
      Log.e(TAG, "Falha ao iniciar; Permissões não garantidas")
    }
  }

  override fun onCancel(arguments: Any?) {
    eventChannel?.setStreamHandler(null)
  }
}