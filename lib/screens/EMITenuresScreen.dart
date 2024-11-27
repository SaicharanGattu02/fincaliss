import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/classes/emi.dart';
import 'package:fincalis/screens/enach.dart';
import 'package:fincalis/screens/pendingDisbursalScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import 'dart:developer' as developer;
import '../utils/Preferances.dart';
import 'PendingScreen.dart';
import 'package:http/http.dart' as http;
import 'banktransfer.dart';

class EMITenuresScreen extends StatefulWidget {
  final loanamount;
  const EMITenuresScreen({super.key, required this.loanamount});

  @override
  State<EMITenuresScreen> createState() => _EMITenuresScreenState();
}

class _EMITenuresScreenState extends State<EMITenuresScreen> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  double _loanAmount=0;
  List<EmiDetails> emiDetails = [];
  double get amount => (_loanAmount+3000.0) / 9.0;

  double _maxLoanAmount=0;
  double _minLoanAmount=0;

  @override
  void initState() {
    super.initState();
    setState(() {
      _maxLoanAmount = widget.loanamount;
      _minLoanAmount = widget.loanamount/2;
      _loanAmount = widget.loanamount;
    });
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _generateEmiDetails();
    setState(() {
      is_loading=true;
    });
    LoanApplication1();
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

  List<String>? emiRepayDate=[];
  String tenure="";
  double totalLoanAmount=0.0;
  double loanApproved=0.0;
  double processingFee=0.0;
  double gatewayFee=0.0;
  double additionalFee=0.0;
  double monthlyEmi=0;
  var is_loading = false;
   bool _loading=false;

  Future<void> LoanApplication() async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.LoanApplicationApi(_loanAmount.toInt(),monthlyEmi.toInt(),Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.success == 1) {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MyNach()));
            } else{

            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

  Future<void> LoanApplication1() async {
    var Userid = await PreferenceService().getString('user_id');

    if (Userid != null) {
      await UserApi.SelectLoanAmountApi(_loanAmount.toInt(),Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.settings?.success == 1) {
              is_loading=false;
              // Safely get emiDates from data
              final emiDates = data.data?.result?.emiDates;
              // Check if emiDates is not null before calling forEach
              if (emiDates != null) {
                emiDates.forEach((date, amount) {
                  // Format amount to 2 decimal places
                  final formattedAmount = amount.toStringAsFixed(2);
                  // Add EmiDetails instance to the list
                  emiDetails.add(EmiDetails(date, formattedAmount));
                });
                // Print the results (for verification)
                emiDetails.forEach((detail) {
                  // print('Date: ${detail.date}, Amount: ${detail.amount}');
                });
              } else {
                print('EMI Dates is null');
              }
              emiRepayDate=data.data?.result?.emiRepayDate;
              tenure=data.data?.result?.tenure??"";
              totalLoanAmount=data.data?.result?.totalLoanAmount??0.0;
              loanApproved=data.data?.result?.loanApproved??0.0;
              processingFee=data.data?.result?.processingFee??0.0;
              gatewayFee=data.data?.result?.gatewayFee??0.0;
              additionalFee=data.data?.result?.additionalFee??0.0;
              monthlyEmi=data.data?.result?.monthlyEmi??0.0;
            } else{
              is_loading=false;
            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

// Updated _generateEmiDetails method
  void _generateEmiDetails() {
    emiDetails.clear();
    DateTime now = DateTime.now();
    DateTime startDate;

    if (now.day <= 1) {
      // If today is before or on the 1st, start EMI from the 2nd of this month
      startDate = DateTime(now.year, now.month, 2);
    } else {
      // Otherwise, start EMI from the 2nd of the next month
      startDate = DateTime(now.year, now.month + 1, 2);
    }

    for (int i = 0; i < 9; i++) {
      DateTime emiDate = DateTime(startDate.year, startDate.month + i, 2);

      // Format the date as "15th Jul 2024"
      String daySuffix = getDaySuffix(emiDate.day);
      String formattedDate = DateFormat("d MMM yyyy").format(emiDate);
      formattedDate = formattedDate.replaceFirst(RegExp(r'\d+'), '${emiDate.day}$daySuffix');
      emiDetails.add(EmiDetails(formattedDate, amount.toStringAsFixed(2)));
    }
  }


  @override
  Widget build(BuildContext context) {
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
      Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
            ),
            const SizedBox(width: 17),
            Expanded(
              child: Image.asset(
                "assets/cong.png",
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
      ),
      body: is_loading
        ? Center(child: CircularProgressIndicator(color: Color(0xff24B0FF),))
        : SingleChildScrollView(
          child:
          Padding(
            padding: const EdgeInsets.only(top: 30,left: 15,right: 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Choose The Loan Amount you need",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "${_loanAmount.toStringAsFixed(0)}",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                    Border.all(color: Color(0xFFD1D5DB).withOpacity(0.50)),
                  ),
                  child: Slider(
                    value: _loanAmount,
                    activeColor: Color(0xff24B0FF),
                    inactiveColor: Colors.grey,
                    min: _minLoanAmount,
                    max: _maxLoanAmount,
                    // divisions: 10,
                    onChanged: (value) {
                      setState(() {
                        _loanAmount = value;
                      });
                    },
                    onChangeEnd: (value){
                      setState(() {
                        _loanAmount = value;
                        print("LOAN amount:${value}");
                        print("LOAN amount:${_loanAmount}");
                        is_loading=true;
                        emiDetails=[];
                        Future.delayed(Duration(milliseconds: 750), () {
                          LoanApplication1();
                        });
                      });
                    },
                    label: _loanAmount.round().toString(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 43,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Loan Amount",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(color: Color(0xFF24B0FF)),
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        color: Color(0xFF24B0FF),
                      ),
                      Container(
                        height: 43,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "₹${_loanAmount.toStringAsFixed(0)}",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 43,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Monthly EMI",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(color: Color(0xFF24B0FF)),
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        color: Color(0xFF24B0FF),
                      ),
                      Container(
                        height: 43,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "₹${monthlyEmi}",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 43,
                        width: 150,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "Tenures",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 16,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          decoration: BoxDecoration(color: Color(0xFF24B0FF)),
                        ),
                      ),
                      Icon(
                        Icons.play_arrow,
                        color: Color(0xFF24B0FF),
                      ),
                      Container(
                        height: 43,
                        width: 120,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            "${tenure}",
                            style: TextStyle(
                                color: Color(0xFF000000),
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                Text(
                  "Monthly EMI Payments",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, bottom: 20, left: 50, right: 50),
                  child: Column(
                    children: emiDetails.map((emi) {
                      int index = emiDetails.indexOf(emi);
                      return Row(mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              emi.date,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            children: [
                              Container(
                                width: 20,
                                height: 20,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.blue,
                                ),
                              ),
                              if (index != emiDetails.length - 1)
                                Container(
                                  width: 2,
                                  height: 50,
                                  color: Colors.blue,
                                ),
                            ],
                          ),
                          Expanded(
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text('₹${emi.amount}'),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 43,
                        width: 170,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:18),
                            child: Row(
                              children: [
                                Text(
                                  "Processing Fee",
                                  style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 7),
                                //   child: Icon(Icons.info),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 43,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:33),
                            child: Text(
                              "₹${processingFee}",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        height: 43,
                        width: 170,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:18),
                            child: Row(
                              children: [
                                Text(
                                  "Additional Fee",
                                  style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 43,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:33),
                            child: Text(
                              "₹${additionalFee}",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Container(
                        width: 170,
                        height: 43,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:18),
                            child: Row(
                              children: [
                                Text(
                                  "Gateway Fee",
                                  style: TextStyle(
                                      color: Color(0xFF000000),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(left: 7),
                                //   child: Icon(Icons.info),
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Container(
                        height: 43,
                        decoration: BoxDecoration(
                          color: Color(0xFFE3EEFF),
                          border: Border.all(
                              color: Color(0xFF000000).withOpacity(0.25)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal:33),
                            child: Text(
                              "₹${gatewayFee}",
                              style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 24),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Amount Transferable",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF000000)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Text(
                              "subject to date to Disbursal",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF000000).withOpacity(0.50)),
                            ),
                          ),
                        ],
                      ),
                      Spacer(),
                      Text(
                        "₹${totalLoanAmount}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF000000).withOpacity(0.50)),
                      ),
                    ],
                  ),
                ),
                 SizedBox(height: 70),
                GestureDetector(
                  onTap: () {
                    if(_loading){

                    }else{
                      setState(() {
                        _loading=true;
                      });
                      LoanApplication();
                    }

                  },
                  child: Center(
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Color(0xFF2DB3FF),
                      ),
                      child: Center(
                        child:_loading
                            ? CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                            :
                        Text(
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
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
    ):
      NoInternetWidget();
  }
}