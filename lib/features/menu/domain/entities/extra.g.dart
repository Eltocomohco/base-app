// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'extra.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Extra _$ExtraFromJson(Map<String, dynamic> json) => _Extra(
  id: json['id'] as String,
  name: json['name'] as String,
  price: (json['price'] as num).toDouble(),
  available: json['available'] as bool? ?? true,
);

Map<String, dynamic> _$ExtraToJson(_Extra instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'price': instance.price,
  'available': instance.available,
};
