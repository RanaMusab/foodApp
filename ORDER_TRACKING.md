# Order Tracking — Live Status on the Lock Screen

Tracks a food order through six statuses, shows the rider on a Google Map, and
mirrors the status to the lock screen on both platforms.

## The six statuses

Defined once in `lib/features/order_tracking/domain/entities/order_status.dart`.
Both native sides receive the `key`, never the enum index.

| # | key | Title |
|---|-----|-------|
| 1 | `order_placed` | Order placed |
| 2 | `kitchen_preparing` | Kitchen is preparing |
| 3 | `order_prepared` | Order prepared |
| 4 | `rider_picked_up` | Rider picked up your order |
| 5 | `rider_on_the_way` | Rider is on the way |
| 6 | `delivered` | Delivered |

Adding or renaming a status is a one-file change in Dart; iOS picks up the
title/subtitle from the payload. Only `symbolName` in
`ios/OrderActivity/OrderActivityAttributes.swift` maps keys to SF Symbols and
needs a matching case.

## How it flows

```
SimulatedOrderDataSource (timer)
  → Stream<OrderModel>
  → WatchOrderUseCase
  → OrderTrackingProvider
      ├─ notifyListeners()      → map + timeline UI
      └─ LiveActivityService    → MethodChannel('food_app/live_activity')
                                    ├─ iOS     → ActivityKit Live Activity
                                    └─ Android → OrderTrackingService notification
```

The provider only calls the native bridge when the **status changes**, not on
every stream tick — ActivityKit throttles frequent updates and Android would
flicker the notification.

## iOS — Live Activities (ActivityKit)

**Targets:** `Runner` (app) and `OrderActivity` (widget extension, iOS 16.1+).

| File | Role |
|---|---|
| `ios/OrderActivity/OrderActivityAttributes.swift` | Shared contract. **Member of both targets.** |
| `ios/OrderActivity/OrderLiveActivity.swift` | Lock-screen view + Dynamic Island (compact / minimal / expanded) |
| `ios/OrderActivity/OrderActivityBundle.swift` | `@main` WidgetBundle |
| `ios/Runner/LiveActivityBridge.swift` | MethodChannel → `Activity.request` / `.update` / `.end` |

`NSSupportsLiveActivities` is set in `ios/Runner/Info.plist`. The app target
stays at iOS 15 — the extension is 16.1, so it simply isn't installed on older
devices and every bridge call no-ops.

### Testing it

Live Activities work in the Simulator. Use an **iPhone 15 Pro or newer** to see
the Dynamic Island.

1. `flutter run` on the simulator
2. Tap **Track order** on the home screen
3. Lock the device (`Cmd+L`) — the banner appears and updates every ~12s
4. For the Dynamic Island, keep the app in the background instead of locking

If nothing shows: Settings → Food App → Live Activities must be on.
`areActivitiesEnabled` surfaces this in the app as an amber hint.

## Android — ongoing notification

`OrderTrackingService` is a `dataSync` foreground service holding an ongoing,
silent (`IMPORTANCE_LOW`) notification with a six-step progress bar. It survives
backgrounding and shows on the lock screen.

`POST_NOTIFICATIONS` is requested at runtime on Android 13+ the first time
tracking starts.

## Google Maps

The key is wired into `android/app/src/main/AndroidManifest.xml` and
`ios/Runner/AppSecrets.swift`.

⚠️ It is committed in plaintext. Before shipping, restrict it in Google Cloud
Console — Android: package name + SHA-1; iOS: bundle ID `com.example.foodApp`.
An unrestricted key can be lifted from the APK and billed to your account.

## Swapping in a real backend

`SimulatedOrderDataSource` advances the status on a timer and walks the rider
along an interpolated line. To go live:

1. Write `OrderTrackingDataSourcesImplementation` against `OrderTrackingDataSources`,
   calling `ApiService` for `getOrder` and a WebSocket for `watchOrder`
2. Change the one line in `lib/features/order_tracking/di/order_tracking_module.dart`
3. Add the endpoint to `ApiConfig`
4. Replace `routePoints` with a Directions API polyline

Nothing else changes — the provider, UI and both native bridges are unaffected.

## Known limits

- Updates are **local**. If the app is killed, the Live Activity freezes at the
  last status. Continuing updates while the app is dead needs APNs push-to-start
  and push tokens, which requires a server.
- Android 15 caps `dataSync` foreground services at ~6h/day cumulative.
