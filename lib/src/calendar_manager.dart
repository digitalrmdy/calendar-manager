import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import '../calendar_manager.dart';

export 'package:calendar_manager/src/models.dart';

class CalendarManager {
  static const MethodChannel _channel =
      const MethodChannel('rmdy.be/calendar_manager');

  static final CalendarManager _instance = CalendarManager._();

  CalendarManager._();

  factory CalendarManager() => _instance;

  Future<void> createCalendar(Calendar calendar) async {
    assert(calendar != null);
    await _invokeMethod('createCalendar', {"calendar": jsonEncode(calendar)});
  }

  Future<T> _invokeMethod<T>(String method, Map<String, dynamic> args) async {
    print('invokeMethod: $method, $args');
    try {
      final result = await _channel.invokeMethod(method, args);
      print("result: $result");
      return result;
    } catch (ex) {
      print(ex);
      return null;
    }
  }

  Future<void> deleteAllEventsByCalendar(Calendar calendar) async {
    assert(calendar != null);
    await _invokeMethod("deleteAllEventsByCalendarId", {"calendar": calendar});
  }

  Future<void> createEvents(Calendar calendar, Iterable<Event> events) async {
    assert(calendar != null);
    assert(events != null);
    assert(events.isNotEmpty);
    await _invokeMethod("createEvents",
        {"calendar": jsonEncode(calendar), "events": jsonEncode(events)});
  }
}
