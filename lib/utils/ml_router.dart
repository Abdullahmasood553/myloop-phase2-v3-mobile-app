import 'package:flutter/material.dart';
import 'package:loop_hr/models/models.dart';
import 'package:loop_hr/models/otp_response.dart';
import 'package:loop_hr/models/push_notification_argument.dart';
import 'package:loop_hr/models/survey.dart';
import 'package:loop_hr/screens/absence_list_screen.dart';
import 'package:loop_hr/screens/absence_screen.dart';
import 'package:loop_hr/screens/create_leave_screen.dart';
import 'package:loop_hr/screens/create_outdoor_screen.dart';
import 'package:loop_hr/screens/home_screen.dart';
import 'package:loop_hr/screens/login_screen.dart';
import 'package:loop_hr/screens/notification_detail_screen.dart';
import 'package:loop_hr/screens/notification_screen.dart';
import 'package:loop_hr/screens/otp_screen.dart';
import 'package:loop_hr/screens/outdoor_duty_list_screen.dart';
import 'package:loop_hr/screens/outdoor_screen.dart';
import 'package:loop_hr/screens/pay_slip_detail_screen.dart';
import 'package:loop_hr/screens/pay_slip_screen.dart';
import 'package:loop_hr/screens/request_information_screen.dart';
import 'package:loop_hr/screens/splash_screen.dart';
import 'package:loop_hr/screens/survey_detail_screen.dart';
import 'package:loop_hr/screens/survey_list_screen.dart';
import 'package:loop_hr/screens/time_log_screen.dart';
import 'package:loop_hr/screens/walk_through_screen.dart';
import 'package:loop_hr/utils/routes.dart';

class MlRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splashScreenRoute:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case walkThroughScreenRoute:
        return MaterialPageRoute(builder: (_) => WalkThroughScreen());
      case loginScreenRoute:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case homeScreenRoute:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case absenceScreenRoute:
        return MaterialPageRoute(builder: (_) => AbsenceScreen());
      case paySlipScreenRoute:
        return MaterialPageRoute(builder: (_) => PayslipScreen());
      case surveyListScreenRoute:
        return MaterialPageRoute(builder: (_) => SurveyListScreen(isPoll: false));
      case pollListScreenRoute:
        return MaterialPageRoute(builder: (_) => SurveyListScreen(isPoll: true));
      case surveyDetailScreenRoute:
        Survey survey = settings.arguments as Survey;
        return MaterialPageRoute(builder: (_) => SurveyDetailScreen(survey: survey));
      case paySlipScreenDetailRoute:
        PaySlip paySlip = settings.arguments as PaySlip;
        return MaterialPageRoute(builder: (_) => PaySlipDetailScreen(slip: paySlip));
      case attendanceListScreenRoute:
        return MaterialPageRoute(builder: (_) => TimeLogScreen());
      case outdoorListScreenRoute:
        return MaterialPageRoute(builder: (_) => OutdoorDutyListScreen());
      case otpScreenRoute:
        OtpResponse otpResponse = settings.arguments as OtpResponse;
        return MaterialPageRoute(builder: (_) => GenerateOTPScreen(otpResponse: otpResponse));
      case createOutDoorDutyScreenRoute:
        return MaterialPageRoute(builder: (_) => OutdoorDutyCreateScreen());
      case outdoorScreenRoute:
        return MaterialPageRoute(builder: (_) => OutDoorScreen());
      case leaveRequestScreenRoute:
        return MaterialPageRoute(builder: (_) => AbsenceListScreen());
      case createAbsenceFormScreenRoute:
        return MaterialPageRoute(builder: (_) => AbsenceFormScreen());
      case notificationsScreenRoute:
        bool backButtonVisible = settings.arguments as bool;
        return MaterialPageRoute(builder: (_) => NotificationScreen(backButtonVisible: backButtonVisible));
      case notificationDetailScreenRoute:
        PushNotificationArgument pushNotificationRoute = settings.arguments as PushNotificationArgument;
        return MaterialPageRoute(builder: (_) => PushNotificationDetailScreen(argument: pushNotificationRoute));
      default:
        return MaterialPageRoute(
          builder: (_) => SplashScreen(isRouteToWalkThrough: false),
        );
    }
  }
}
