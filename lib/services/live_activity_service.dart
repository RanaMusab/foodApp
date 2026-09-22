import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:food_app/features/order_tracking/data/models/order_models.dart';
import 'package:food_app/features/order_tracking/domain/entities/order_status.dart';

class LiveActivityService {
  static final LiveActivityService _instance = LiveActivityService._();

  factory LiveActivityService() => _instance;

  LiveActivityService._();

  static const MethodChannel _channel = MethodChannel('food_app/live_activity');

  bool _isRunning = false;

  bool get isRunning => _isRunning;

  bool get isSupportedPlatform => Platform.isIOS || Platform.isAndroid;

  Map<String, dynamic> _payload(OrderModel order) {
    final now = DateTime.now();
    final eta = now.add(Duration(minutes: order.etaMinutes ?? 0));

    return {
      'orderId': order.id ?? '',
      'restaurantName': order.restaurantName ?? '',
      'statusKey': order.status.key,
      'statusTitle': order.status.title,
      'statusSubtitle': order.status.subtitle,
      'step': order.status.step,
      'totalSteps': OrderStatus.totalSteps,
      'progress': order.status.progress,
      'etaMinutes': order.etaMinutes ?? 0,
      'riderName': order.riderName ?? '',
      'isTerminal': order.status.isTerminal,
      'startedAtEpoch': now.millisecondsSinceEpoch / 1000,
      'etaAtEpoch': eta.millisecondsSinceEpoch / 1000,
    };
  }


  Future<void> start(OrderModel order) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('start', _payload(order));
      _isRunning = true;
    } on PlatformException catch (ex) {
      debugPrint('LiveActivity start failed: ${ex.code} ${ex.message}');
    } on MissingPluginException {
      debugPrint('LiveActivity channel not registered on this platform.');
    }
  }

  Future<void> update(OrderModel order) async {
    if (!isSupportedPlatform) return;
    if (!_isRunning) return start(order);
    try {
      await _channel.invokeMethod<void>('update', _payload(order));
    } on PlatformException catch (ex) {
      debugPrint('LiveActivity update failed: ${ex.code} ${ex.message}');
    } on MissingPluginException {
      // Nothing to update.
    }
  }

  Future<void> end({bool immediate = false}) async {
    if (!isSupportedPlatform) return;
    try {
      await _channel.invokeMethod<void>('end', {'immediate': immediate});
    } on PlatformException catch (ex) {
      debugPrint('LiveActivity end failed: ${ex.code} ${ex.message}');
    } on MissingPluginException {
      // Nothing to end.
    } finally {
      _isRunning = false;
    }
  }


  Future<bool> areActivitiesEnabled() async {
    if (!isSupportedPlatform) return false;
    try {
      return await _channel.invokeMethod<bool>('areActivitiesEnabled') ?? false;
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }
}
