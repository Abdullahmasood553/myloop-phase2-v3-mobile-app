import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loop_hr/utils/utils.dart';

class AdaptiveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? imagePath;
  final List<Widget> actions;
  final bool centerTitle;
  final bool automaticallyImplyLeading;

  AdaptiveAppBar(
    this.imagePath,
    this.title, {
    this.actions = const [],
    this.centerTitle = true,
    this.automaticallyImplyLeading = true,
  });

  @override
  Widget build(BuildContext context) {
    print(automaticallyImplyLeading);
    if (Platform.isIOS) {
      return CupertinoNavigationBar(
        padding: EdgeInsetsDirectional.only(start: 8, end: 8),
        backgroundColor: Style.bgAppBar,
        automaticallyImplyLeading: automaticallyImplyLeading,
        middle: _titleWidget(),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (actions.isNotEmpty) ...actions,
          ],
        ),
      );
    }
    return AppBar(
      title: _titleWidget(),
      elevation: 0.5,
      iconTheme: IconThemeData(
        color: Colors.white, //change your color here
      ),
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: Style.bgAppBar,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  Widget _titleWidget() {
    if (imagePath != null) {
      return Container(
        margin: EdgeInsets.only(bottom: 2),
        child: Image.asset(
          imagePath!,
          width: 80,
          height: 55,
        ),
      );
    }
    return Text(
      title,
      style: Style.headline6.copyWith(
        color: Colors.white,
      ),
      textScaleFactor: 1.0,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
