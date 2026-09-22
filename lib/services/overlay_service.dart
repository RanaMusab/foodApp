import 'package:flutter/material.dart';

class OverlayService {
  static final OverlayService _instance = OverlayService._internal();
  static OverlayListeners? _listeners;
  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;

  factory OverlayService({OverlayListeners? listener}) {
    if (listener != null) _listeners = listener;
    return _instance;
  }

  OverlayService._internal();

  void initOverlay(BuildContext context) {
    _overlayState ??= Overlay.of(context);
  }

  void setOverlayEntry(BuildContext context, OverlayEntry overlayEntry) {
    initOverlay(context);
    removeOverlayEntry(callListener: false);
    _overlayEntry = overlayEntry;
    _overlayState?.insert(_overlayEntry!);
  }

  void removeOverlayEntry({bool callListener = true}) {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (callListener) _listeners?.onOverlayClosed();
  }

  bool isOverlayVisible() {
    return _overlayEntry != null;
  }
}

mixin OverlayListeners {
  void onOverlayClosed() {}
}
