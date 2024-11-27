import 'dart:convert';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:fincalis/screens/ConsentScreen.dart';
import 'package:fincalis/screens/Registration.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';

import '../Services/user_api.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';

class OtpVerifyScreen extends StatefulWidget {
  final String mobileNumber;
  const OtpVerifyScreen({super.key, required this.mobileNumber});

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> {
  final TextEditingController otpController= TextEditingController();
  final FocusNode focusNodeOTP = FocusNode();
  bool _isLoading = false;
  String _verifyMessage="";
  bool recieving =false;

  @override
  void initState() {
    FirebaseAnalytics.instance.logScreenView(screenName: "Verify OTP");
    _listenForSmsCode();
    super.initState();
    
  }


  Future<void>ResendOtp() async {
    await UserApi.ResendOtpApi(widget.mobileNumber
    ).then((data) => {
      if (data != null) {
        setState(() {
          if (data.type == "success") {
            recieving =false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "OTP send Successfully!",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
          }else{
            recieving =false;
          }
        })
      }
    });
  }

  void _listenForSmsCode() async {
    AndroidSmsRetriever.startSmsListener().then((value) {
      setState(() {
        final intRegex = RegExp(r'\d+', multiLine: true);
        final code = intRegex
            .allMatches(value ?? 'Phone Number Not Found')
            .first
            .group(0);
        otpController.text = code ?? 'NO CODE';
        AndroidSmsRetriever.stopSmsListener();
      });
    });
  }

  void _handleSignup() {
    setState(() {
      _isLoading=true;
      _verifyMessage = (otpController.text.length<6 || otpController.text.isEmpty)
          ? "Please enter a valid 6-digit OTP"
          : "";
    });
    if (_verifyMessage=="") {
        Verify_otp();
    } else {
      setState(() {
        _isLoading=false;
      });
    }
  }

  Future<void> Verify_otp() async {
    String? fcmToken = "";
    if (Platform.isAndroid) {
      fcmToken = await FirebaseMessaging.instance.getToken();
    } else if (Platform.isIOS) {
      fcmToken = await FirebaseMessaging.instance.getToken();
    }
      await UserApi.verify_otp(widget.mobileNumber,otpController.text,fcmToken).then((data) => {
        if (data != null)
          {
            setState(() {
              if (data.settings?.success == 1) {
                _isLoading=false;
                PreferenceService().saveString("token", (data.data?.result!.jwtToken!).toString());
                PreferenceService().saveString("user_id", (data.data?.result!.userId!).toString());
                if (data?.data?.result?.user == "Exist") {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyMainHome(),
                    ),
                  );
                } else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Registration(consent_status: data?.data?.result?.user_consent_status??false),
                    ),
                  );
                }

              }else if(data.settings?.success == 0){
                _isLoading=false;
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Please enter a valid 6-digit OTP",
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFFCDE2FB),
                ));
              }
            })
          }
      });
    }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 120),
                  child: Image.asset("assets/logo1.png",
                    width: 230,
                    height: 50,),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Color(0xFFB7E1F8),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "OTP Verification",
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "A 6-digit code is sent to ",
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Flexible(
                                  child: Text(
                                    widget.mobileNumber,
                                    style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 18,
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: Image.asset(
                                    "assets/pen.png",
                                    width: 20,
                                    height: 20,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40),
                            child: Text(
                              "Enter Verification code sent to your mobile",
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          PinCodeTextField(
                            autoUnfocus: true,
                            appContext: context,
                            pastedTextStyle: TextStyle(
                              color:Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                            length: 6,
                            blinkWhenObscuring: true,
                            autoFocus: true,
                            autoDismissKeyboard: false,
                            showCursor: true,
                            animationType: AnimationType.fade,
                            focusNode: focusNodeOTP,
                            hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                            controller: otpController,
                            onTap:(){
                              setState(() {
                                _verifyMessage="";
                              });
                            },
                            onChanged: (v){
                              setState(() {
                                _verifyMessage="";
                              });
                            },
                            pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(50),
                                fieldHeight: 45,
                                fieldWidth: 45,
                                fieldOuterPadding:
                                EdgeInsets.only(left: 0, right: 3),
                                activeFillColor: Color(0xFFF4F4F4),
                                activeColor: Color(0xff2DB3FF),
                                selectedColor: Color(0xff2DB3FF),
                                selectedFillColor: Color(0xFFF4F4F4),
                                inactiveFillColor: Color(0xFFF4F4F4),
                                inactiveColor: Color(0xFFD2D2D2),
                                inactiveBorderWidth: 1.5,
                                selectedBorderWidth: 2.2,
                                activeBorderWidth: 2.2),
                            textStyle: TextStyle(
                                fontFamily: "Inter",
                                fontSize:17,
                                fontWeight: FontWeight.w400),
                            cursorColor:Colors.black,
                            enableActiveFill: true,
                            keyboardType: TextInputType.numberWithOptions(),
                            textInputAction: (Platform.isAndroid)
                                ? TextInputAction.none
                                : TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            enablePinAutofill: true,
                            useExternalAutoFillGroup: true,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                          if (_verifyMessage.isNotEmpty) ...[
                            Center(
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                                width: screenWidth * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _verifyMessage,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color:Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                          Padding(
                            padding: const EdgeInsets.only(top: 24),
                            child: ElevatedButton(
                              onPressed:() {
                                if(_isLoading){

                                }else{
                                  _handleSignup();
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF2DB3FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                              ),
                              child:
                              _isLoading
                                  ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  :Text(
                                "Verify",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Didn’t receive the OTP?",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w400,
                                    color: Color(0xFF4F4F4F),
                                  ),
                                ),
                                SizedBox(width: 4),
                                GestureDetector(
                                  onTap:(){
                                    if(recieving){

                                    }else{
                                      setState(() {
                                        recieving=true;
                                      });
                                      ResendOtp();
                                    }
                                  },
                                  child: Text((recieving)?"Recieving...":"Resend",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF000000),
                                        decoration: TextDecoration.underline),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
