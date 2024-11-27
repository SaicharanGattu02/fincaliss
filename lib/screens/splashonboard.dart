import 'package:fincalis/screens/onboarding.dart';
import 'package:fincalis/screens/permission.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_onboarding_slider/flutter_onboarding_slider.dart';

import '../utils/Preferances.dart';

class MySplashOnboard extends StatefulWidget {
  const MySplashOnboard({Key? key}) : super(key: key);

  @override
  State<MySplashOnboard> createState() => _MySplashOnboardState();
}

class _MySplashOnboardState extends State<MySplashOnboard> {
  @override
  void initState() {
    super.initState();
    PreferenceService().saveString("onboard_status","1");
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: OnBoardingSlider(
              finishButtonText: 'Next',
              onFinish: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyOnBoard()));
              },
              finishButtonStyle:
                  FinishButtonStyle(backgroundColor: Color(0xFF2DB3FF)),
              skipTextButton: Container(
                width: 60,
                height: 20,
                decoration: BoxDecoration(
                    color: Color(0xFF38A106).withOpacity(0.24),
                    borderRadius: BorderRadius.circular(4)),
                child: Center(
                  child: const Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 10,
                      color: Color(0xFF38A106),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              trailingFunction: () {
              },
              totalPage: 3,
              headerBackgroundColor: Colors.white,
              pageBackgroundColor: Colors.white,
              background: [
                Padding(
                  padding: EdgeInsets.only(top: 114, left:screenWidth*0.1, right:screenWidth*0.25),
                  child: Image.asset(
                    'assets/onboard1.png',
                    height: 243,
                    width: 322,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 114, left:screenWidth*0.1, right:screenWidth*0.25),
                  child: Image.asset(
                    'assets/onboard2.png',
                    height: 243,
                    width: 322,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 114, left:screenWidth*0.1, right:screenWidth*0.25),
                  child: Image.asset(
                    'assets/onboard3.png',
                    height: 243,
                    width: 322,
                  ),
                ),
              ],
              speed: 1.8,
              pageBodies: [
                Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 480,
                      ),
                      Text(
                        'Fast and Stress free Application',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 480,
                      ),
                      Text(
                        'No Collaterals Or Documents Needed',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const SizedBox(
                        height: 480,
                      ),
                      Text(
                        'Money Disbursed in under 2 hours',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
