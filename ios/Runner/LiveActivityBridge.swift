import Flutter
import Foundation

#if canImport(ActivityKit)
import ActivityKit
#endif

/// Dart → ActivityKit bridge for `MethodChannel('food_app/live_activity')`.
///
/// Every method degrades to a no-op (never an error) when Live Activities are
/// unavailable — iOS 15 and earlier, or the user has switched them off — so the
/// Flutter side doesn't need OS version checks.
final class LiveActivityBridge: NSObject {
  private static let channelName = "food_app/live_activity"

  #if canImport(ActivityKit)
  private var currentActivityId: String?
  #endif

  static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(
      name: channelName,
      binaryMessenger: registrar.messenger()
    )
    let instance = LiveActivityBridge()
    channel.setMethodCallHandler { call, result in
      instance.handle(call, result: result)
    }
    // Retain the handler for the app's lifetime.
    registrar.publish(instance)
  }

  private func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "areActivitiesEnabled":
      result(areActivitiesEnabled())
    case "start":
      start(arguments: call.arguments as? [String: Any] ?? [:], result: result)
    case "update":
      update(arguments: call.arguments as? [String: Any] ?? [:], result: result)
    case "end":
      let immediate = (call.arguments as? [String: Any])?["immediate"] as? Bool ?? false
      end(immediate: immediate, result: result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }

  /// Updates are driven by the app process, so if the app is killed the
  /// status stops advancing. Marking content stale after this window lets the
  /// lock screen say "paused" rather than silently showing a frozen status.
  /// Remove this once APNs push updates back the activity.
  private static func staleDate() -> Date {
    Date().addingTimeInterval(90)
  }

  private func areActivitiesEnabled() -> Bool {
    #if canImport(ActivityKit)
    if #available(iOS 16.1, *) {
      return ActivityAuthorizationInfo().areActivitiesEnabled
    }
    #endif
    return false
  }

  private func start(arguments: [String: Any], result: @escaping FlutterResult) {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *), areActivitiesEnabled() else {
      result(false)
      return
    }

    // Already running: treat start as an update so a hot restart or a second
    // call doesn't stack duplicate activities on the lock screen.
    if currentActivityId != nil {
      update(arguments: arguments, result: result)
      return
    }

    let attributes = OrderActivityAttributes(
      orderId: arguments["orderId"] as? String ?? "",
      restaurantName: arguments["restaurantName"] as? String ?? ""
    )
    let state = OrderActivityAttributes.ContentState.from(dictionary: arguments)

    do {
      let activity: Activity<OrderActivityAttributes>
      if #available(iOS 16.2, *) {
        activity = try Activity.request(
          attributes: attributes,
          content: ActivityContent(state: state, staleDate: Self.staleDate()),
          pushType: nil
        )
      } else {
        activity = try Activity.request(
          attributes: attributes,
          contentState: state,
          pushType: nil
        )
      }
      currentActivityId = activity.id
      result(true)
    } catch {
      result(
        FlutterError(
          code: "ACTIVITY_START_FAILED",
          message: error.localizedDescription,
          details: nil
        )
      )
    }
    #else
    result(false)
    #endif
  }

  private func update(arguments: [String: Any], result: @escaping FlutterResult) {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *), let id = currentActivityId,
      let activity = Activity<OrderActivityAttributes>.activities.first(where: { $0.id == id })
    else {
      result(false)
      return
    }

    let state = OrderActivityAttributes.ContentState.from(dictionary: arguments)
    Task {
      if #available(iOS 16.2, *) {
        await activity.update(ActivityContent(state: state, staleDate: Self.staleDate()))
      } else {
        await activity.update(using: state)
      }
      result(true)
    }
    #else
    result(false)
    #endif
  }

  private func end(immediate: Bool, result: @escaping FlutterResult) {
    #if canImport(ActivityKit)
    guard #available(iOS 16.1, *) else {
      result(false)
      return
    }

    let activities = Activity<OrderActivityAttributes>.activities
    currentActivityId = nil

    Task {
      for activity in activities {
        if #available(iOS 16.2, *) {
          await activity.end(nil, dismissalPolicy: immediate ? .immediate : .default)
        } else {
          await activity.end(dismissalPolicy: immediate ? .immediate : .default)
        }
      }
      result(true)
    }
    #else
    result(false)
    #endif
  }
}
