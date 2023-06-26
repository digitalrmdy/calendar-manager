import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

import 'converters/date_json_converter.dart';

part 'models.g.dart';

abstract class _Base extends Equatable {
  const _Base();
  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}

@JsonSerializable(disallowUnrecognizedKeys: true)
@DateJsonConverter()
class CreateEvent extends _Base {
  final String calendarId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;

  const CreateEvent({
    required this.calendarId,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description,
    this.location,
  });

  factory CreateEvent.fromJson(Map<String, dynamic> json) =>
      _$CreateEventFromJson(json);

  Map<String, dynamic> toJson() => _$CreateEventToJson(this);

  @override
  List<Object?> get props =>
      [calendarId, title, description, location, startDate, endDate];
}

@JsonSerializable(disallowUnrecognizedKeys: true)
class CalendarResult extends _Base {
  final String? id;
  final String? name;
  @JsonKey(toJson: toColor24)
  final int? color;
  final bool? isReadOnly;

  const CalendarResult({this.id, this.name, this.color, this.isReadOnly});

  @override
  List<Object?> get props => [id, name, color, isReadOnly];

  factory CalendarResult.fromJson(Map<String, dynamic> json) =>
      _$CalendarResultFromJson(json);

  Map<String, dynamic> toJson() => _$CalendarResultToJson(this);
}

@JsonSerializable()
class CreateCalendar extends _Base {
  final String name;
  @JsonKey(toJson: toColor24)
  final int? color;
  final CreateCalendarAndroidInfo? androidInfo;

  const CreateCalendar({required this.name, this.color, this.androidInfo});

  @override
  List<Object?> get props => [name, color, androidInfo];

  factory CreateCalendar.fromJson(Map<String, dynamic> json) =>
      _$CreateCalendarFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCalendarToJson(this);
}

@JsonSerializable()
class CreateCalendarAndroidInfo extends _Base {
  final String id;

  const CreateCalendarAndroidInfo({required this.id});

  @override
  List<Object> get props => [id];

  factory CreateCalendarAndroidInfo.fromJson(Map<String, dynamic> json) =>
      _$CreateCalendarAndroidInfoFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCalendarAndroidInfoToJson(this);
}

int? toColor24(int? color) {
  if (color == null) return null;
  return color & 0xFFFFFF;
}

@JsonSerializable(disallowUnrecognizedKeys: true)
@DateJsonConverter()
class EventResult extends _Base {
  final String calendarId;
  final String eventId;
  final String title;
  final String? description;
  final String? location;
  final DateTime startDate;
  final DateTime endDate;

  const EventResult({
    required this.calendarId,
    required this.eventId,
    required this.title,
    required this.startDate,
    required this.endDate,
    this.description,
    this.location,
  });

  factory EventResult.fromJson(Map<String, dynamic> json) =>
      _$EventResultFromJson(json);

  Map<String, dynamic> toJson() => _$EventResultToJson(this);

  @override
  List<Object?> get props =>
      [calendarId, eventId, title, description, location, startDate, endDate];
}
