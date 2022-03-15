import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_event.dart';
import 'package:loop_hr/blocs/survey-bloc/survey.dart';
import 'package:loop_hr/models/answer_response.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/models/survey_response.dart';
import 'package:loop_hr/utils/read_more.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';


class SurveyDetailScreen extends StatefulWidget {
  final Survey survey;

  SurveyDetailScreen({Key? key, required this.survey}) : super(key: key);

  @override
  _SurveyDetailScreenState createState() => _SurveyDetailScreenState();
}

class _SurveyDetailScreenState extends State<SurveyDetailScreen> {
  bool? isActive;
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;
  bool isChecked = false;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<int, bool> _multiCheckSelectValues = {};
  Map<String, dynamic> _requestBody = {};
  Choice? selectedChoice;
  SurveyResponse? surveyResponse;
  List<AnswerResponse> answerList = [];

  void validate() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      context.loaderOverlay.show();
      BlocProvider.of<SurveyBloc>(context).add(CreateSurveyRequest(_requestBody));
    } else {
      print("Not Validated");
    }
  }

  bool isValid(Question question) {
    if (question.questionType == 4) {
      if (_multiCheckSelectValues.isEmpty) {
        SystemUtil.buildErrorSnackbar(context, "Field cannot be empty");
        return false;
      } else {
        for (int key in _multiCheckSelectValues.keys) {
          AnswerResponse answerResponse = new AnswerResponse(oidQuestion: question.oid, oidChoice: key);
          answerList.add(answerResponse);
        }
        return true;
      }
    } else {
      if (selectedChoice == null) {
        SystemUtil.buildErrorSnackbar(context, "Field cannot be empty");
        return false;
      } else {
        AnswerResponse answerResponse = new AnswerResponse(oidQuestion: question.oid, oidChoice: selectedChoice!.oid);
        answerList.add(answerResponse);
        return true;
      }
    }
  }

  Widget buildDotIndicator(List<Question> questionList) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i <= questionList.length - 1; i++) i == pageChanged ? sDDotIndicator(isActive: true) : sDDotIndicator(isActive: false),
      ],
    );
  }

  Widget sDDotIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF015294) : Color(0xFF015294).withOpacity(.4),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        widget.survey.poll ? 'Poll Detail' : 'Survey Detail',
      ),
      body: LoaderOverlay(
        overlayWidget: ActivityIndicator(),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              child: SvgPicture.asset(
                welcomeScreenSvgIcon,
                semanticsLabel: 'dashboard',
                width: double.infinity,
                height: double.infinity,
                fit: BoxFit.fill,
              ),
            ),
            SafeArea(
              top: false,
              child: BlocListener<SurveyBloc, SurveyState>(
                listener: (context, state) {
                  if (state is CreateSurveySuccess) {
                    BlocProvider.of<NotificationCounterBloc>(context).add(FetchNotificationCounter());
                    context.loaderOverlay.hide();
                    SystemUtil.buildSuccessSnackbar(
                      context,
                      state.message,
                    );
                    Navigator.pop(context, true);
                  } else if (state is CreateSurveyError) {
                    context.loaderOverlay.hide();
                    SystemUtil.buildErrorSnackbar(
                      context,
                      state.message,
                    );
                  }
                },
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Container(
                        color: Color(0xFFe4e9ed),
                        padding: EdgeInsets.all(16),
                        width: double.infinity,
                        child: ReadMore.readMore(
                          widget.survey.topic,
                        ),
                      ),
                      Expanded(
                        child: PageView(
                          physics: NeverScrollableScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() {
                              pageChanged = index;
                            });
                          },
                          controller: pageController,
                          children: widget.survey.questionList.map((e) => _buildQuestionListItem(e)).toList(),
                        ),
                      ),
                      buildDotIndicator(widget.survey.questionList),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionListItem(Question q) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16),
            child: ReadMore.readMore(
              q.questionStatement,
            ),
          ),
          ListView.builder(
            itemCount: q.choiceList.length,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (q.questionType == 4) {
                return _buildMultiChoiceListItem(q, q.choiceList[index]);
              } else {
                return _buildSingleChoiceListItem(q, q.choiceList[index]);
              }
            },
          ),
          Container(
            alignment: Alignment.center,
            child: ElevatedButton(
              child: Text(
                widget.survey.questionList.length - 1 == pageChanged ? 'Submit' : 'Next',
                textScaleFactor: 1,
              ),
              onPressed: () {
                if (pageChanged != q.questionStatement.length) {
                  if (isValid(q)) {
                    selectedChoice = null;
                    _multiCheckSelectValues.clear();
                    _requestBody['oidSurvey'] = widget.survey.oid;
                    _requestBody['answerList'] = answerList;
                    if (pageChanged == widget.survey.questionList.length - 1) {
                      validate();
                    } else {
                      pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                    }
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMultiChoiceListItem(Question q, Choice c) {
    return CheckboxListTile(
      title: Text(
        c.choiceStatement,
        textScaleFactor: 1.0,
      ),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: Style.primaryColor,
      value: _multiCheckSelectValues[c.oid] != null ? _multiCheckSelectValues[c.oid] : false,
      onChanged: (bool? value) {
        setState(
          () {
            value! ? _multiCheckSelectValues[c.oid] = value : _multiCheckSelectValues.remove(c.oid);
          },
        );
      },
    );
  }

  Widget _buildSingleChoiceListItem(Question q, Choice c) {
    return RadioListTile(
      title: Text(
        c.choiceStatement,
        textScaleFactor: 1.0,
      ),
      value: c,
      activeColor: Style.primaryColor,
      groupValue: selectedChoice,
      onChanged: (Choice? value) {
        setState(
          () {
            selectedChoice = value!;
          },
        );
      },
    );
  }
}
