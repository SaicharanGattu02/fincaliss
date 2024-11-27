import 'package:fincalis/student/StudentDetailsScreen.dart';
import 'package:flutter/material.dart';

class MyVerify extends StatelessWidget {
  const MyVerify({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.only(left: 24, top: 12),
          child: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Image.asset(
              "assets/farrow.png",
              width: 24,
              height: 24,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFCDE2FB).withOpacity(0.25),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 144),
                      Text(
                        "Verified",
                        style: TextStyle(
                          color: const Color(0xFF000000),
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Center(
                        child: Text(
                          "Your identity has been verified.",
                          style: TextStyle(
                            color: const Color(0xFF374151),
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                      Center(
                        child: Image.asset(
                          "assets/checkmark.png",
                          width: 100,
                          height: 100,
                        ),
                      ),
                      const Spacer(),
                      Padding(
                        padding: const EdgeInsets.all(35),
                        child: Center(
                          child: Text.rich(
                            TextSpan(
                              text:
                                  "Fincalis acknowledges your right to request access or erasure of your data. ",
                              children: [
                                TextSpan(
                                  text: "You may review our",
                                  style: TextStyle(
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                                TextSpan(
                                  text: " Privacy Policy ",
                                  style: TextStyle(
                                    color: const Color(0xFF24B0FF),
                                  ),
                                ),
                                TextSpan(
                                  text: "here or contact us at",
                                  style: TextStyle(
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                                TextSpan(
                                  text: " Privacy@fincalis.com",
                                  style: TextStyle(
                                    color: const Color(0xFF24B0FF),
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: const Color(0xFF000000),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                          width: 183,
                          height: 53,
                          decoration: BoxDecoration(
                            color: const Color(0xFF24B0FF),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              "Continue",
                              style: TextStyle(
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                    ],
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
