import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';

class Repaymenthistory extends StatefulWidget {
  const Repaymenthistory({Key? key}) : super(key: key);

  @override
  State<Repaymenthistory> createState() => _RepaymenthistoryState();
}

class _RepaymenthistoryState extends State<Repaymenthistory> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    GetTransactionHistory();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    super.initState();
  }


  Future<void> GetTransactionHistory() async {
    var Userid = await PreferenceService().getString('user_id');
    try {
      final data = await UserApi.GetTransactionHistoryApi(Userid!);
      if (data != null && data.settings?.success == 1) {

      } else {

      }
    } catch (e) {
      print('Error fetching school names: $e');
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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile" ) ?
      Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          leadingWidth: screenWidth, // Adjust this width as needed
          leading: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(width: 15),
              InkWell(
                onTap: (){
                  Navigator.pop(context);
                },
                child:  Icon(Icons.arrow_back, size: 30),
              ),
              SizedBox(width: 10), // Add some space between the icon and the text
              Expanded(
                child: Text(
                  "Transaction History",
                  overflow: TextOverflow.ellipsis, // Handles overflow by showing "..."
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ],
          ),
        ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child:
        Container(
          height: screenHeight*0.8,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
      //         Container(
      //           height: MediaQuery.of(context).size.height*0.86, // Set the desired height
      //           decoration: BoxDecoration(
      //             color: const Color(0xFFF2F8FA),
      //             borderRadius: BorderRadius.circular(10),
      //           ),
      //           child:GridView.builder(
      //             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
      //               crossAxisCount: 1, // Number of columns
      //               childAspectRatio: 3, // Aspect ratio of each child
      //             ),
      //             itemCount: 10,
      //             shrinkWrap: true,// Number of items in the grid
      //             itemBuilder: (context, index) {
      //               final isLastItem = index == 9;
      //               return Padding(
      //                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
      //                 child: Column(
      //                   crossAxisAlignment: CrossAxisAlignment.start,
      //                   children: [
      //                     Row(
      //                       crossAxisAlignment: CrossAxisAlignment.start,
      //                       children: [
      //                         Container(
      //                           height: 30,
      //                           width: 30,
      //                           decoration: BoxDecoration(
      //                             color: Colors.white,
      //                             borderRadius: BorderRadius.circular(7.2),
      //                           ),
      //                           child: Icon(
      //                             index % 2 == 0 ? Icons.access_time : Icons.close,
      //                             size: 22.5,
      //                             color: index % 2 == 0 ? Color(0xFFFF2709) : Color(0xFF0766FF),
      //                           ),
      //                         ),
      //                         const SizedBox(width: 10),
      //                         Column(
      //                           crossAxisAlignment: CrossAxisAlignment.start,
      //                           children: [
      //                             Text(
      //                               "Pending",
      //                               style: TextStyle(
      //                                 color: Color(0xFF374151),
      //                                 fontSize: 18,
      //                                 fontWeight: FontWeight.w500,
      //                               ),
      //                             ),
      //                             const SizedBox(height: 4),
      //                             Text(
      //                               "Apr 27, 2024 18:34",
      //                               style: TextStyle(
      //                                 color: Color(0xFF6B7280),
      //                                 fontSize: 12,
      //                                 fontWeight: FontWeight.w500,
      //                               ),
      //                             ),
      //                           ],
      //                         ),
      //                         Spacer(),
      //                         Text(
      //                           "₹2000",
      //                           style: TextStyle(
      //                             color: index % 2 == 0 ? Color(0xFFFF2709) : Color(0xFF0766FF),
      //                             fontSize: 18,
      //                             fontWeight: FontWeight.w500,
      //                           ),
      //                         ),
      //                       ],
      //                     ),
      //                     const SizedBox(height: 20),
      //                     if (!isLastItem)
      //                     Container(
      //                       height: 2,
      //                       width: MediaQuery.of(context).size.width,
      //                       decoration: BoxDecoration(
      //                         border: Border.all(
      //                           color: Color(0xFF000000).withOpacity(0.10),
      //                         ),
      //                       ),
      //                     ),
      //                   ],
      //                 ),
      //               );
      //             },
      //           ),
      // ),

              Center(
                child: Text("No data found!",
                  style:TextStyle(
                    fontSize: 24,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600
                  ),
                ),
              )


            ],
          ),
        ),
      ),
    ):
      NoInternetWidget();
  }
}
