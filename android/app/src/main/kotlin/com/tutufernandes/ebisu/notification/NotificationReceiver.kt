package com.tutufernandes.ebisu.notification

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import androidx.annotation.RequiresApi
import io.flutter.plugin.common.EventChannel.EventSink


class NotificationReceiver(private val eventSink: EventSink) : BroadcastReceiver() {
    @RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
    override fun onReceive(context: Context, intent: Intent) {
        /// Unpack intent contents
        val packageName = intent.getStringExtra(NotificationListener.NOTIFICATION_PACKAGE_NAME)
        val title = intent.getStringExtra(NotificationListener.NOTIFICATION_TITLE)
        val message = intent.getStringExtra(NotificationListener.NOTIFICATION_MESSAGE)

        /// Send data back via the Event Sink
        val data = HashMap<String, Any?>()
        data["packageName"] = packageName
        data["title"] = title
        data["message"] = message
        eventSink.success(data)
    }
}