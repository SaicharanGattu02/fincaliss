import 'package:fincalis/screens/ComingSoon.dart';
import 'package:fincalis/screens/TicketsScreen.dart';
import 'package:flutter/material.dart';

import 'faq.dart';

class MyHelpSupport extends StatefulWidget {
  const MyHelpSupport({super.key});

  @override
  State<MyHelpSupport> createState() => _MyHelpSupportState();
}

class _MyHelpSupportState extends State<MyHelpSupport> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 180,
                padding: EdgeInsets.only(left: 20),// Set the desired height
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20),
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF44BC0B).withOpacity(0.25),
                      Color(0xFF5E9EE9).withOpacity(0.25),
                    ],
                    stops: [0.2, 1.0], // Adjust the stops as needed
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height:screenHeight*0.06,),
                    Text(
                      "Help and Support",
                      style: TextStyle(
                        color: Color(0xFF034469),
                        fontSize: 24,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height:screenHeight*0.01,),
                    Text(
                      "How can we Help You?",
                      style: TextStyle(
                        color: Color(0xFF7C8697),
                        fontSize: 18,
                        fontFamily:"Inter",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30),
              //   child: Container(
              //     height: 54,
              //     width: MediaQuery.of(context).size.width,
              //     decoration: BoxDecoration(
              //       borderRadius: BorderRadius.circular(16),
              //       border: Border.all(
              //         color: Color(0xFF2A63A6).withOpacity(0.30),
              //         strokeAlign: BorderSide.strokeAlignCenter,
              //       ),
              //     ),
              //     child: Center(
              //       child: Row(
              //         crossAxisAlignment: CrossAxisAlignment.center,
              //         children: [
              //           Padding(
              //             padding: const EdgeInsets.only(left: 24),
              //             child: Icon(
              //               Icons.search,
              //               size: 18,
              //               color: Color(0xFF8A8F99).withOpacity(0.50),
              //             ),
              //           ),
              //           Padding(
              //             padding: const EdgeInsets.only(left: 10),
              //             child: Text(
              //               "Enter an issue/Topic/Keyword",
              //               style: TextStyle(
              //                 color: Color(0xFF8A8F99),
              //                 fontSize: 18,
              //                 fontWeight: FontWeight.w500,
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Tickets",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyTickets()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Container(
                    height: 54,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Color(0xFF2A63A6).withOpacity(0.30),
                        strokeAlign: BorderSide.strokeAlignCenter,
                      ),
                    ),
                    child: Center(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: Icon(Icons.confirmation_num_outlined),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "My Tickets",
                              style: TextStyle(
                                color: Color(0xFF374151),
                                fontSize: 18,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.only(right: 16),
                            child: Icon(Icons.arrow_forward_ios_rounded,
                              size: 20,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Text(
                  "Categories",
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFAQ()));
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 40,left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Auto Debit",
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 17,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20,),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Color(0xFFD9D9D9),
                  )),
                ),
              ),

              InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Comingsoon()));
                },
                child: Container(
                  padding: const EdgeInsets.only(top: 20, left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "NOC",
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 17,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Color(0xFFD9D9D9),
                  )),
                ),
              ),
              
              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Comingsoon()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Foreclosure",
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 17,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: Color(0xFFD9D9D9),
                  )),
                ),
              ),

              InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>Comingsoon()));
                },
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,left: 20),
                  child: Row(
                    children: [
                      Text(
                        "Payment Issues",
                        style: TextStyle(
                          color: Color(0xFF374151),
                          fontSize: 17,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.arrow_forward_ios_rounded,
                          size: 20,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
