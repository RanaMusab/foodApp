import SwiftUI
import WidgetKit

@main
struct OrderActivityBundle: WidgetBundle {
  var body: some Widget {
    if #available(iOS 16.1, *) {
      OrderLiveActivity()
    }
  }
}
