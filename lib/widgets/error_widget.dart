import 'package:flutter/material.dart';

class MLErrorWidget extends StatelessWidget {
  final String title;
  final VoidCallback onPress;

  const MLErrorWidget({Key? key, required this.title, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _titleWidget(),
          SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: onPress,
            icon: Icon(
              Icons.refresh,
            ),
            label: Text(
              'Try Again',
              textScaleFactor: 1,
            ),
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              elevation: 0.0,
              fixedSize: Size.fromWidth(double.maxFinite),
              padding: EdgeInsets.all(16),
            ),
          )
        ],
      ),
    );
  }

  Text _titleWidget() {
    return Text(
      title,
      textScaleFactor: 1.0,
    );
  }
}
