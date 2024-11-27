import 'package:fincalis/screens/emilist.dart';
import 'package:fincalis/screens/EMITenuresScreen.dart';
import 'package:flutter/material.dart';

class MyoneCongratulations extends StatefulWidget {
  const MyoneCongratulations({super.key});

  @override
  State<MyoneCongratulations> createState() => _MyoneCongratulationsState();
}

class _MyoneCongratulationsState extends State<MyoneCongratulations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 34, top: 50, right: 24),
          child: Column(
            children: [
              Image.asset("assets/fincalisss.png"),
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Center(
                  child: Image.asset(
                    "assets/stick.png",
                    width: 150,
                    height: 150,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 74),
                child: Center(
                  child: Text(
                    "Congratulations!",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Center(
                  child: Text(
                    "Your Loan Offer Has \n Been Approved",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 33),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFCDE2FB).withOpacity(0.25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 33, horizontal: 24),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Loan Amount",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "₹75,000",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Loan Duration",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "6 mon.",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Repayment",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Text(
                              "₹2,500",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              "Bank",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            Image.asset(
                              "assets/SBI.svg.png",
                              width: 20,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20), // Add some space before the Spacer
              // Spacer(),
              GestureDetector(
                onTap: () {
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) =>EMITenuresScreen()));
                },
                child: Center(
                  child: Container(
                    width: 240,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF2DB3FF),
                    ),
                    child: const Center(
                      child: Text(
                        "Continue",
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
              SizedBox(height: 20), // Add some space after the button
            ],
          ),
        ),
      ),
    );
  }
}
