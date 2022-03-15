import 'package:json_annotation/json_annotation.dart';
import 'package:loop_hr/models/date_time_epoch_converter.dart';
import 'package:loop_hr/utils/date_util.dart';

part 'survey.g.dart';

@JsonSerializable()
@DateTimeEpochConverter()
class Survey {
  final int oid;
  final String topic;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime creationDate;
  final bool active;
  final bool poll;
  List<Question> questionList;

  List<Question> getSortedQuestions() {
    questionList.sort((q1, q2) => q1.oid.compareTo(q2.oid));
    return questionList;
  }

  //
  // @JsonKey(
  //   fromJson: DateUtil.dateTimeFromEpochUsNullable,
  //   toJson: DateUtil.dateTimeToEpochUsNullable,
  // )

  String formattedStartDate() => DateUtil.defaultDateFormat.format(startDate);
  String formattedEndDate() => DateUtil.defaultDateFormat.format(endDate);

  Survey({
    required this.oid,
    required this.topic,
    required this.startDate,
    required this.endDate,
    required this.creationDate,
    required this.active,
    required this.poll,
    required this.questionList,
  });

  factory Survey.fromJson(Map<String, dynamic> json) => _$SurveyFromJson(json);

  Map<String, dynamic> toJson() => _$SurveyToJson(this);
}

@JsonSerializable()
class Question {
  final int oid;
  final int oidSurvey;
  final int questionType;
  final String questionStatement;
  final int sortOrder;
  List<Choice> choiceList;

  Question({
    required this.oid,
    required this.oidSurvey,
    required this.questionType,
    required this.questionStatement,
    required this.sortOrder,
    required this.choiceList,
  });

  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Choice {
  final int oid;
  final int oidQuestion;
  final String choiceStatement;

  Choice({
    required this.oid,
    required this.oidQuestion,
    required this.choiceStatement,
  });
  factory Choice.fromJson(Map<String, dynamic> json) => _$ChoiceFromJson(json);
  Map<String, dynamic> toJson() => _$ChoiceToJson(this);
}
