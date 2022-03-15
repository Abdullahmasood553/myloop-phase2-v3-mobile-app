import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
part 'answer_response.g.dart';

@JsonSerializable()
class AnswerResponse extends Equatable {
  final int oidQuestion;
  final int oidChoice;

  AnswerResponse({required this.oidQuestion, required this.oidChoice});

  factory AnswerResponse.fromJson(Map<String, dynamic> json) => _$AnswerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$AnswerResponseToJson(this);

  @override
  List<Object?> get props => [oidQuestion, oidChoice];
}
