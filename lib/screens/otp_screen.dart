import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:loop_hr/blocs/authentication-bloc/authentication.dart';
import 'package:loop_hr/blocs/login-bloc/login.dart';
import 'package:loop_hr/models/otp_response.dart';
import 'package:loop_hr/utils/icon_util.dart';
import 'package:loop_hr/utils/utils.dart';
import 'package:loop_hr/widgets/activity_indicator.dart';
import 'package:pinput/pin_put/pin_put.dart';

class GenerateOTPScreen extends StatefulWidget {
  final OtpResponse otpResponse;
  GenerateOTPScreen({Key? key, required this.otpResponse}) : super(key: key);

  @override
  GenerateOTPState createState() => GenerateOTPState();
}

class GenerateOTPState extends State<GenerateOTPScreen> {
  BoxDecoration get _pinPutDecoration {
    return BoxDecoration(
      border: Border.all(color: Colors.blue),
      borderRadius: BorderRadius.circular(15.0),
    );
  }

  _showSnackBar(pin) {
    if (pin == widget.otpResponse.otp) {
      print(widget.otpResponse.otp);
      BlocProvider.of<LoginBloc>(context).add(Login(widget.otpResponse.toJson()));
    } else {
      SystemUtil.buildErrorSnackbar(context, 'Invalid OTP Code');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController _pinPutController = TextEditingController();
    final FocusNode _pinPutFocusNode = FocusNode();

    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
      ),
      body: LoaderOverlay(
        overlayWidget: ActivityIndicator(),
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccess) {
              context.loaderOverlay.hide();
              context.read<AuthenticationBloc>().add(LoggedInUser());
            } else if (state is LoginError) {
              context.loaderOverlay.hide();
              SystemUtil.buildErrorSnackbar(context, state.response);
            }
          },
          child: SingleChildScrollView(
            child: Container(
              height: height,
              alignment: Alignment.center,
              child: Column(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.deepPurple.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(otpIcon),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Verification',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Enter OTP sent to your registered mobile",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.black38,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Container(
                    color: Colors.white,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(20.0),
                    child: PinPut(
                      fieldsCount: 6,
                      onSubmit: (String pin) => _showSnackBar(pin),
                      focusNode: _pinPutFocusNode,
                      controller: _pinPutController,
                      submittedFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      selectedFieldDecoration: _pinPutDecoration,
                      followingFieldDecoration: _pinPutDecoration.copyWith(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.blue.withOpacity(.5),
                        ),
                      ),
                    ),
                  ),
                  // Text(
                  //   "Didn't you receive any code?",
                  //   style: TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.black38,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  // SizedBox(
                  //   height: 18.0,
                  // ),
                  // Text(
                  //   "Resend New Code",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.blue,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
