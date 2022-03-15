import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/survey-bloc/survey.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/utils/read_more.dart';
import 'package:loop_hr/utils/routes.dart';
import 'package:loop_hr/utils/style.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:loop_hr/widgets/adaptive_appbar.dart';

class SurveyListScreen extends StatefulWidget {
  final bool isPoll;
  SurveyListScreen({Key? key, required this.isPoll}) : super(key: key);

  @override
  _SurveyListScreenState createState() => _SurveyListScreenState();
}

class _SurveyListScreenState extends State<SurveyListScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SurveyBloc>(context).add(FetchSurveyEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AdaptiveAppBar(
        null,
        widget.isPoll ? 'Poll' : 'Survey',
        centerTitle: true,
      ),
      body: BlocBuilder<SurveyBloc, SurveyState>(
        builder: (context, state) {
          if (state is SurveyLoaded) {
            List<Survey> list = state.surveyList.where((element) => element.poll == widget.isPoll).toList();
            if (list.isEmpty) {
              return Center(
                child: Text(widget.isPoll ? 'No poll found' : 'No survey found'),
              );
            }
            return BuildSurveyList(
              pollSurveyList: list,
            );
          }
          if (state is SurveyError) {
            return Center(
              child: Text(state.message),
            );
          }
          return Center(child: ActivityIndicator());
        },
      ),
    );
  }
}

class BuildSurveyList extends StatelessWidget {
  final List<Survey> pollSurveyList;
  const BuildSurveyList({Key? key, required this.pollSurveyList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: pollSurveyList.length,
      itemBuilder: (BuildContext context, index) {
        Survey _survey = pollSurveyList[index];
        return GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              surveyDetailScreenRoute,
              arguments: _survey,
            );
          },
          child: Container(
            padding: EdgeInsets.all(16),
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(
                width: 1,
                color: Colors.grey,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ReadMoreText(
                //   _survey.topic,
                //   style: Style.bodyText1.copyWith(
                //     color: Colors.black,
                //     fontWeight: FontWeight.bold,
                //     overflow: TextOverflow.ellipsis
                //   ),
                //   trimLines: 3,
                //   textScaleFactor: 1.0,
                //   trimMode: TrimMode.Line,
                //   colorClickableText: Colors.blue,
                // ),
                ReadMore.readMore(_survey.topic),
                SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  'Start Date:',
                                  textScaleFactor: 1.0,
                                  style: Style.bodyText2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 11,
                                child: Text(
                                  _survey.formattedStartDate(),
                                  textScaleFactor: 1.0,
                                  style: Style.bodyText2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Text(
                                  'End Date:',
                                  textScaleFactor: 1.0,
                                  style: Style.bodyText2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 11,
                                child: Text(
                                  _survey.formattedEndDate(),
                                  textScaleFactor: 1.0,
                                  style: Style.bodyText2.copyWith(
                                    color: Colors.black54,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.arrow_right,
                        size: 30,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
