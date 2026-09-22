import Foundation

#if canImport(ActivityKit)
import ActivityKit

/// Shared contract between the app (which starts and updates the activity)
/// and the widget extension (which renders it).
///
/// This file is a member of BOTH the Runner and OrderActivity targets — if you
/// add a field, both sides pick it up automatically. `ContentState` is the part
/// that changes over the life of the order; `OrderActivityAttributes` itself is
/// fixed at request time.
@available(iOS 16.1, *)
struct OrderActivityAttributes: ActivityAttributes {
  public struct ContentState: Codable, Hashable {
    var statusKey: String
    var statusTitle: String
    var statusSubtitle: String
    var step: Int
    var totalSteps: Int
    var progress: Double
    var etaMinutes: Int
    var riderName: String
    var isTerminal: Bool

    /// Epoch seconds bounding the current leg of the journey. iOS animates
    /// the progress bar and the countdown between them by itself, with no
    /// further updates from the app — which is the only way to get continuous
    /// motion on a lock screen, since a Live Activity cannot run code.
    var startedAtEpoch: Double
    var etaAtEpoch: Double

    var startedAt: Date { Date(timeIntervalSince1970: startedAtEpoch) }
    var etaAt: Date { Date(timeIntervalSince1970: etaAtEpoch) }

    /// A strictly-increasing range. `ProgressView(timerInterval:)` traps if
    /// upperBound <= lowerBound, which happens whenever the ETA is 0 (order
    /// delivered, or the backend sent nothing), so clamp it here.
    var timerRange: ClosedRange<Date> {
      let start = startedAt
      let end = max(etaAt, start.addingTimeInterval(60))
      return start...end
    }

    /// Timers only make sense while the order is still in motion.
    var showsTimer: Bool { !isTerminal && etaMinutes > 0 }

    /// Matches the `/order/:id` route registered in `app_routes.dart` and the
    /// `foodapp` URL scheme in Runner's Info.plist.
    func deepLinkURL(orderId: String) -> URL? {
      let id = orderId.isEmpty ? "active" : orderId
      return URL(string: "foodapp://order/\(id)")
    }

    /// Keys mirror `OrderStatus.key` in Dart. Keep them in sync.
    static func from(dictionary: [String: Any]) -> ContentState {
      let now = Date().timeIntervalSince1970
      return ContentState(
        statusKey: dictionary["statusKey"] as? String ?? "order_placed",
        statusTitle: dictionary["statusTitle"] as? String ?? "Order placed",
        statusSubtitle: dictionary["statusSubtitle"] as? String ?? "",
        step: dictionary["step"] as? Int ?? 0,
        totalSteps: dictionary["totalSteps"] as? Int ?? 6,
        progress: dictionary["progress"] as? Double ?? 0,
        etaMinutes: dictionary["etaMinutes"] as? Int ?? 0,
        riderName: dictionary["riderName"] as? String ?? "",
        isTerminal: dictionary["isTerminal"] as? Bool ?? false,
        startedAtEpoch: dictionary["startedAtEpoch"] as? Double ?? now,
        etaAtEpoch: dictionary["etaAtEpoch"] as? Double ?? now
      )
    }

    /// SF Symbol per stage, used by the lock screen and Dynamic Island.
    var symbolName: String {
      switch statusKey {
      case "order_placed": return "checkmark.circle"
      case "kitchen_preparing": return "flame"
      case "order_prepared": return "takeoutbag.and.cup.and.straw"
      case "rider_picked_up": return "bag.badge.plus"
      case "rider_on_the_way": return "bicycle"
      case "delivered": return "house"
      default: return "circle"
      }
    }
  }

  var orderId: String
  var restaurantName: String
}
#endif
