import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/services.dart';
import '../Services/other_services.dart';
import 'emilist.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'dart:developer' as developer;

class LoanOverView extends StatefulWidget {
  const LoanOverView({super.key});

  @override
  State<LoanOverView> createState() => _LoanOverViewState();
}

class _LoanOverViewState extends State<LoanOverView> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  var is_loading = true;
  var  loan_id="";
  var loan_required=0.0;
  var emi_value=0.0;
  var emi_date="";
  String duedate="";
  String dueamount="";

  @override
  void initState() {
    super.initState();
    GetLoanOverviewData();
    UpcomingEmiDetails();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  Future<void>UpcomingEmiDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.UpcomingEmiApi(Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success == 1) {
              dueamount=data?.data?.result?.upcoming?.amount??"";
              duedate=data?.data?.result?.upcoming?.date??"";
            } else{

            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
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

  Future<void> GetLoanOverviewData() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetLoanOverViewAPI(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              is_loading = false;
              loan_id=data.data?.result?.loan_id??"";
              loan_required=data.data?.result?.loanRequired??0.0;
              emi_value=data.data?.result?.emiValue??0.0;
              emi_date=data.data?.result?.emiDate??"";
              print("Loan Data Fetched");
            }
            else{
              is_loading = false;
              print("data Not Fetched");
            }
          })
        }
    });
  }

  @override
  Widget build(BuildContext context) {
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile" )?
      Scaffold(
      body: is_loading?
      Center(child: CircularProgressIndicator(
        color: Color(0xff2DB3FF),
      )):
      SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SvgPicture.asset(
                  "assets/rect.svg",
                  fit: BoxFit.fitHeight,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24, top: 40),
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.arrow_back)),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 50,
                          width: 220,
                          decoration: BoxDecoration(
                              color: Color(0xFF2889BF).withOpacity(0.86),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                          child: Center(
                            child: Text(
                              "Loan Overview",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.only(left: 15,right: 15),
              margin: EdgeInsets.only(top: 25,left: 20,right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color(0xFFFFFFFF).withOpacity(0.30),
                border: Border.all(
                  color: Color(0xFF2A63A6).withOpacity(0.30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 20,
                  bottom: 16,
                  left: 10,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Loan Taken",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "₹${loan_required}",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Spacer(),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Monthly EMI",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                "₹${emi_value}",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  fontSize: 20,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16), // Add spacing between the rows
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Loan ID",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "${loan_id}",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 19,
                                  fontFamily: "Inter",
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "EMI Date",
                              style: TextStyle(
                                color: Color(0xFF6B7280),
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                fontSize: 18,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "${emi_date}",
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Inter",
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Padding(
                    //   padding:
                    //   const EdgeInsets.only(left: 5, right: 5, top: 20),
                    //   child: Container(
                    //     height: 2,
                    //     width: MediaQuery.of(context).size.width,
                    //     decoration: BoxDecoration(
                    //         color: Color(0xFF000000).withOpacity(0.20)),
                    //   ),
                    // ),
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 16, right: 10),
                    //   child: Row(
                    //     children: [
                    //       Text(
                    //         "Auto debit",
                    //         style: TextStyle(
                    //             color: Color(0xFF6B7280),
                    //             fontSize: 16,
                    //             fontFamily: "Inter",
                    //             fontWeight: FontWeight.w500),
                    //       ),
                    //       Spacer(),
                    //       Container(
                    //         padding: const EdgeInsets.symmetric(
                    //           horizontal: 8,
                    //           vertical: 4,
                    //         ),
                    //         decoration: BoxDecoration(
                    //           color: Color(0xFF49E600).withOpacity(0.14),
                    //           borderRadius: BorderRadius.circular(4),
                    //         ),
                    //         child: const Text(
                    //           "Enabled",
                    //           style: TextStyle(
                    //             color: Color(0xFF1E40AF),
                    //             fontSize: 10,
                    //             fontFamily: "Inter",
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 24, right: 24),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color(0xFFFFFFFF).withOpacity(0.30),
                  border: Border.all(
                    color: Color(0xFF2A63A6).withOpacity(0.30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20, left: 30, bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment of ₹${dueamount} is due on ",
                        style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontFamily: "Inter",
                            fontSize: 20),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: Text(
                          "${duedate}",
                          style: TextStyle(
                              color: Color(0xFF2A63A6),
                              fontWeight: FontWeight.w600,
                              fontFamily: "Inter",
                              fontSize: 20),
                        ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 25),
                      //   child: Text(
                      //     "You have no due EMI’s",
                      //     style: TextStyle(
                      //         color: Color(0xFF6B7280),
                      //         fontWeight: FontWeight.w500,
                      //         fontFamily: "Inter",
                      //         fontSize: 16),
                      //   ),
                      // ),
                      // Padding(
                      //   padding: const EdgeInsets.only(top: 12),
                      //   child: GestureDetector(
                      //     onTap: () {},
                      //     child: Text(
                      //       "View Breakup",
                      //       style: TextStyle(
                      //           color: Color(0xFF374151),
                      //           decoration: TextDecoration.underline,
                      //           fontWeight: FontWeight.w600,
                      //           fontFamily: "Inter",
                      //           fontSize: 20),
                      //     ),
                      //   ),
                      // )
                    ],
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                var res= await Navigator.push(context,
                    MaterialPageRoute(builder: (context) => MyEmiList()));
                print("Response: ${res}");
                if(res==true){
                  setState(() {
                    is_loading=true;
                    GetLoanOverviewData();
                    UpcomingEmiDetails();
                  });
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
                child: Container(
                  padding: EdgeInsets.only(top: 20,left: 20,right: 20,bottom: 20),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFFFFFFF).withOpacity(0.30),
                    border: Border.all(
                      color: Color(0xFF2A63A6).withOpacity(0.30),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        "assets/Money.png",
                        width: 24,
                        height: 24,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text(
                          "View EMI Details",
                          style: TextStyle(
                              color: Color(0xFF374151),
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.arrow_forward_ios)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ):
    NoInternetWidget();
  }
}