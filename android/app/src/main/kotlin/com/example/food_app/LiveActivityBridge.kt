package com.example.food_app

import android.app.Activity
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import androidx.core.app.ActivityCompat
import androidx.core.app.NotificationManagerCompat
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel

/**
 * Android half of `MethodChannel('food_app/live_activity')`.
 *
 * Accepts the same payload as the iOS bridge and drives [OrderTrackingService].
 */
class LiveActivityBridge(
    private val plugin: FlutterPlugin.FlutterPluginBinding,
    private val activityProvider: () -> Activity?
) : MethodChannel.MethodCallHandler {

    companion object {
        private const val CHANNEL = "food_app/live_activity"
        private const val NOTIFICATION_PERMISSION_REQUEST = 4417

        fun register(
            binding: FlutterPlugin.FlutterPluginBinding,
            activityProvider: () -> Activity?
        ): MethodChannel {
            val channel = MethodChannel(binding.binaryMessenger, CHANNEL)
            channel.setMethodCallHandler(LiveActivityBridge(binding, activityProvider))
            return channel
        }
    }

    private val context get() = plugin.applicationContext

    override fun onMethodCall(call: MethodCall, result: MethodChannel.Result) {
        when (call.method) {
            "areActivitiesEnabled" -> {
                requestNotificationPermissionIfNeeded()
                result.success(NotificationManagerCompat.from(context).areNotificationsEnabled())
            }
            "start" -> {
                sendToService(OrderTrackingService.ACTION_START, call)
                result.success(true)
            }
            "update" -> {
                sendToService(OrderTrackingService.ACTION_UPDATE, call)
                result.success(true)
            }
            "end" -> {
                context.startService(
                    Intent(context, OrderTrackingService::class.java).apply {
                        action = OrderTrackingService.ACTION_STOP
                    }
                )
                result.success(true)
            }
            else -> result.notImplemented()
        }
    }

    private fun sendToService(action: String, call: MethodCall) {
        val intent = Intent(context, OrderTrackingService::class.java).apply {
            this.action = action
            putExtra(OrderTrackingService.EXTRA_ORDER_ID, call.argument<String>("orderId"))
            putExtra(
                OrderTrackingService.EXTRA_STATUS_TITLE,
                call.argument<String>("statusTitle")
            )
            putExtra(
                OrderTrackingService.EXTRA_STATUS_SUBTITLE,
                call.argument<String>("statusSubtitle")
            )
            putExtra(
                OrderTrackingService.EXTRA_RESTAURANT,
                call.argument<String>("restaurantName")
            )
            putExtra(OrderTrackingService.EXTRA_STEP, call.argument<Int>("step") ?: 0)
            putExtra(
                OrderTrackingService.EXTRA_TOTAL_STEPS,
                call.argument<Int>("totalSteps") ?: 6
            )
            putExtra(OrderTrackingService.EXTRA_ETA, call.argument<Int>("etaMinutes") ?: 0)
            putExtra(
                OrderTrackingService.EXTRA_ETA_AT_EPOCH,
                call.argument<Double>("etaAtEpoch") ?: 0.0
            )
            putExtra(
                OrderTrackingService.EXTRA_IS_TERMINAL,
                call.argument<Boolean>("isTerminal") ?: false
            )
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            context.startForegroundService(intent)
        } else {
            context.startService(intent)
        }
    }

    /** POST_NOTIFICATIONS became a runtime permission in Android 13. */
    private fun requestNotificationPermissionIfNeeded() {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.TIRAMISU) return
        val activity = activityProvider() ?: return
        val granted = ActivityCompat.checkSelfPermission(
            activity,
            android.Manifest.permission.POST_NOTIFICATIONS
        ) == PackageManager.PERMISSION_GRANTED
        if (granted) return
        ActivityCompat.requestPermissions(
            activity,
            arrayOf(android.Manifest.permission.POST_NOTIFICATIONS),
            NOTIFICATION_PERMISSION_REQUEST
        )
    }
}
