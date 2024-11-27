import 'package:fincalis/classes/octagonal.dart';
import 'package:fincalis/utils/constants.dart';
import 'package:flutter/material.dart';

class MyReferal extends StatefulWidget {
  const MyReferal({Key? key}) : super(key: key);

  @override
  State<MyReferal> createState() => _MyReferalState();
}

class _MyReferalState extends State<MyReferal> {
  Widget buildStepItem(String number, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipPath(
            clipper: OctagonClipper(),
            child: Container(
              width: 40,
              height: 40,
              color: Color(0xFF08A4FF),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Text(
              description,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 17,
                fontFamily: "Inter",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SingleChildScrollView(
          child: Column(
        children: [
          Stack(
            children: [
              // Background Image
              Positioned(
                child: Image(
                  image: AssetImage("assets/referandearn.png"),
                  fit: BoxFit.cover,
                ),
              ),
              // Main Content
              Positioned(
                top: 10, // Start below the top image
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, right: 24, left: 24),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(Icons.arrow_back),
                          ),
                          Spacer(),
                          Text(
                            "Refer",
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 24,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.help_outline_rounded),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
                    RichText(
                      text: TextSpan(
                        children: <TextSpan>[
                          TextSpan(
                            text: 'More than ',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          TextSpan(
                            text: '₹50,000',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 18,
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w700, // Bold text
                            ),
                          ),
                          TextSpan(
                            text: ' per month!',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Text(
                        "Spread The Word About Us Among\n Your Friends & Family",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 18,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 15),
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.07,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Earn Rewards By Inviting Friends",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: buildStepItem(
                      "1", "Invite Your Friends To Take Personal Loan"),
                ),
                SizedBox(height: screenHeight * 0.17),
                Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2DB3FF),
                  ),
                  child: const Center(
                    child: Text(
                      "Refer Now",
                      style: TextStyle(
                        color: Color(0xFFFFFFFF),
                        fontSize: 20,
                        fontFamily: "Inter",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}
