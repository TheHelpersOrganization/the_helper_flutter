import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'interest.g.dart';
part 'interest.freezed.dart';

@freezed
class Interest with _$Interest {
  const factory Interest({
    String? id,
    String? name,
    String? description,
  }) = _Interest;
  factory Interest.fromJson(Map<String, dynamic> json) =>
      _$InterestFromJson(json);
}
