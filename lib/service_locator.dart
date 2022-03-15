import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:loop_hr/blocs/absence-bloc/absence.dart';
import 'package:loop_hr/blocs/headline-notification-bloc/headline_notification_bloc.dart';
import 'package:loop_hr/blocs/login-bloc/login.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/notification-information-bloc/notification_information.dart';
import 'package:loop_hr/blocs/outdoor-duty/outdoor.dart';
import 'package:loop_hr/blocs/payslip-bloc/payslip.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification.dart';
import 'package:loop_hr/blocs/survey-bloc/survey.dart';
import 'package:loop_hr/blocs/time-log-bloc/time_log.dart';
import 'package:loop_hr/clients/api_clients/absence_api_client.dart';
import 'package:loop_hr/clients/api_clients/api_base_helper.dart';
import 'package:loop_hr/clients/api_clients/api_clients.dart';
import 'package:loop_hr/clients/api_clients/attendance_type_api_client.dart';
import 'package:loop_hr/clients/api_clients/city_api_client.dart';
import 'package:loop_hr/clients/api_clients/leave_balance_api_client.dart';
import 'package:loop_hr/clients/api_clients/outdoor_api_client.dart';
import 'package:loop_hr/clients/api_clients/survey_api_client.dart';
import 'package:loop_hr/clients/api_clients/ta_ta_lookups_api_client.dart';
import 'package:loop_hr/models/user.dart';
import 'package:loop_hr/repositories/attendance_type_repository.dart';
import 'package:loop_hr/repositories/city_repository.dart';
import 'package:loop_hr/repositories/leave_balance_repository.dart';
import 'package:loop_hr/repositories/login_repository.dart';
import 'package:loop_hr/repositories/outdoor_repository.dart';
import 'package:loop_hr/repositories/repositories.dart';
import 'package:loop_hr/repositories/survey_repository.dart';
import 'package:loop_hr/repositories/ta_da_lookups_repository.dart';
import 'package:loop_hr/repositories/time_log_repository.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

import 'blocs/authentication-bloc/authentication_bloc.dart';
import 'blocs/leave-balance-bloc/leave_balance_bloc.dart';

final GetIt locator = GetIt.instance;

Future<void> registerLocator() async {
  //Register Hive User Box
  final appDocumentDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  Hive.registerAdapter<User>(UserAdapter());
  var userBox = await Hive.openBox<User>('user',
      compactionStrategy: (int total, int deleted) {
    return deleted > 20;
  });
  userBox = Hive.box('user');
  locator.registerLazySingleton(() => userBox);

  //Register Data Sources
  locator.registerLazySingleton<ApiBaseHelper>(() => ApiBaseHelper(locator()));
  locator.registerLazySingleton<PayslipApiClient>(
      () => PayslipApiClient(locator(), locator()));
  locator.registerLazySingleton(
      () => PushNotificationApiClient(locator(), locator()));
  locator.registerLazySingleton(() => TimeLogApiClient(locator(), locator()));
  locator.registerLazySingleton(() => LoginApiClient(locator(), locator()));
  locator.registerLazySingleton(() => OutDoorApiClient(locator(), locator()));
  locator.registerLazySingleton(() => AbsenceApiClient(locator(), locator()));
  locator
      .registerLazySingleton(() => LeaveBalanceApiClient(locator(), locator()));
  locator.registerLazySingleton(
      () => AttendanceTypeApiClient(locator(), locator()));
  locator.registerLazySingleton(() => CityApiClient(locator(), locator()));
  locator.registerLazySingleton(() => SurveyApiClient(locator(), locator()));

  locator
      .registerLazySingleton(() => TADALookupsApiClient(locator(), locator()));

  //Register Repositories
  locator.registerLazySingleton(() => PayslipRepository(locator()));
  locator.registerLazySingleton(() => PushNotificationRepository(locator()));
  locator.registerLazySingleton(() => TimeLogRepository(locator()));
  locator.registerLazySingleton(() => LoginRepository(locator()));
  locator.registerLazySingleton(() => OutDoorRepository(locator()));
  locator.registerLazySingleton(() => AbsenceRepository(locator()));
  locator.registerLazySingleton(() => LeaveBalanceRepository(locator()));
  locator.registerLazySingleton(() => AttendanceTypeRepository(locator()));
  locator.registerLazySingleton(() => CityRepository((locator())));

  locator.registerLazySingleton(() => SurveyRepository((locator())));
  locator.registerLazySingleton(() => TADALookupsRepository((locator())));

  //Register Blocs
  locator.registerLazySingleton(() => AuthenticationBloc(locator()));
  locator.registerLazySingleton(() => PayslipBloc(locator(), locator()));
  locator
      .registerLazySingleton(() => PushNotificationBloc(locator(), locator()));
  locator.registerLazySingleton(() => NotificationCounterBloc(locator()));
  locator.registerLazySingleton(() => HeadlineNotificationBloc(locator()));
  locator.registerLazySingleton(() => TimeLogBloc(locator(), locator()));
  locator.registerLazySingleton(() => LoginBloc(locator()));
  locator.registerLazySingleton(() => OutDoorBloc(locator(), locator()));
  locator.registerLazySingleton(() => AbsenceBloc(locator(), locator()));
  locator.registerLazySingleton(() => LeaveBalanceBloc(locator(), locator()));
  locator.registerLazySingleton(() => SurveyBloc(locator()));
  locator.registerLazySingleton(() => NotificationInformationBloc(locator()));

  locator.registerLazySingleton(() => http.Client());
}
