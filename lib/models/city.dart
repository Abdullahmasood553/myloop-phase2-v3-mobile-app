import 'package:json_annotation/json_annotation.dart';
part 'city.g.dart';

@JsonSerializable()
class City {
  final int oid;
  final String name;

  City({
    required this.oid,
    required this.name,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);
}
