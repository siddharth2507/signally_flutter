import 'package:json_annotation/json_annotation.dart';

import '_parsers.dart';

part 'announcement_aggr.g.dart';

@JsonSerializable(explicitToJson: true)
class AnnouncementAggr {
  @JsonKey(defaultValue: '', name: 'id')
  String id;
  @JsonKey(defaultValue: [], name: 'data')
  List<Announcement> data;

  AnnouncementAggr()
      : id = '',
        data = [];

  factory AnnouncementAggr.fromJson(Map<String, dynamic> json) => _$AnnouncementAggrFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementAggrToJson(this)..remove('id');
}

@JsonSerializable(explicitToJson: true)
class Announcement {
  @JsonKey(defaultValue: '')
  String id;
  @JsonKey(defaultValue: '')
  String image;
  @JsonKey(defaultValue: '')
  String title;
  @JsonKey(defaultValue: '')
  String link;
  @JsonKey(defaultValue: '')
  String body;
  @JsonKey(fromJson: parseToDateTime, toJson: parseToDateTime)
  DateTime? timestampCreated;

  Announcement()
      : id = '',
        image = '',
        title = '',
        link = '',
        body = '',
        timestampCreated = null;

  factory Announcement.fromJson(Map<String, dynamic> json) => _$AnnouncementFromJson(json);
  Map<String, dynamic> toJson() => _$AnnouncementToJson(this)
    ..remove('id')
    ..remove('timestampCreated');
}
