import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loop_hr/utils/utils.dart';

class WalkThroughScreen extends StatefulWidget {
  @override
  _WalkThroughScreenState createState() => _WalkThroughScreenState();
}

class _WalkThroughScreenState extends State<WalkThroughScreen> {
  bool? isActive;
  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;

  List<Widget> buildDotIndicator() {
    List<Widget> list = [];
    for (int i = 0; i <= 3; i++) {
      list.add(i == pageChanged ? sDDotIndicator(isActive: true) : sDDotIndicator(isActive: false));
    }

    return list;
  }

  Widget sDDotIndicator({required bool isActive}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 6.0,
      width: 6.0,
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF015294) : Color(0xFF015294).withOpacity(.4),
        borderRadius: BorderRadius.all(Radius.circular(50)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Container(
              height: size.height,
              child: PageView(
                onPageChanged: (index) {
                  setState(() {
                    pageChanged = index;
                  });
                },
                controller: pageController,
                children: <Widget>[
                  BackgroundWidget(
                    bgIconName: welcomeScreenSvgIcon,
                    iconName: welcomeSvgIcon,
                    title: 'Welcome',
                    description: 'loophr your personal HR assistance.',
                    // description: 'Welcome to loophr \nyour personal HR assistance.',
                  ),
                  BackgroundWidget(
                    bgIconName: leaveScreenSvgIcon,
                    iconName: leaveSvgIcon,
                    title: 'Leave Applications',
                    description: 'You can submit your leave applications \nand get instant feedback.',
                  ),
                  BackgroundWidget(
                    bgIconName: payslipScreenSvgIcon,
                    iconName: payslipSvgIcon,
                    title: 'Payslip',
                    description: 'You can view your pay',
                  ),
                  BackgroundWidget(
                    bgIconName: notificationScreenSvgIcon,
                    iconName: notificationSvgIcon,
                    title: 'Notifications',
                    description: 'You can receive all HR related \nnotifications on your phone.',
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 50,
              child: Container(
                width: size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, loginScreenRoute);
                      },
                      child: Container(
                        margin: EdgeInsets.all(8),
                        child: Text(
                          "SKIP",
                          textScaleFactor: 1.0,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.openSans(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF575756),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: buildDotIndicator(),
                    ),
                    Container(
                      child: InkWell(
                        child: Icon(
                          Icons.play_arrow,
                          color: Color(0xFF015294),
                          size: 36,
                        ),
                        onTap: () {
                          if (pageChanged != 3) {
                            pageController.nextPage(duration: Duration(milliseconds: 250), curve: Curves.easeInOut);
                          } else {
                            Navigator.pushNamed(context, loginScreenRoute);
                          }
                        },
                      ),
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

class BackgroundWidget extends StatelessWidget {
  final String bgIconName;
  final String iconName;
  final String title;
  final String description;

  const BackgroundWidget({
    required this.bgIconName,
    required this.iconName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Stack(
      children: [
        Container(
          width: double.infinity,
          child: SvgPicture.asset(
            bgIconName,
            semanticsLabel: title,
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
        ),
        CenterWidget(
          iconName: iconName,
          title: title,
          description: description,
        ),
      ],
    );
  }
}

class CenterWidget extends StatelessWidget {
  final String iconName;
  final String title;
  final String description;

  const CenterWidget({
    required this.iconName,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Align(
      alignment: Alignment.center,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            // color: Colors.amber,
            child: SvgPicture.asset(
              iconName,
              semanticsLabel: title,
              width: size.width * .6,
              height: size.width * .5,
            ),
          ),
          SizedBox(height: 40),
          Text(
            title,
            textAlign: TextAlign.center,
            textScaleFactor: 1.0,
            style: GoogleFonts.quicksand(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Color(0xFF005296),
            ),
          ),
          SizedBox(height: 6),
          Text(
            description,
            textScaleFactor: 1.0,
            textAlign: TextAlign.center,
            style: Style.bodyText2.copyWith(
              fontWeight: FontWeight.bold,
              color: Color(0xFF858585),
            ),
          ),
        ],
      ),
    );
  }
}
