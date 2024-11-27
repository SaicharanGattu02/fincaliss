import 'package:fincalis/screens/applicationstatus.dart';
import 'package:flutter/material.dart';

import 'UserVerifydetails.dart';

class MyNach extends StatelessWidget {
  const MyNach({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },

            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height, // Ensure full height
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Authorise NACH",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top:20),
                    child: Image.asset(
                      "assets/nach.png",
                      width: 95,
                      height: 95,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Userverifydetails()));
                  },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 38,left:20,right: 20),
                      child: Container(height: 58,
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(8),border: Border.all(color: Color(0xFFD9D9D9)),color: Color(0xFFFEFEFE)),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10,right: 10),
                          child: Center(
                            child: Text(
                              "Auto Debit EMI from your account",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontFamily: "Inter",
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
