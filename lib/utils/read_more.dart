
import 'package:flutter/material.dart';
import 'package:loop_hr/utils/style.dart';
import 'package:readmore/readmore.dart';

class ReadMore {
  static ReadMoreText readMore(String title) {
   return ReadMoreText(
      title,
      style: Style.bodyText1.copyWith(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        overflow: TextOverflow.ellipsis,
      ),
      trimLines: 3,
      textScaleFactor: 1.0,
      trimMode: TrimMode.Line,
      colorClickableText: Colors.blue,
    );
  }
}
