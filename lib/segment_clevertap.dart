import 'dart:async';
import 'package:flutter/services.dart';

class SegmentCleverTap {
  static const MethodChannel _channel = MethodChannel('segment_clevertap');

  /// Initialize Segment + CleverTap
  static Future<void> init({
    required String writeKey,
    String? region,
  }) async {
    await _channel.invokeMethod('init', {
      'writeKey': writeKey,
      if (region != null) 'region': region,
    });
  }

  /// Identify a user
  static Future<void> identify(String userId, Map<String, dynamic> traits) async {
    await _channel.invokeMethod('identify', {
      'userId': userId,
      'traits': traits,
    });
  }

  /// Track an event
  static Future<void> track(String eventName, Map<String, dynamic>? properties) async {
    await _channel.invokeMethod('track', {
      'eventName': eventName,
      'properties': properties ?? {},
    });
  }

  /// Track a screen view
  // static Future<void> screen(String screenName, Map<String, dynamic>? properties) async {
  //   await _channel.invokeMethod('screen', {
  //     'screenName': screenName,
  //     'properties': properties ?? {},
  //   });
  // }

  /// Reset (logout)
  // static Future<void> reset() async {
  //   await _channel.invokeMethod('reset');
  // }
}
