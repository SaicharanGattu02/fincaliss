import 'dart:io';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/Preferances.dart';
import '../utils/constants.dart';

getheader() async {
  final sessionid = await PreferenceService().getString("token");
  print(sessionid);
  String Token="Bearer ${sessionid}";
  Map<String, String> a = {authorization: Token.toString(),'Content-Type': 'application/json; charset=UTF-8'};
  return a;
}

getheader1() async {
  final sessionid = await PreferenceService().getString("token");
  String Token="Bearer ${sessionid}";
  Map<String, String> a = {authorization: Token.toString(),'Content-Type':'multipart/form-data;'};
  return a;
}

getheader2() async {
  final sessionid = await PreferenceService().getString("token");
  print(sessionid);
  String Token="Bearer ${sessionid}";
  Map<String, String> a = {authorization: Token.toString(), 'accept': 'application/json',};
  return a;
}

getheader3() async {
  final sessionid = await PreferenceService().getString("token");
  String Token="Bearer ${sessionid}";
  Map<String, String> a = {'accept': 'application/json',authorization: Token.toString(),'Content-Type': 'application/x-www-form-urlencoded'};
  return a;
}

getheader4() async {
  final sessionid = await PreferenceService().getString("token");
  String Token="Bearer ${sessionid}";
  Map<String, String> a = {'accept': 'application/json',authorization: Token.toString(), 'Content-Type': 'application/json',};
  return a;
}


class AadhaarNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Implement formatting logic here
    if (newValue.text.length > 12) {
      return oldValue; // Prevents entering more than 12 characters
    }

    var newText = newValue.text;

    // Insert space after every 4 characters if necessary
    if (newValue.text.isNotEmpty &&
        newValue.text.length > oldValue.text.length &&
        (newValue.text.length == 5 ||
            newValue.text.length == 10)) {
      newText += ' ';
    }

    return TextEditingValue(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}

void Flashbar(BuildContext context, String text, String type) {
  Flushbar(
    barBlur: 10,
    isDismissible: true,
    flushbarPosition: FlushbarPosition.BOTTOM,
    message: (type == "")
        ? "Only ${text} unit(s) can be added per order"
        : "${text}",
    titleColor: Colors.black,
    messageColor: Colors.black,
    dismissDirection: FlushbarDismissDirection.VERTICAL,
    flushbarStyle: FlushbarStyle.FLOATING,
    shouldIconPulse: false,
    backgroundColor: Color(0xFFCDE2FB),
    duration: Duration(seconds: 3),
  )..show(context);
}


class NoInternetWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/nointernet.png",
              width: 47,
              height: 47,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(
                "Connect to the Internet",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                "You are Offline. Please Check Your Connection",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            GestureDetector(
              onTap: () {
                (context as Element).reassemble();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Container(
                  width: 240,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2DB3FF),
                  ),
                  child: const Center(
                    child: Text(
                      "Retry",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

