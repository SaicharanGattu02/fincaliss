import 'package:fincalis/screens/mainhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ServerdownScreen extends StatefulWidget {
  const ServerdownScreen({super.key});

  @override
  State<ServerdownScreen> createState() => _ServerdownScreenState();
}


class _ServerdownScreenState extends State<ServerdownScreen> {

  @override
  void initState() {
    super.initState();
  }

  // Method to handle refresh action
  Future<void> _handleRefresh() async {
    // Simulate a network call or data fetch
    await Future.delayed(Duration(seconds: 2));
    // You can add your refresh logic here
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.push(context,MaterialPageRoute(builder:(context)=>MyMainHome()));
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
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left:18, right: 18,bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Color(0xFFCDE2FB).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20)),
              child:
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Image.asset(
                      "assets/serverdown.png",
                      width: 280,
                      height: 280,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: Text(
                        "We are experiencing difficulties.Please Try After Sometime",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 12,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    // Spacer(),
                    // InkWell(
                    //   onTap: () {
                    //     Navigator.push(
                    //         context,
                    //         MaterialPageRoute(
                    //             builder: (context) => MyCongratulations()));
                    //   },
                    //   child: Container(
                    //     margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                    //     height: 50,
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
                    //           fontFamily: "Inter",
                    //           fontWeight: FontWeight.w600,
                    //         ),
                    //       ),
                    //     ),
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
