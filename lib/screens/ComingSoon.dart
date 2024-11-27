import 'package:fincalis/screens/DisbursedScreen.dart';
import 'package:flutter/material.dart';

class Comingsoon extends StatefulWidget {
  const Comingsoon({super.key});
  @override
  State<Comingsoon> createState() => _ComingsoonState();
}

class _ComingsoonState extends State<Comingsoon> {
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
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          height: MediaQuery.of(context).size.height*1, // Set the desired height
          width: double.infinity, // Set the desired width
          child: Padding(
            padding: const EdgeInsets.only(left: 29,right: 29),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(image:AssetImage("assets/comingsoon.jpg"))
                // Text(
                //   "Coming Soon......",
                //   textAlign: TextAlign.center,
                //   style: TextStyle(
                //     color: Color(0xFF000000),
                //     fontSize: 24,
                //     fontFamily: "Inter",
                //     fontWeight: FontWeight.w400,
                //   ),
                //   // textAlign: TextAlign.center,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}