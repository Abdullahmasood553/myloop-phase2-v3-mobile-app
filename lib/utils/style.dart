import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

BoxDecoration boxDecorations({
  double radius = 8,
  Color color = Colors.transparent,
  Color bgColor = Colors.white,
  var showShadow = false,
}) {
  return BoxDecoration(
    color: bgColor,
    boxShadow: showShadow ? [BoxShadow(color: Style.shadowColor, blurRadius: 10, spreadRadius: 2)] : [BoxShadow(color: Colors.transparent)],
    border: Border.all(color: color),
    borderRadius: BorderRadius.all(Radius.circular(radius)),
  );
}

BoxDecoration boxDecoration({double radius = 80.0, Color backGroundColor = Style.primaryColor, double blurRadius = 8.0, double spreadRadius = 8.0, Color radiusColor = Colors.black12, Gradient? gradient}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    boxShadow: [
      BoxShadow(
        color: radiusColor,
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ],
    color: backGroundColor,
    gradient: gradient,
  );
}

class Style {
  factory Style() {
    return _style;
  }
  static final Style _style = Style._();
  Style._();
  // static const Color primaryColor = Color(0xFF5CAAD5);
  static const Color primaryColor = Color(0xFF2b3847);
  static const Color bgAppBar = Color(0xFF2b3847);
  static const Color logoColor = Color(0xFF2C72AE);

  static Map<int, Color> primaryColorShadeMap = {
    50: Color.fromRGBO(43, 56, 71, .1),
    100: Color.fromRGBO(43, 56, 71, .2),
    200: Color.fromRGBO(43, 56, 71, .3),
    300: Color.fromRGBO(43, 56, 71, .4),
    400: Color.fromRGBO(43, 56, 71, .5),
    500: Color.fromRGBO(43, 56, 71, .6),
    600: Color.fromRGBO(43, 56, 71, .7),
    700: Color.fromRGBO(43, 56, 71, .8),
    800: Color.fromRGBO(43, 56, 71, .9),
    900: Color.fromRGBO(43, 56, 71, 1),
  };

  static MaterialColor primarySwatch = MaterialColor(0xFF5CAAD5, primaryColorShadeMap);

  static const Color shadowColor = Color(0x95E9EBF0);

  static const textPrimaryColor = Color(0xFF000000);
  static const textSecondaryColor = Color(0xFF757575);

  static const Color kBottomNavigationColor = Color(0xffF3F2F4);
  static const Color successColor = Color(0xff28a745);
  static const Color dangerColor = Color(0xffdc3545);

  static TextTheme textTheme = TextTheme(
    headline1: headline1,
    headline2: headline2,
    headline3: headline3,
    headline4: headline4,
    headline5: headline5,
    headline6: headline6,
    subtitle1: subtitle1,
    subtitle2: subtitle2,
    bodyText1: bodyText1,
    bodyText2: bodyText2,
    button: button,
    caption: caption,
    overline: overline,
  );

  static TextStyle headline1 = GoogleFonts.openSans(fontSize: 95, fontWeight: FontWeight.w400, letterSpacing: -1.5);
  static TextStyle headline2 = GoogleFonts.openSans(fontSize: 59, fontWeight: FontWeight.w400, letterSpacing: -0.5);
  static TextStyle headline3 = GoogleFonts.openSans(fontSize: 48, fontWeight: FontWeight.w500);
  static TextStyle headline4 = GoogleFonts.openSans(fontSize: 34, fontWeight: FontWeight.w500, letterSpacing: 0.25);
  static TextStyle headline5 = GoogleFonts.openSans(fontSize: 24, fontWeight: FontWeight.w500);
  static TextStyle headline6 = GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.w600, letterSpacing: 0.15);
  static TextStyle subtitle1 = GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w500, letterSpacing: 0.15);
  static TextStyle subtitle2 = GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.1);
  static TextStyle bodyText1 = GoogleFonts.openSans(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.5);
  static TextStyle bodyText2 = GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 0.25);
  static TextStyle button = GoogleFonts.openSans(fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.25);
  static TextStyle caption = GoogleFonts.openSans(fontSize: 12, fontWeight: FontWeight.w500, letterSpacing: 0.4);
  static TextStyle overline = GoogleFonts.openSans(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 1.5);
}
