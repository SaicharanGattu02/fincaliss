import 'package:fincalis/screens/permission.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:flutter/material.dart';

import '../utils/Preferances.dart';
import 'mainhome.dart';

class MyOnBoard extends StatefulWidget {
  const MyOnBoard({Key? key}) : super(key: key);

  @override
  State<MyOnBoard> createState() => _MyOnBoardState();
}

class _MyOnBoardState extends State<MyOnBoard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 92, left: 24),
                child: Image.asset("assets/logo1.png",
                width: 230,
                height: 50,),
              ),
              Expanded(
                child: Center(
                  child: Image.asset(
                    "assets/onboard.png",
                    width: 300,
                    height: 292,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, bottom: 24, right: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Easy Loan",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "We Assure Lowest Interest",
                      style: TextStyle(
                        color: Color(0xFF5F5D5D),
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => MyPermission()),
                            );
                          },
                          child: Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFF2DB3FF),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

