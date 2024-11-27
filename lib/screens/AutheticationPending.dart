import 'package:fincalis/screens/mainhome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Services/user_api.dart';
import '../utils/Preferances.dart';
import 'EMITenuresScreen.dart';
import 'congratulations.dart';

class AuthenticationPending extends StatefulWidget {
  const AuthenticationPending({super.key});

  @override
  State<AuthenticationPending> createState() => _PendingState();
}


class _PendingState extends State<AuthenticationPending> {

  @override
  void initState() {
    super.initState();
  }

  // Method to handle refresh action
  Future<void> _handleRefresh() async {
    // Simulate a network call or data fetch
    await Future.delayed(Duration(seconds: 2));

  }

  Future<void> GettingSubscriptionStatus() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GettingSubscriptionStatusApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              if(data.data?.result!=null){
                _launchURL(data.data?.result?.authLink);
              }else{
                Navigator.push(context,MaterialPageRoute(builder:(context)=>MyMainHome()));
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "${data.settings?.message}.",
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFFCDE2FB),
                ));
              }
            } else {

            }
          })
        }
    });
  }

  void _launchURL(Url) async {
    final Uri url = Uri.parse(Url);
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context,true);
        return false;
      },
      child: Scaffold(
        appBar:AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 10),
            child: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.pop(context,true);
              },
            ),
          ),
          // other properties for AppBar
        ),
        body: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: Padding(
            padding: const EdgeInsets.only(top: 10, left:18, right: 18,bottom: 20),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  color: Color(0xFFCDE2FB).withOpacity(0.25),
                  borderRadius: BorderRadius.circular(20)),
              child:
              Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: 25),
                    Image.asset(
                      "assets/authentication.png",
                      width: 280,
                      height: 280,
                    ),
                    SizedBox(height: 35),
                    Text(
                      "Authentication Pending",
                      style: TextStyle(
                          color: Color(0xFF00A3FF),
                          fontSize: 24,
                          fontFamily: "Inter",
                          fontWeight: FontWeight.w600),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, left: 40, right: 40),
                      child: Text(
                        "Your account is pending authentication. Please complete the authentication process to proceed.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 12,
                            fontFamily: "Inter",
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: () {
                        GettingSubscriptionStatus();
                      },
                      child: Container(
                        margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                        height: 50,
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
                              fontFamily: "Inter",
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
