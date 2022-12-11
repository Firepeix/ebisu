package com.tutufernandes.ebisu.background

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Intent
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import com.tutufernandes.ebisu.R;

class BackgroundService : Service() {
    companion object {
        const val NOTIFICATION_CHANNEL_ID = "dd26c9416adc4f618e9410bf828a4303"
        const val NOTIFICATION_TITLE = "Ola!"
        const val NOTIFICATION_CONTENT = "Estou trabalhando para rastrear suas despesas"
    }


    override fun onBind(intent: Intent?): IBinder? {
        return null
    }

    private fun buildNotificationBadge() {
        val stop = "stop"
        val flag = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE else PendingIntent.FLAG_UPDATE_CURRENT
        val broadcastIntent = PendingIntent.getBroadcast(this, 0, Intent(stop), flag)

        val builder = NotificationCompat.Builder(this, NOTIFICATION_CHANNEL_ID)
                .setContentTitle(NOTIFICATION_TITLE)
                .setContentText(NOTIFICATION_CONTENT)
                .setOngoing(true)
                .setSmallIcon(R.mipmap.ic_launcher)
                .setContentIntent(broadcastIntent)


        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(NOTIFICATION_CHANNEL_ID, NOTIFICATION_TITLE, NotificationManager.IMPORTANCE_DEFAULT )
            channel.setShowBadge(false)
            channel.description = NOTIFICATION_CONTENT
            channel.setSound(null, null)
            val manager = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
            manager.createNotificationChannel(channel)
            println("Criando canal de notificação!")
        }

        startForeground(1, builder.build())
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        buildNotificationBadge()
        println("Buscando despesas")
        return START_STICKY
    }
}