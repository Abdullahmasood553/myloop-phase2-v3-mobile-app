import 'package:flutter/material.dart';
import 'package:loop_hr/utils/system_util.dart';

class LeaveRequestFooter extends StatelessWidget {
  final VoidCallback onSubmit;

  const LeaveRequestFooter({Key? key, required this.onSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton(
          onPressed: () async {
            bool? result = await SystemUtil.showFormDismissDialog(context);
            if (result) {
              Navigator.pop(context);
            }
          },
          child: Text(
            'Cancel',
            textScaleFactor: 1,
          ),
        ),
        ElevatedButton(
          onPressed: this.onSubmit,
          child: Text(
            'Submit',
            textScaleFactor: 1,
          ),
        ),
      ],
    );
  }
}
