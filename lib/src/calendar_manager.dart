import 'dart:async';
import 'dart:convert';

import 'package:calendar_manager/src/utils.dart';
import 'package:flutter/services.dart';

import '../calendar_manager.dart';

export 'package:calendar_manager/src/models.dart';

abstract class CalendarManager {
  Future<CalendarResult> createCalendar(CreateCalendar calendar);

  Future<void> deleteCalendar(String calendarId);

  Future<List<EventResult>> deleteAllEventsByCalendarId(String calendarId);

  Future<List<CalendarResult>> findAllCalendars();

  Future<EventResult> createEvent(CreateEvent event);

  Future<List<EventResult>> createEvents(Iterable<CreateEvent> events);

  Future<bool> requestPermissions();

  factory CalendarManager() => CalendarManagerImpl();
}

class CalendarManagerImpl implements CalendarManager {
  static const MethodChannel _channel =
      const MethodChannel('rmdy.be/calendar_manager');

  static final CalendarManager _instance = CalendarManagerImpl._();

  CalendarManagerImpl._();

  factory CalendarManagerImpl() => _instance as CalendarManagerImpl;

  ///returns the calendarId
  Future<CalendarResult> createCalendar(CreateCalendar calendar) async {
    await requestPermissionsOrThrow();
    final String json = await _invokeMethod(
        'createCalendar', {"calendar": jsonEncode(calendar)});
    return CalendarResult.fromJson(jsonDecode(json));
  }

  deleteAllEventsByCalendarId(calendarId) async {
    await requestPermissionsOrThrow();
    final String json = await _invokeMethod(
        'deleteAllEventsByCalendarId', {"calendarId": calendarId});
    Iterable results = jsonDecode(json);
    return results.map((e) => EventResult.fromJson(e)).toList();
  }

  Future<T> _invokeMethod<T>(String method, Map<String, dynamic> args) async {
    try {
      final result = await _channel.invokeMethod(method, args);
      return result;
    } on PlatformException catch (ex) {
      throw CalendarManagerException(
          code: parseCalendarManagerErrorCode(ex.code),
          details: ex.details,
          message: ex.message);
    }
  }

  Future<void> deleteCalendar(String calendarId) async {
    await requestPermissionsOrThrow();
    return await _invokeMethod("deleteCalendar", {"calendarId": calendarId});
  }

  Future<List<CalendarResult>> findAllCalendars() async {
    await requestPermissionsOrThrow();
    final String json = await _invokeMethod("findAllCalendars", {});
    Iterable results = jsonDecode(json);
    return results.map((c) => CalendarResult.fromJson(c)).toList();
  }

  Future<void> requestPermissionsOrThrow() async {
    bool granted = await requestPermissions();
    if (!granted) {
      throw CalendarManagerException(
          code: CalendarManagerErrorCode.PERMISSIONS_NOT_GRANTED);
    }
  }

  Future<bool> requestPermissions() async {
    bool granted = await _invokeMethod("requestPermissions", {});
    return granted;
  }

  createEvent(CreateEvent event) async {
    await requestPermissionsOrThrow();
    return _createEvent(event);
  }

  Future<EventResult> _createEvent(CreateEvent event) async {
    final String json =
        await _invokeMethod("createEvent", {"event": jsonEncode(event)});
    return EventResult.fromJson(jsonDecode(json));
  }

  createEvents(events) async {
    await requestPermissionsOrThrow();
    final results = <EventResult>[];
    for (final event in events) {
      final result = await _createEvent(event);
      results.add(result);
    }
    return results;
  }
}
