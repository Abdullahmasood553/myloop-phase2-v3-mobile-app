import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loop_hr/blocs/absence-bloc/absence.dart';
import 'package:loop_hr/blocs/login-bloc/login.dart';
import 'package:loop_hr/blocs/my_loop_bloc_delegate.dart';
import 'package:loop_hr/blocs/notification-counter-bloc/notification_counter_bloc.dart';
import 'package:loop_hr/blocs/outdoor-duty/outdoor_bloc.dart';
import 'package:loop_hr/blocs/push-notification-bloc/push_notification_bloc.dart';
import 'package:loop_hr/blocs/survey-bloc/survey_bloc.dart';
import 'package:loop_hr/blocs/time-log-bloc/time_log.dart';
import 'package:loop_hr/repositories/attendance_type_repository.dart';
import 'package:loop_hr/repositories/city_repository.dart';
import 'package:loop_hr/repositories/push_notification_repository.dart';
import 'package:loop_hr/repositories/ta_da_lookups_repository.dart';
import 'package:loop_hr/service_locator.dart';
import 'package:loop_hr/utils/ml_router.dart';

import 'blocs/authentication-bloc/authentication.dart';
import 'blocs/headline-notification-bloc/headline_notification_bloc.dart';
import 'blocs/leave-balance-bloc/leave_balance_bloc.dart';
import 'blocs/notification-information-bloc/notification_information_bloc.dart';
import 'blocs/payslip-bloc/payslip.dart';
import 'repositories/login_repository.dart';
import 'utils/utils.dart';

// Receive message when app is in background solution for on message
Future<void> backgroundHandler(RemoteMessage message) async {
  print(message.data.toString());
  print(message.notification!.title);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await registerLocator();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(backgroundHandler);
  BlocOverrides.runZoned(
    () {
      runApp(MyApp());
    },
    blocObserver: MyLoopBlocDelegate(),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => locator<LoginRepository>()),
        RepositoryProvider(create: (_) => locator<AttendanceTypeRepository>()),
        RepositoryProvider(create: (_) => locator<CityRepository>()),
        RepositoryProvider(create: (_) => locator<TADALookupsRepository>()),
        RepositoryProvider(create: (_) => locator<PushNotificationRepository>())
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => locator<AuthenticationBloc>()..add(AppStarted())),
          BlocProvider(create: (_) => locator<PayslipBloc>()),
          BlocProvider(create: (_) => locator<PushNotificationBloc>()),
          BlocProvider(create: (_) => locator<HeadlineNotificationBloc>()),
          BlocProvider(create: (_) => locator<NotificationCounterBloc>()),
          BlocProvider(create: (_) => locator<TimeLogBloc>()),
          BlocProvider(create: (_) => locator<LoginBloc>()),
          BlocProvider(create: (_) => locator<OutDoorBloc>()),
          BlocProvider(create: (_) => locator<AbsenceBloc>()),
          BlocProvider(create: (_) => locator<LeaveBalanceBloc>()),
          BlocProvider(create: (_) => locator<SurveyBloc>()),
          BlocProvider(create: (_) => locator<NotificationInformationBloc>())
        ],
        child: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  NavigatorState get _navigator => _navigatorKey.currentState!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'loophr',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      color: Style.primaryColor,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: Style.textTheme,
        colorSchemeSeed: Style.primaryColor,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black),
          elevation: 1.0,
          color: Colors.white,
          titleTextStyle: Style.headline6.copyWith(
            color: Style.textPrimaryColor,
          ),
          centerTitle: true,
        ),
        // primaryColor: Style.primaryColor,
        cupertinoOverrideTheme: CupertinoThemeData(
          primaryColor: Colors.white,
        ),
      ),
      navigatorKey: _navigatorKey,
      onGenerateRoute: MlRouter.generateRoute,
      builder: (context, child) {
        return BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is AuthenticationAuthenticated) {
              _navigator.pushNamedAndRemoveUntil(homeScreenRoute, (route) => false);
              // _navigator.pushNamedAndRemoveUntil(splashScreenRoute, (route) => false);
              // _navigator.pushNamedAndRemoveUntil(loginScreenRoute, (route) => false);
            } else if (state is AuthenticationUnauthenticated) {
              _navigator.pushNamedAndRemoveUntil(splashScreenRoute, (route) => false);
            }
          },
          child: child,
        );
      },
    );
  }
}
