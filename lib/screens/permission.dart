import 'package:fincalis/screens/ConsentScreen.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../utils/Preferances.dart';
class MyPermission extends StatefulWidget {
  const MyPermission({super.key});
  @override
  State<MyPermission> createState() => _MyPermissionState();
}
class _MyPermissionState extends State<MyPermission> {
  @override
  void initState() {
    super.initState();
    Fetchdetails();
  }
  String token="";

  Fetchdetails() async {
    var Token = (await PreferenceService().getString('token'))??"";
    setState(() {
      token=Token;
    });
    print("Token:${token}");
  }


  Future<void> _requestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.location,
      Permission.camera,
      Permission.sms,
      Permission.contacts,
      Permission.notification,
      Permission.microphone,
    ].request();
    // Check each permission status and print it to the console
    statuses.forEach((permission, status) {
      print('$permission: $status');
    });
    // Handle permissions that are denied
    if (statuses[Permission.sms]!.isDenied || statuses[Permission.notification]!.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Permissions Required'),
            content: Text(
                'SMS and Notifications permissions are required for the app to function properly. Please grant these permissions to proceed.'),
            actions: [
              TextButton(
                child: Text('Retry'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  await [
                    Permission.sms,
                    Permission.notification,
                  ].request();
                  // Check the statuses again
                  if (await Permission.sms.isGranted &&
                      await Permission.notification.isGranted) {
                    if(token!=""){
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyMainHome()),
                      );
                    }else{
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MySignup()),
                      );
                    }

                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Please grant all permissions to proceed.'),
                      ),
                    );
                  }
                },
              ),
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (statuses.values.every((status) => status.isGranted)) {
      if(token!=""){
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MyMainHome()),
        );
      }else{
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MySignup()),
        );
      }
    } else {
      // Handle the case where some permissions are not granted
      _showPermissionDeniedDialog();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please grant all permissions to proceed.'),
        ),
      );
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('Fincalis app needs all permissions mentioned above. Please grant the permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Retry'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openAppSettings(); // Optionally, direct user to app settings
              },
              child: Text('Settings'),
            ),
          ],
        );
      },
    );
  }
  void _openAppSettings() async {
    await openAppSettings();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 24, right: 24, top: 44),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Permissions",
                    style: TextStyle(
                      fontSize: 24,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text(
                      "Hi There",
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      "For The Purpose Of Credit Risk Assessment And To Facilitate Faster Loan Disbursal, We Require The Following Permissions From YOU",
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF000000),
                      ),
                    ),
                  ),
                  _buildPermissionItem(
                    icon: "assets/mobile.png",
                    title: "SMS",
                    description:
                    "Our App Collects And Transmits To Fincalis Servers, Your SMS Data Which Helps Us In Identifying The Various Bank Accounts That You May Be Holding, Cash Flow Patterns, Description and amount of the transactions for the purpose of performing a credit risk assessment. This credit risk assessment enables us to perform a quicker loan disbursal. This data may be collected even when the app is closed or not in use.",
                  ),
                  _buildPermissionItem(
                    icon: "assets/cal.png",
                    title: "Installed Applications",
                    description:
                    "Our app collects and transmits to Fincalis servers, your installed applications data which helps us in identifying the various apps you may be using for financial transactions, for the purpose of performing a credit risk assessment. This credit risk assessment enables us to perform a quicker loan disbursal.",
                  ),
                  _buildPermissionItem(
                    icon: "assets/Location.png",
                    title: "Location",
                    description:
                    "Our app collects and transmits to Fincalis servers, your location data which helps us in identifying your current location and travel patterns for the purpose of performing a credit risk assessment. This credit risk assessment enables us to perform a quicker loan disbursal.",
                  ),
                  _buildPermissionItem(
                    icon: "assets/cam1.png",
                    title: "Camera",
                    description:
                    "Our app requires access to your camera to capture documents and photos for identity verification and other KYC processes.",
                  ),
                  _buildPermissionItem(
                    icon: "assets/call.png",
                    title: "Contacts",
                    description:
                    "Our app collects and transmits to Fincalis servers, your contacts data which helps us in identifying your social and professional connections for the purpose of performing a credit risk assessment. This credit risk assessment enables us to perform a quicker loan disbursal.",
                  ),
                  _buildPermissionItem(
                    icon: "assets/bell.png",
                    title: "Notifications",
                    description:
                    "Our app requires permission to send you notifications to keep you updated on your loan application status and other important updates.",
                  ),
                  GestureDetector(
                    onTap: _requestPermissions,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Container(
                          width: 176,
                          height: 44,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xFF2DB3FF),
                          ),
                          child: Center(
                            child: Text(
                              "Agree",
                              style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildPermissionItem({
    required String icon,
    required String title,
    required String description,
  }) {
    return Padding(
      padding: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xFFCDE2FB),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Center(
                    child: Image.asset(
                      icon,
                      width: 18,
                      height: 18,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 7, left: 40),
            child: Text(
              description,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w300,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}