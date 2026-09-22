package com.example.food_app

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.app.ServiceCompat
import androidx.core.net.toUri

/**
 * Android's closest analogue to an iOS Live Activity: a foreground service
 * holding an ongoing, non-dismissible notification that updates in place as the
 * order moves through its six statuses. It stays on the lock screen while the
 * phone is locked, which is the behaviour we're after.
 */
class OrderTrackingService : android.app.Service() {

    companion object {
        const val ACTION_START = "com.example.food_app.action.START"
        const val ACTION_UPDATE = "com.example.food_app.action.UPDATE"
        const val ACTION_STOP = "com.example.food_app.action.STOP"

        const val EXTRA_ORDER_ID = "orderId"
        const val EXTRA_STATUS_TITLE = "statusTitle"
        const val EXTRA_STATUS_SUBTITLE = "statusSubtitle"
        const val EXTRA_RESTAURANT = "restaurantName"
        const val EXTRA_STEP = "step"
        const val EXTRA_TOTAL_STEPS = "totalSteps"
        const val EXTRA_ETA = "etaMinutes"
        const val EXTRA_ETA_AT_EPOCH = "etaAtEpoch"
        const val EXTRA_IS_TERMINAL = "isTerminal"

        private const val CHANNEL_ID = "order_tracking"
        private const val NOTIFICATION_ID = 4417

        fun channelId(): String = CHANNEL_ID
    }

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onCreate() {
        super.onCreate()
        createChannel()
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        when (intent?.action) {
            ACTION_STOP -> {
                ServiceCompat.stopForeground(this, ServiceCompat.STOP_FOREGROUND_REMOVE)
                stopSelf()
                return START_NOT_STICKY
            }
            ACTION_START -> startForegroundCompat(buildNotification(intent))
            ACTION_UPDATE -> {
                val notification = buildNotification(intent)
                // Updating through the manager (rather than startForeground again)
                // avoids re-triggering the foreground-service start restrictions.
                NotificationManagerCompat.from(this)
                    .takeIf { it.areNotificationsEnabled() }
                    ?.notify(NOTIFICATION_ID, notification)
            }
        }
        // Tracking is only meaningful while there is a live order; don't let the
        // system resurrect this service with a stale intent.
        return START_NOT_STICKY
    }

    private fun startForegroundCompat(notification: Notification) {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            ServiceCompat.startForeground(
                this,
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_DATA_SYNC
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
    }

    private fun buildNotification(intent: Intent): Notification {
        val title = intent.getStringExtra(EXTRA_STATUS_TITLE) ?: "Order update"
        val subtitle = intent.getStringExtra(EXTRA_STATUS_SUBTITLE) ?: ""
        val restaurant = intent.getStringExtra(EXTRA_RESTAURANT) ?: ""
        val step = intent.getIntExtra(EXTRA_STEP, 0)
        val totalSteps = intent.getIntExtra(EXTRA_TOTAL_STEPS, 6)
        val eta = intent.getIntExtra(EXTRA_ETA, 0)
        val etaAtEpoch = intent.getDoubleExtra(EXTRA_ETA_AT_EPOCH, 0.0)
        val isTerminal = intent.getBooleanExtra(EXTRA_IS_TERMINAL, false)
        val showsTimer = !isTerminal && eta > 0 && etaAtEpoch > 0

        // Deep link to the tracking screen rather than the launcher entry, so
        // tapping the notification resumes the order instead of cold-starting
        // on the home screen. Mirrors the iOS Live Activity's widgetURL.
        val orderId = intent.getStringExtra(EXTRA_ORDER_ID).orEmpty()
        val deepLink = Intent(
            Intent.ACTION_VIEW,
            "foodapp://order/${orderId.ifEmpty { "active" }}".toUri()
        ).apply {
            setPackage(packageName)
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
        }

        val contentIntent = PendingIntent.getActivity(
            this,
            0,
            deepLink,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )

        val subText = when {
            isTerminal -> restaurant
            eta > 0 -> "$eta min • $restaurant"
            else -> restaurant
        }

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(android.R.drawable.ic_menu_mylocation)
            .setContentTitle(title)
            .setContentText(subtitle)
            .setSubText(subText)
            .setProgress(totalSteps, step + 1, false)
            .setOngoing(!isTerminal)
            .setOnlyAlertOnce(true)
            .setCategory(NotificationCompat.CATEGORY_PROGRESS)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setContentIntent(contentIntent)
            .apply {
                // Android's counterpart to iOS's Text(timerInterval:): the
                // system ticks this down once per second on the lock screen
                // without the service posting further updates.
                if (showsTimer) {
                    setWhen((etaAtEpoch * 1000).toLong())
                    setUsesChronometer(true)
                    setChronometerCountDown(true)
                } else {
                    setShowWhen(false)
                    setUsesChronometer(false)
                }
            }
            .build()
    }

    private fun createChannel() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.O) return
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Order tracking",
            // LOW keeps it silent: the status changes often and should not buzz.
            NotificationManager.IMPORTANCE_LOW
        ).apply {
            description = "Live status of your food order"
            setShowBadge(false)
        }
        getSystemService(Context.NOTIFICATION_SERVICE)
            .let { it as NotificationManager }
            .createNotificationChannel(channel)
    }
}
