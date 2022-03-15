import 'package:json_annotation/json_annotation.dart';
part 'ta_da_lookups.g.dart';
@JsonSerializable()

class TADALookups {
  final String flexValueSetName;
  final String flexValue;

  TADALookups({
    required this.flexValueSetName, required this.flexValue
  });

  factory TADALookups.fromJson(Map<String, dynamic> json) => _$TADALookupsFromJson(json);
  Map<String, dynamic> toJson() => _$TADALookupsToJson(this);
}