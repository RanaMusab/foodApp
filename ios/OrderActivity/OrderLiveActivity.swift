#if canImport(ActivityKit)
import ActivityKit
import SwiftUI
import WidgetKit

/// The lock-screen banner and Dynamic Island presentations.
///
/// iOS renders these in a separate process with a tight memory budget, so
/// everything here is static SwiftUI — no networking, no images loaded at
/// runtime, no timers.
@available(iOS 16.1, *)
struct OrderLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: OrderActivityAttributes.self) { context in
      LockScreenView(context: context)
        .activityBackgroundTint(Color.black.opacity(0.75))
        .activitySystemActionForegroundColor(Color.white)
        // Tapping the banner opens the tracking screen directly instead of
        // dumping the user on the home screen.
        .widgetURL(context.state.deepLinkURL(orderId: context.attributes.orderId))
    } dynamicIsland: { context in
      DynamicIsland {
        DynamicIslandExpandedRegion(.leading) {
          Label {
            Text(context.state.statusTitle)
              .font(.caption)
              .fontWeight(.semibold)
          } icon: {
            Image(systemName: context.state.symbolName)
              .foregroundColor(.green)
          }
          .padding(.leading, 4)
        }

        DynamicIslandExpandedRegion(.trailing) {
          if context.state.showsTimer {
            VStack(alignment: .trailing) {
              Text(timerInterval: context.state.timerRange, countsDown: true)
                .font(.title3)
                .fontWeight(.bold)
                .monospacedDigit()
                .multilineTextAlignment(.trailing)
                .frame(maxWidth: 64)
              Text("remaining")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
            .padding(.trailing, 4)
          }
        }

        DynamicIslandExpandedRegion(.bottom) {
          VStack(alignment: .leading, spacing: 6) {
            if context.state.showsTimer {
              ProgressView(timerInterval: context.state.timerRange, countsDown: false) {
                EmptyView()
              } currentValueLabel: {
                EmptyView()
              }
              .tint(.green)
            } else {
              ProgressView(value: context.state.progress)
                .tint(.green)
            }
            HStack {
              Text(context.state.statusSubtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
              Spacer()
              Text("Step \(context.state.step + 1) of \(context.state.totalSteps)")
                .font(.caption2)
                .foregroundColor(.secondary)
            }
          }
          .padding(.horizontal, 4)
        }
      } compactLeading: {
        Image(systemName: context.state.symbolName)
          .foregroundColor(.green)
      } compactTrailing: {
        if context.state.showsTimer {
          Text(timerInterval: context.state.timerRange, countsDown: true)
            .font(.caption2)
            .monospacedDigit()
            .multilineTextAlignment(.center)
            .frame(maxWidth: 44)
            .foregroundColor(.green)
        }
      } minimal: {
        Image(systemName: context.state.symbolName)
          .foregroundColor(.green)
      }
      .keylineTint(.green)
    }
  }
}

/// What the user sees on the lock screen without unlocking the phone.
@available(iOS 16.1, *)
struct LockScreenView: View {
  let context: ActivityViewContext<OrderActivityAttributes>

  var body: some View {
    VStack(alignment: .leading, spacing: 12) {
      HStack(alignment: .center, spacing: 10) {
        Image(systemName: context.state.symbolName)
          .font(.title2)
          .foregroundColor(.green)
          .frame(width: 34, height: 34)
          .background(Color.green.opacity(0.15))
          .clipShape(Circle())

        VStack(alignment: .leading, spacing: 2) {
          Text(context.state.statusTitle)
            .font(.headline)
            .foregroundColor(.white)
          Text(context.attributes.restaurantName)
            .font(.caption)
            .foregroundColor(.white.opacity(0.7))
        }

        Spacer()

        if context.state.showsTimer {
          // Counts down second by second on its own — no app updates needed.
          VStack(alignment: .trailing, spacing: 0) {
            Text(timerInterval: context.state.timerRange, countsDown: true)
              .font(.title2)
              .fontWeight(.bold)
              .monospacedDigit()
              .multilineTextAlignment(.trailing)
              .frame(maxWidth: 74)
              .foregroundColor(.white)
            Text("remaining")
              .font(.caption2)
              .foregroundColor(.white.opacity(0.7))
          }
        }
      }

      // Continuously fills between the two instants the app supplied, so the
      // banner keeps moving between status changes rather than sitting still.
      if context.state.showsTimer {
        ProgressView(timerInterval: context.state.timerRange, countsDown: false) {
          EmptyView()
        } currentValueLabel: {
          EmptyView()
        }
        .progressViewStyle(.linear)
        .tint(.green)
      }

      // Six segments, one per status — the same timeline the app shows.
      HStack(spacing: 4) {
        ForEach(0..<context.state.totalSteps, id: \.self) { index in
          Capsule()
            .fill(index <= context.state.step ? Color.green : Color.white.opacity(0.25))
            .frame(height: 4)
        }
      }
      // Animates the fill when a new status arrives instead of snapping.
      .animation(.easeInOut(duration: 0.45), value: context.state.step)

      // `isStale` flips once the content passes the staleDate the app set.
      // In practice that means the app was killed and updates have stopped, so
      // say so rather than leaving a frozen status looking live.
      // `isStale` arrived in 16.2; on 16.1 we simply keep showing the subtitle.
      if #available(iOS 16.2, *), context.isStale {
        Label("Paused — open the app to resume", systemImage: "exclamationmark.arrow.circlepath")
          .font(.caption2)
          .foregroundColor(.orange)
      } else {
        Text(context.state.statusSubtitle)
          .font(.caption)
          .foregroundColor(.white.opacity(0.7))
          .contentTransition(.opacity)
      }
    }
    .padding(16)
  }
}
#endif
