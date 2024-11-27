import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/PendingScreen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';
import 'dart:developer' as developer;

import '../utils/ShakeWidget.dart';

class CreditScore extends StatefulWidget {
  const CreditScore({super.key});

  @override
  State<CreditScore> createState() => _CreditScoreState();
}

class _CreditScoreState extends State<CreditScore> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final TextEditingController _creditController = TextEditingController();

  final TextEditingController _creditTransactionID = TextEditingController();
  final TextEditingController _creditTransactionPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  bool getotp=false;
  var setotp=0;
  String transid="";
  String validateOtp="";
  bool CreditOTPverifying = false;
  bool submitting = false;
  bool getOTP = false;

  String _validateCreditTransactionID = "";
  String _validateCreditPassword = "";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      // Check connectivity and get the result
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    if (!mounted) {
      return Future.value(null);
    }

    // Update connection status based on the single ConnectivityResult
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      for (int i = 0; i < _connectionStatus.length; i++) {
        setState(() {
          isDeviceConnected = _connectionStatus[i].toString();
          print("isDeviceConnected:${isDeviceConnected}");
        });
      }
    });
    print('Connectivity changed: $_connectionStatus');
  }

  Future<void> GetCreditScoreOTP() async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.GetCreditScoreOTPApi(Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.status== 1) {
              getotp=false;
              setotp=1;
              transid=data.msg?.tsTransID??"";
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "OTP send to Email/Message Send successfully!",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }else{
              getotp=false;
            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

  Future<void> CreditScoreOTPVerification() async {
    var Userid = await PreferenceService().getString('user_id');
      await UserApi.GetCreditScoreOTPVerificationApi(_creditController.text,transid,Userid!).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success== 1) {
              CreditOTPverifying=false;
              setotp=2;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Credit Report send to Email/Message successfully!",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }else{
              CreditOTPverifying=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "${data.settings?.message}",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }
          });
        }
      });
  }

  void _validateFields() {
    setState(() {
      submitting = true;
      _validateCreditTransactionID = _creditTransactionID.text.isEmpty || _creditTransactionID.text.length<10
          ? "Please enter 10 digits of transactionID recieved to mobile."
          : "";
      _validateCreditPassword = _creditTransactionPassword.text.isEmpty || _creditTransactionPassword.text.length<13
          ? "Please enter 13 digits of password recieved to mobile."
          : "";
    });

    if (_validateCreditTransactionID.isEmpty && _validateCreditPassword.isEmpty) {
      CreditScoreDetailsSubmitting();
    } else {
      setState(() {
        submitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please fill all required fields",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    }
  }

  Future<void> CreditScoreDetailsSubmitting() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.CreditScoreDetailsSubmittingApi(Userid!,_creditTransactionID.text,_creditTransactionPassword.text).then((data) {
      if (data != null) {
        setState(() {
          if (data.settings?.success== 1) {
            submitting = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Credit Report send to Email/Message successfully!",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>Pending()), // Replace with your next screen
            );
          }else{
            submitting = false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "${data.settings?.message}",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
      Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child:
        Container(
          height:height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(image: AssetImage("assets/creditscore-removebg-preview.png")),
              Container(
                padding: EdgeInsets.all(18),
                margin: EdgeInsets.only(bottom: 100,left: 20,right: 20),
                decoration: BoxDecoration(
                  color: Color(0xFFCDE2FB).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if(setotp==0)...[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Get Your Credit Score by OTP",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                        onTap: () {
                          if(getOTP){

                          }else{
                            setState(() {
                              getOTP = true;
                            });
                            GetCreditScoreOTP();
                          }
                        },
                        child: Center(
                          child: Container(
                            width: 150,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Color(0xFF24B0FF),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Center(
                              child: (getOTP)
                                  ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  :
                              Text(
                                "Get OTP",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      ]else if(setotp==1)...[
                      SizedBox(height: 25),
                      Text(
                        "Please enter your OTP received on your mobile for verification to get credit report.",
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 20),
                        PinCodeTextField(
                          autoUnfocus: true,
                          appContext: context,
                          pastedTextStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                          length: 6,
                          blinkWhenObscuring: true,
                          autoFocus: true,
                          autoDismissKeyboard: false,
                          showCursor: true,
                          animationType: AnimationType.fade,
                          hapticFeedbackTypes: HapticFeedbackTypes.heavy,
                          controller:_creditController, // Ensure this controller is still valid
                          pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(50),
                              fieldHeight: 40,
                              fieldWidth: 40,
                              fieldOuterPadding: EdgeInsets.only(left: 0, right: 5),
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
                              fontSize: 17,
                              fontWeight: FontWeight.w400),
                          cursorColor: Colors.black,
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
                        if (validateOtp.isNotEmpty) ...[
                          Center(
                            child: Container(
                              alignment: Alignment.topLeft,
                              margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                              width: width * 0.6,
                              child: ShakeWidget(
                                key: Key("value"),
                                duration: Duration(milliseconds: 700),
                                child: Text(
                                  validateOtp,
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
                            height: 50,
                          ),
                        ],
                      InkWell(
                        onTap: () {
                          if(CreditOTPverifying){

                          }else{
                            setState(() {
                              CreditOTPverifying=true;
                            });
                            if(_creditController.text.length>=6) {
                              CreditScoreOTPVerification();
                            }else{
                              setState(() {
                                validateOtp="Please Enter a valid OTP.";
                                CreditOTPverifying=false;
                              });
                            }
                          }
                        },
                        child: Container(
                          width: width,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Color(0xFF24B0FF),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Center(
                            child:(CreditOTPverifying)
                                ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                :
                            Text(
                              "Continue",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                                fontSize: 20,
                              ),
                            ),
                          ),
                        ),
                      ),
                     ]else...[
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Align(
                             alignment: Alignment.centerLeft,
                             child: Text(
                               "Credit Transaction ID",
                               style: TextStyle(
                                 fontSize: 16,
                                 fontFamily: 'Poppins',
                                 fontWeight: FontWeight.w500,
                                 color: Color(0xFF374151),
                               ),
                             ),
                           ),
                           const SizedBox(height: 4),
                           TextFormField(
                             controller: _creditTransactionID,
                             cursorColor: Colors.black,
                             keyboardType: TextInputType.name,
                             onTap: (){
                               setState(() {
                                 _validateCreditTransactionID="";
                               });
                             },
                             onChanged: (v) {
                               setState(() {
                                 _validateCreditTransactionID="";
                               });
                             },
                             style: TextStyle(
                               fontSize: 16,
                               letterSpacing: 0,
                               height: 1.2,
                               color: Colors.black,
                               fontWeight: FontWeight.w400,
                             ),
                             decoration: InputDecoration(
                               hintText: "Enter credit transactionID recieved in mobile number.",
                               hintStyle: TextStyle(
                                 fontSize: 13,
                                 letterSpacing: 0,
                                 height: 1.2,
                                 color: Color(0xffAFAFAF),
                                 fontFamily: 'Poppins',
                                 fontWeight: FontWeight.w400,
                               ),
                               filled: true,
                               fillColor: Color(0xffffffff),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(15.0),
                                 borderSide:
                                 BorderSide(width: 1, color: Color(0xffCDE2FB)),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(15.0),
                                 borderSide:
                                 BorderSide(width: 1, color: Color(0xffCDE2FB)),
                               ),
                             ),
                           ),
                           if (_validateCreditTransactionID.isNotEmpty) ...[
                             Container(
                               alignment: Alignment.topLeft,
                               margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                               width: width * 0.6,
                               child: ShakeWidget(
                                 key: Key("value"),
                                 duration: Duration(milliseconds: 700),
                                 child: Text(
                                   _validateCreditTransactionID,
                                   style: TextStyle(
                                     fontFamily: "Poppins",
                                     fontSize: 12,
                                     color:Colors.red,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                             ),
                           ] else ...[
                             const SizedBox(
                               height: 15,
                             ),
                           ],
                           Text(
                             "Credit Password",
                             style: TextStyle(
                               fontSize: 16,
                               fontFamily: 'Poppins',
                               fontWeight: FontWeight.w500,
                               color: Color(0xFF374151),
                             ),
                           ),
                           const SizedBox(height: 4),
                           TextFormField(
                             controller: _creditTransactionPassword,
                             cursorColor: Colors.black,
                             keyboardType: TextInputType.name,
                             onTap: (){
                               setState(() {
                                 _validateCreditPassword="";
                               });
                             },
                             onChanged: (v) {
                               setState(() {
                                 _validateCreditPassword="";
                               });
                             },
                             style: TextStyle(
                               fontSize: 16,
                               letterSpacing: 0,
                               height: 1.2,
                               color: Colors.black,
                               fontWeight: FontWeight.w400,
                             ),
                             decoration: InputDecoration(
                               hintText: "Enter credit password recieved in mobile number.",
                               hintStyle: TextStyle(
                                 fontSize: 13,
                                 letterSpacing: 0,
                                 height: 1.2,
                                 color: Color(0xffAFAFAF),
                                 fontFamily: 'Poppins',
                                 fontWeight: FontWeight.w400,
                               ),
                               filled: true,
                               fillColor: Color(0xffffffff),
                               enabledBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(15.0),
                                 borderSide:
                                 BorderSide(width: 1, color: Color(0xffCDE2FB)),
                               ),
                               focusedBorder: OutlineInputBorder(
                                 borderRadius: BorderRadius.circular(15.0),
                                 borderSide:
                                 BorderSide(width: 1, color: Color(0xffCDE2FB)),
                               ),
                             ),
                           ),
                           if (_validateCreditPassword.isNotEmpty) ...[
                             Container(
                               alignment: Alignment.topLeft,
                               margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                               width: width * 0.6,
                               child: ShakeWidget(
                                 key: Key("value"),
                                 duration: Duration(milliseconds: 700),
                                 child: Text(
                                   _validateCreditPassword,
                                   style: TextStyle(
                                     fontFamily: "Poppins",
                                     fontSize: 12,
                                     color:Colors.red,
                                     fontWeight: FontWeight.w500,
                                   ),
                                 ),
                               ),
                             ),
                           ] else ...[
                             const SizedBox(
                               height: 15,
                             ),
                           ],
                           SizedBox(height: 30,),
                           InkWell(
                             onTap: () {
                               if(submitting){

                               }else{
                                 _validateFields();
                               }
                             },
                             child: Container(
                               width: width,
                               height: 48,
                               decoration: BoxDecoration(
                                 color: Color(0xFF24B0FF),
                                 borderRadius: BorderRadius.circular(15),
                               ),
                               child: Center(
                                 child:(submitting)
                                     ? CircularProgressIndicator(
                                   strokeWidth: 2,
                                   valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                 )
                                     :
                                 Text(
                                   "Submit  ",
                                   style: TextStyle(
                                     color: Color(0xFFFFFFFF),
                                     fontFamily: "Inter",
                                     fontWeight: FontWeight.w600,
                                     fontSize: 20,
                                   ),
                                 ),
                               ),
                             ),
                           ),
                         ],
                       ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ):
      NoInternetWidget();
  }
}