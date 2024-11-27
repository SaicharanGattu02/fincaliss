import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/classes/emi.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';

class MyEmiList extends StatefulWidget {
  const MyEmiList({Key? key}) : super(key: key);

  @override
  State<MyEmiList> createState() => _MyEmiListState();
}

class _MyEmiListState extends State<MyEmiList> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final List<EmiDetails> emiDetails = [];
  final double amount = 1858;
  bool is_loading = true;

  String duedate = "";
  String dueamount = "";

  String getDaySuffix(int day) {
    if (day >= 11 && day <= 13) {
      return 'th';
    }
    switch (day % 10) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }

  void _generateEmiDetails() {
    emiDetails.clear();
    DateTime now = DateTime.now();
    DateTime startDate;

    if (now.day <= 1) {
      startDate = DateTime(now.year, now.month, 2);
    } else {
      startDate = DateTime(now.year, now.month + 1, 2);
    }

    for (int i = 0; i < 9; i++) {
      DateTime emiDate = DateTime(startDate.year, startDate.month + i, 2);
      String daySuffix = getDaySuffix(emiDate.day);
      String formattedDate = DateFormat("d MMM yyyy").format(emiDate);
      formattedDate = formattedDate.replaceFirst(
          RegExp(r'\d+'), '${emiDate.day}$daySuffix');

      emiDetails.add(EmiDetails(formattedDate, amount.toStringAsFixed(2)));
    }
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    Emibreakupdetails();
    UpcomingEmiDetails();
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

  Future<void> Emibreakupdetails() async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.EmibreakupdetailsApi(Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success == 1) {
              is_loading = false;
              final repaymentDetails =
                  data.data?.result; // List of RepaymentDetail
              print('Repayment Details: $repaymentDetails'); // Print to verify the data

              if (repaymentDetails != null) {
                emiDetails.clear(); // Clear the list before adding new items

                // Use a for loop to iterate through the list
                for (var i = 0; i < repaymentDetails.length; i++) {
                  var detail = repaymentDetails[i];
                  final formattedAmount = detail.amount.toStringAsFixed(2);
                  emiDetails.add(EmiDetails(detail.date, formattedAmount));
                }

                // Print the results (for verification)
                for (var detail in emiDetails) {
                  print('Date: ${detail.date}, Amount: ${detail.amount}');
                }
              } else {
                print('Repayment Details is null');
              }
            } else {
              is_loading = false;
            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

  Future<void> UpcomingEmiDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.UpcomingEmiApi(Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success == 1) {
              dueamount = data?.data?.result?.upcoming?.amount ?? "";
              duedate = data?.data?.result?.upcoming?.date ?? "";
            } else {}
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

  bool showEmiDetails = true;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    if ((isDeviceConnected == "ConnectivityResult.wifi" ||
        isDeviceConnected == "ConnectivityResult.mobile")) {
      return WillPopScope(
          onWillPop: () async{
        Navigator.pop(context,true);
        return false;
        },
          child: Scaffold(
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context,true); // Go back to the previous screen
                },
              ),
            ),
            title: Text('EMI Details',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 22,
              ),
            ),

          ),

          body: is_loading
              ? Center(
                  child: CircularProgressIndicator(
                  color: Color(0xff2DB3FF),
                ))
              : SingleChildScrollView(
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Upcoming Due",
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Color(0xFF374151),
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 15,),
                        _buildEmiDetails(),
                      ],
                    ),
                  ),
                ),
                ),
        );
    } else {
      return NoInternetWidget();
    }
  }

  Widget _buildEmiDetails() {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFFFFFFF).withOpacity(0.30),
            border: Border.all(
              color: Color(0xFF2A63A6).withOpacity(0.30),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 20, bottom: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Payment of ₹${dueamount} is due on ",
                  style: TextStyle(
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                      fontFamily: "Inter",
                      fontSize: 20),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: Text(
                    "${duedate}",
                    style: TextStyle(
                        color: Color(0xFF2A63A6),
                        fontWeight: FontWeight.w500,
                        fontFamily: "Inter",
                        fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 20),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "EMI Breakup",
            textAlign: TextAlign.left,
            style: TextStyle(
              color: Color(0xFF374151),
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(25),
          margin: EdgeInsets.only(bottom: 20),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Color(0xFFFFFFFF).withOpacity(0.30),
            border: Border.all(
              color: Color(0xFF2A63A6).withOpacity(0.30),
            ),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: emiDetails.length,
            itemBuilder: (context, index) {
              final isLastIndex = index == emiDetails.length - 1;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            color: Color(0xFFD9D9D9),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                emiDetails[index].date,
                                style: TextStyle(
                                  color: Color(0xFF374151),
                                  fontSize: 16,
                                ),
                              ),
                              // const SizedBox(width: 10),
                              // Text(
                              //   "Due on 5th aug 2024",
                              //   style: TextStyle(
                              //     color: Color(0xFF374151),
                              //     fontSize: 16,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Text(
                          "₹${emiDetails[index].amount}",
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    if (!isLastIndex)
                      Container(
                        margin: EdgeInsets.only(
                            top: 2, bottom: 1, left: screenWidth * 0.027),
                        width: 1,
                        height: 30,
                        color: Color(0xFFD9D9D9),
                      )
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactions() {
    final List<Map<String, String>> transactions = [
      {
        "Loan Taken": "₹50,000",
        "Monthly EMI": "₹1,858",
        "Loan ID": "XXXXX",
        "EMI Date": "3rd Every Month",
      },
      {
        "Loan Taken": "₹50,000",
        "Monthly EMI": "₹1,858",
        "Loan ID": "XXXXX",
        "EMI Date": "3rd Every Month",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding:
              const EdgeInsets.only(top: 16, bottom: 16, left: 24, right: 24),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Color(0xFFFFFFFF).withOpacity(0.30),
              border: Border.all(
                color: Color(0xFF2A63A6).withOpacity(0.30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction["Loan Taken"]!,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Monthly EMI",
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction["Monthly EMI"]!,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
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
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction["Loan ID"]!,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "EMI Date",
                          style: TextStyle(
                            color: Color(0xFF6B7280),
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          transaction["EMI Date"]!,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontWeight: FontWeight.w600,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
