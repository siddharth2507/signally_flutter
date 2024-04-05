// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'news_aggr.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NewsAggr _$NewsAggrFromJson(Map<String, dynamic> json) => NewsAggr()
  ..id = json['id'] as String? ?? ''
  ..name = json['name'] as String? ?? ''
  ..data = (json['data'] as List<dynamic>?)
          ?.map((e) => News.fromJson(e as Map<String, dynamic>))
          .toList() ??
      [];

Map<String, dynamic> _$NewsAggrToJson(NewsAggr instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'data': instance.data.map((e) => e.toJson()).toList(),
    };

News _$NewsFromJson(Map<String, dynamic> json) => News()
  ..image = json['image'] as String? ?? ''
  ..site = json['site'] as String? ?? ''
  ..symbol = json['symbol'] as String? ?? ''
  ..text = json['text'] as String? ?? ''
  ..url = json['url'] as String? ?? ''
  ..publishedDate = parseToDateTime(json['publishedDate']);

Map<String, dynamic> _$NewsToJson(News instance) => <String, dynamic>{
      'image': instance.image,
      'site': instance.site,
      'symbol': instance.symbol,
      'text': instance.text,
      'url': instance.url,
      'publishedDate': parseToDateTime(instance.publishedDate),
    };
