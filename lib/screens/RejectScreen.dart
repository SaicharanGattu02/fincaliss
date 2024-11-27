import 'package:flutter/material.dart';

import 'mainhome.dart';


class Reject extends StatefulWidget {
  const Reject({super.key});
  @override
  State<Reject> createState() => _RejectState();
}
class _RejectState extends State<Reject> {
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async {
          Navigator.pop(context,true);
      return false;
       },
        child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
          ),
        ),
        body: Padding(
          padding:
          const EdgeInsets.only(top: 10, left: 24, right: 24, bottom: 77),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
                color: Color(0xFFCDE2FB).withOpacity(0.25),
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/reject.png",
                  width: 250,
                  height: 220,
                ),
                Text(
                  "Sorry!",
                  style: TextStyle(
                      color: Color(0xFFFF0202),
                      fontSize: 24,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                  child: Text(
                    "we are regret to inform you that your loan application did not meet approval criteria.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 14,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w500),
                  ),
                ),
                SizedBox(height: 130,),
                Text(
                  "Please Try Again in 3 Months",
                  style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 22,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w600),
                ),
                // Spacer(),
                // Padding(
                //   padding: const EdgeInsets.only(bottom: 50),
                //   child: Container(
                //     width: 240,
                //     height: 56,
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(15),
                //       color: const Color(0xFF2DB3FF),
                //     ),
                //     child: const Center(
                //       child: Text(
                //         "Continue",
                //         style: TextStyle(
                //           color: Color(0xFFFFFFFF),
                //           fontSize: 20,
                //           fontWeight: FontWeight.w600,
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ),
        ),
            ),
      );
  }
}