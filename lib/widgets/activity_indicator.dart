import 'package:flutter/material.dart';
import 'package:loop_hr/utils/utils.dart';

class ActivityIndicator extends StatelessWidget {
  const ActivityIndicator({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator.adaptive(
      valueColor: AlwaysStoppedAnimation<Color>(Style.primaryColor),
    );
  }
}
