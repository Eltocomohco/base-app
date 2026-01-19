import 'package:freezed_annotation/freezed_annotation.dart';

part 'extra.freezed.dart';
part 'extra.g.dart';

@freezed
abstract class Extra with _$Extra {
  const factory Extra({
    required String id,
    required String name,
    required double price,
    @Default(true) bool available,
  }) = _Extra;

  factory Extra.fromJson(Map<String, dynamic> json) => _$ExtraFromJson(json);
}
