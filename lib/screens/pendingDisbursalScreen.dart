import 'package:fincalis/screens/DisbursedScreen.dart';
import 'package:flutter/material.dart';

import 'mainhome.dart';

class PendingDisbursal extends StatefulWidget {
  const PendingDisbursal({super.key});

  @override
  State<PendingDisbursal> createState() => _PendingDisbursalState();
}

class _PendingDisbursalState extends State<PendingDisbursal> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MyMainHome()));
        return false;
      },
      child: Scaffold(
        appBar:AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(context,MaterialPageRoute(builder:(context)=>MyMainHome()));
              },
            ),
          ),
          // other properties for AppBar
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: Image.asset("assets/hourglass.png", width: 150, height: 150),
                  ),
                  const SizedBox(height: 44),
                  Text(
                    "Your Amount is pending Disbursal",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xff034469),
                      fontSize: 18,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Text(
                    "We will keep you informed throughout the disbursement process, as the funds have been successfully disbursed",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xF000000).withOpacity(0.50),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
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
