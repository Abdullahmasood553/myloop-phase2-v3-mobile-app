import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loop_hr/utils/utils.dart';

class SplashScreen extends StatefulWidget {
  final bool isRouteToWalkThrough;

  const SplashScreen({Key? key, this.isRouteToWalkThrough = true}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  Timer? _timer;
  startTime() async {
    _timer = Timer(Duration(seconds: 3), navigationPage);
    return _timer;
  }

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
    }

    if (widget.isRouteToWalkThrough) {
      startTime();
    }
  }

  void navigationPage() {
    Navigator.pushNamed(context, walkThroughScreenRoute);
  }

  @override
  void dispose() {
    super.dispose();
    if (Platform.isAndroid) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    }  
    _timer?.cancel();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff2B3747),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Image.asset(
                appSplashIcon,
                height: 350,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                margin: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset(
                      octansIcon,
                      height: 50,
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Image.asset(
                      printkraftLogoIcon,
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
