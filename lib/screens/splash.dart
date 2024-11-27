import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:fincalis/screens/onboarding.dart';
import 'package:fincalis/screens/permission.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:fincalis/screens/splashonboard.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/Preferances.dart';
import 'StaticSearch.dart';
import 'mainhome.dart';

class MySplash extends StatefulWidget {
  const MySplash({super.key});

  @override
  State<MySplash> createState() => _MySplashState();
}

class _MySplashState extends State<MySplash> {
  @override
  void initState() {
    super.initState();
    Fetchdetails();
    _checkPermissions();
  }
  String token="";
  String onboard_status="";

  bool permissions_granted=false;

  Future<void> _checkPermissions() async {
    Map<Permission, PermissionStatus> statuses = {
      Permission.location: await Permission.location.status,
      Permission.camera: await Permission.camera.status,
      Permission.sms: await Permission.sms.status,
      Permission.contacts: await Permission.contacts.status,
      Permission.notification: await Permission.notification.status,
      Permission.microphone: await Permission.microphone.status,
    };

    bool allPermissionsGranted = statuses.values.every((status) => status.isGranted);

    setState(() {
      permissions_granted = allPermissionsGranted;
    });
  }


  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token'))??"";
    var status = (await PreferenceService().getString('onboard_status'))??"";
    setState(() {
      token=Token;
      onboard_status=status;
    });
    print("Token:${token}");
    print("onboard_status:${onboard_status}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: AnimatedSplashScreen(
          duration: 2000,
          splash:  const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage("assets/logo.png"),
                  width: 281,
                  height: 60,
                )
              ],
            ),
          ),
       nextScreen: (onboard_status == "")
           ? MySplashOnboard()
           : (token != "")
           ? (permissions_granted ? MyMainHome() : MyPermission())
           :(permissions_granted ? MySignup() : MyPermission()),
       //  nextScreen: MyApp1(),
          splashIconSize: double
            .infinity,
             backgroundColor:Colors.white,
              splashTransition: SplashTransition.scaleTransition,
           ),

    );
  }
}
