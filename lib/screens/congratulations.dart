import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/EMITenuresScreen.dart';
import 'package:fincalis/screens/enach.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';
import 'emilist.dart';
import 'mainhome.dart';

class MyCongratulations extends StatefulWidget {
  const MyCongratulations({super.key});
  @override
  State<MyCongratulations> createState() => _MyCongratulationsState();
}

class _MyCongratulationsState extends State<MyCongratulations> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  int loan_approved=0;

  bool is_loading=true;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    GetLoanApplicationInfo();
  }

  Future<void> initConnectivity() async {
    List<ConnectivityResult> result;
    try {
      // Check connectivity and get the result
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    // Update connection status based on the single ConnectivityResult
    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> result) async {
    setState(() {
      _connectionStatus = result;
      for (int i = 0; i < _connectionStatus.length; i++) {
        setState(() {
          isDeviceConnected = _connectionStatus[i].toString();
          print("isDeviceConnected:${isDeviceConnected}");
        });
      }
    });
    print('Connectivity changed: $_connectionStatus');
  }
  Future<void> GetLoanApplicationInfo() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetLoanApplicationInfoApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              is_loading=false;
              var approved_amount= data.data?.result?.loanApproved??0.0;
              loan_approved=approved_amount.toInt();
            }else{
              is_loading=false;
            }
          })
        }
    });
  }

  Future<void> KycProcessStatus() async {
    var userId = await PreferenceService().getString('user_id');
    await UserApi.KycProcessStatusapi(userId!).then((data) {
      if (data != null && data.data != null) {
        setState(() {
         if(data.data?.result?.isLoanAppComplete==true){
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNach()));
         }else{
           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EMITenuresScreen(loanamount:loan_approved.toDouble())));
         }
        });
      } else {
      }
    }).catchError((error) {
      // Handle error, e.g., show an error message
      print('Error fetching KYC status: $error');
    });
  }
  @override
  Widget build(BuildContext context) {
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
    WillPopScope(
        onWillPop: () async {
          Navigator.pop(context,true);
          return false;
        },
        child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context,true);
                },
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
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Image.asset("assets/onelack.png"),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 60, right: 60, top: 24),
                    child: Text(
                      "Congratulations",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15,left: 34,right: 34),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "You Got Approval up to",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                       Icon(
                              Icons.currency_rupee_outlined,
                              size: 20,
                              color: Color(0xFF581FF9),
                            ),
                       Text(
                        loan_approved.toString()??"",
                              style: TextStyle(
                                color: Color(0xFF581FF9),
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(top: 159, bottom: 50),
                    child: GestureDetector(
                      onTap: () {
                        KycProcessStatus();
                      },
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
                ],
              ),
            ),
          ),
        ),
            ),
      ):
      NoInternetWidget();
  }
}
