import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyDenied extends StatefulWidget {
  const MyDenied({super.key});

  @override
  State<MyDenied> createState() => _MyDeniedState();
}

class _MyDeniedState extends State<MyDenied> {
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
              child: const Icon(Icons.arrow_back),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
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
                const SizedBox(height: 294),
                Center(
                  child: Column(
                    children: [
                      RichText(
                        text: const TextSpan(
                          children: [
                            TextSpan(
                              text: "School Details",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text: " Denied",
                              style: TextStyle(
                                color: Color(0xFFFF0303),
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Image.asset(
                          "assets/Thumbup.png",
                          width: 60,
                          height: 60,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 159, bottom: 50),
                  child: Container(
                    width: 240,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: const Color(0xFF2DB3FF),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Retry",
                          style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 10,
                            child: Icon(
                          Icons.arrow_forward_rounded,
                          weight: 25,
                          color: Color(0xFFFFFFFF),
                        ))
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
