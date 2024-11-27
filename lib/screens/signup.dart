import 'dart:convert';
import 'dart:io';

import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:fincalis/utils/ShakeWidget.dart';
import 'package:flutter/material.dart';
import 'package:fincalis/screens/otp.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Services/user_api.dart';
import '../classes/FirstLetterCaps.dart';
import '../model/UploadingDocModel.dart';
import '../utils/Preferances.dart';
import 'package:path_provider/path_provider.dart';


class MySignup extends StatefulWidget {
  const MySignup({super.key});

  @override
  State<MySignup> createState() => _MySignupState();
}

class _MySignupState extends State<MySignup> {
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodeMobileNumber = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  bool _isLoading = false;
  String? _responseMessage;
  String _validateFullName = "";
  String _validateNumber = "";
  String _requestedPhoneNumber = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodeFullName.requestFocus();
    });
    _retrievePhoneNumber();
  }

  Future<void> _submitDetails() async {
    await UserApi.ReceiveOtp(_mobileNumberController.text
    ).then((data) => {
      if (data != null) {
        setState(() {
          if (data.type == "success") {
            _isLoading=false;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerifyScreen(
                    mobileNumber: _mobileNumberController.text,
                ),
              ),
            );

          }else{
            _isLoading=false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Please enter a valid mobile number.",
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
    _focusNodeMobileNumber.dispose();
    _mobileNumberController.dispose();
    super.dispose();
  }

  Future<void> _retrievePhoneNumber() async {
    try {
      final value = await AndroidSmsRetriever.requestPhoneNumber();
      setState(() {
        _requestedPhoneNumber = value ?? 'Phone Number Not Found';
        _mobileNumberController.text = _removeCountryCode(_requestedPhoneNumber);
      });
    } catch (e) {
      // Handle the error if necessary
      print('Error retrieving phone number: $e');
    }
  }

  String _removeCountryCode(String phoneNumber) {
    // Check if the phone number starts with +91 and remove it
    if (phoneNumber.startsWith('+91')) {
      return phoneNumber.substring(3); // Remove +91
    }
    return phoneNumber;
  }

  void _handleSignup() {
    setState(() {
      _isLoading=true;
      _validateNumber = _mobileNumberController.text.isEmpty || _mobileNumberController.text.length != 10
          ? "Please enter a valid mobile number"
          : "";
    });
    if (_validateNumber.isEmpty) {
      _submitDetails();
    } else {
      setState(() {
        _isLoading=false;
      });
    }
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      String validationMessage,
      FocusNode focus,
      String pattern,
      int length,
      List<TextInputFormatter> additionalFormatters,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          focusNode: focus,
          keyboardType: keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(pattern)),
            if (length > 0) LengthLimitingTextInputFormatter(length),
            ...additionalFormatters,
          ],
          onTap: () {
            setState(() {
              if (label == "Full Name") _validateFullName = "";
              if (label == "Mobile Number") _validateNumber = "";
            });
          },
          onChanged: (v){
            setState(() {
              if (label == "Full Name") _validateFullName = "";
              if (label == "Mobile Number") _validateNumber = "";
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
            hintText: "Enter your $label",
            hintStyle: TextStyle(
              fontSize: 15,
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
              borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
        ),
        if (validationMessage.isNotEmpty) ...[
          ShakeWidget(
            key: Key("value"),
            duration: Duration(milliseconds: 700),
            child: Text(
              validationMessage,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Exit the app
        SystemNavigator.pop();
        // Return false to prevent default back navigation behavior
        return false;
      },
      child:Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
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
                    padding: const EdgeInsets.only(top: 78),
                    child: Text(
                      "Sign Up/Login",
                      style: TextStyle(
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                      "Mobile Number",
                      _mobileNumberController,
                      TextInputType.phone,
                      _validateNumber,
                      _focusNodeMobileNumber,
                      r'^[0-9]+$',
                      10,
                      [CapitalizationInputFormatter()]
                  ),
                  GestureDetector(
                    onTap:(){
                      if(_isLoading){

                      }else{
                        _handleSignup();
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(44),
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Color(0xFF2DB3FF),
                          ),
                          child: Center(
                            child: _isLoading
                                ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                :
                            Text(
                              "Proceed",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 24,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),);
  }
}