import 'package:flutter/material.dart';

class MyReApply extends StatefulWidget {
  const MyReApply({super.key});

  @override
  State<MyReApply> createState() => _MyReApplyState();
}

class _MyReApplyState extends State<MyReApply> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 24, right: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              "assets/profiles.png",
              height: 90,
              width: 90,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "Application not approved",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 24,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Text(
                "sorry, we are not able to approve your loan application currently.",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Text(
                "you can re-apply after 60 days.",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Image.asset(
                  "assets/date.png",
                  height: 100,
                  width: 100,
                )),
            Padding(
              padding: const EdgeInsets.only(top: 60),
              child: Row(
                children: [
                  Text(
                    "Profile Not Eligible",
                    style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    size: 24,
                  )
                ],
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20,right: 44,left: 44),
              child: Container(
                height: 56,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: const Color(0xFF2DB3FF),
                ),
                child: const Center(
                  child: Text(
                    "Rate us",
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
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
