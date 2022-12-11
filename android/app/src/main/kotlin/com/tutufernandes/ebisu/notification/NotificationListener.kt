package com.tutufernandes.ebisu.notification

import android.annotation.SuppressLint
import android.app.Notification
import android.content.Intent
import android.os.Build
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import androidx.annotation.RequiresApi
import android.util.Log

@SuppressLint("OverrideAbstract")
@RequiresApi(api = Build.VERSION_CODES.JELLY_BEAN_MR2)
class NotificationListener : NotificationListenerService() {
    companion object {
        var NOTIFICATION_INTENT = "notification_event"
        var NOTIFICATION_PACKAGE_NAME = "notification_package_name"
        var NOTIFICATION_MESSAGE = "notification_message"
        var NOTIFICATION_TITLE = "notification_title"
        private const val TAG = "EbisuNotificationsPlugin"
    }

    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    override fun onNotificationPosted(notification: StatusBarNotification) {
        // Retrieve package name to set as title.
        val packageName = notification.packageName
        // Retrieve extra object from notification to extract payload.
        val extras = notification.notification.extras

        // Pass data from one activity to another.
        val intent = Intent(NOTIFICATION_INTENT)
        intent.putExtra(NOTIFICATION_PACKAGE_NAME, packageName)
        if (extras != null) {
            extras.getCharSequence(Notification.EXTRA_TITLE)?.let { title ->
                intent.putExtra(NOTIFICATION_TITLE, title.toString())
            }

            extras.getCharSequence(Notification.EXTRA_TEXT)?.let { text ->
                intent.putExtra(NOTIFICATION_MESSAGE, text.toString())
            }
        }
        sendBroadcast(intent)
        Log.i(TAG, "Recebendo nova notificação de $packageName")
    }

    override fun onListenerConnected() {
        super.onListenerConnected()
        Log.i(TAG, "Serviço de notificação conectado")
    }

    override fun onListenerDisconnected() {
        super.onListenerDisconnected()
        Log.i(TAG, "Serviço de notificação conectado")
    }
}