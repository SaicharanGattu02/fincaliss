import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/PendingScreen.dart';
import 'package:fincalis/screens/banktransfer.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../utils/Preferances.dart';
import 'ReferencesScreen.dart';
import 'StudentFriendReference.dart';
import 'package:path/path.dart' as p; // Import the path package

class BankDetailsScreen extends StatefulWidget {
  final bool isKycCompleted;
  const BankDetailsScreen({Key? key, required this.isKycCompleted}) : super(key: key);

  @override
  _BankDetailsScreenState createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final TextEditingController _panController = TextEditingController();
  File? filepath;
  String filename="";
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
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


  void _openFilePicker() async {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf'],
      );
      if (result != null) {
        PlatformFile file = result.files.first;
        setState(() {
          filepath = File(file.path!);
          filename= p.basename(file.path!);
        });
        print("Pdf Doc: ${file}");
      } else {
        print('User canceled the file picking');
      }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Permission Required'),
          content: Text('This app needs storage permission to access files. Please grant the permission to proceed.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _openFilePicker(); // Optionally, you can ask for permission again
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

  Future<void> UploadBankStatement(File file) async {
    var Userid = await PreferenceService().getString('user_id');
    if (Userid != null) {
      await UserApi.UploadBankStatementApi(file, Userid).then((data) {
        if (data != null) {
          setState(() {
            if (data.success == 1) {
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Bank statement uploaded successfully!",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) =>MyBankTransfer()), // Replace with your next screen
              );
            }else{
              _isLoading = false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "${data.message}",
                  style: TextStyle(color: Color(0xff000000)),
                ),
                duration: Duration(seconds: 1),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }
          });
        }
      });
    } else {
      print('Error: Userid is null');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
      Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Text(
            "Bank Details",
            style: TextStyle(
              color: Colors.black,
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min, // Ensures that the Column takes only as much space as needed
          children: [
            Align(
              alignment: Alignment.center, // Center the Container vertically
              child: Container(
                margin: EdgeInsets.all(24),
                padding: EdgeInsets.only(top: 30, left: 10, right: 10, bottom: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFCDE2FB).withOpacity(0.25),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Upload Your Bank Statement",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Poppins',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Bank Statement",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: (){
                        _openFilePicker();
                      },
                      child: Container(
                        padding: EdgeInsets.only(top: 8, left: 10, right: 20, bottom: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: Color(0xffD1D5DB)),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Container(
                              width:screenWidth*0.62,
                              child: Text(
                                filename != ""
                                    ? "${filename}"
                                    : "Upload Your Bank Statement",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color:filename != ""?Color(0xff000000): Color(0xffD1D5DB),
                                  fontFamily: 'Poppins',
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ),
                            Spacer(),
                            Image.asset(
                              "assets/import_icon.png",
                              width: 30,
                              height: 35,
                            )
                          ],
                        ),
                      ),
                    ),
                    // filepath == null
                    //     ? Padding(
                    //   padding: const EdgeInsets.only(top: 50),
                    //   child: Center(
                    //     child: Container(
                    //       height: 305,
                    //       width: 260,
                    //       decoration: BoxDecoration(color: Color(0xFFFFFFFF)),
                    //       child: Column(
                    //         mainAxisAlignment: MainAxisAlignment.center,
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           Icon(
                    //             Icons.cloud_upload_outlined,
                    //             size: 55,
                    //           ),
                    //           SizedBox(height: 10),
                    //           InkWell(
                    //             onTap: (){
                    //               _openFilePicker();
                    //             },
                    //             child:Text.rich(
                    //               TextSpan(
                    //                 children: [
                    //                   TextSpan(
                    //                     text:
                    //                     "Drag and drop photo here Or \n Just Click For ",
                    //                     style: TextStyle(
                    //                       color: Color(0xFF000000),
                    //                       fontWeight: FontWeight.w400,
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: "Browse",
                    //                     style: TextStyle(
                    //                       color: Color(0xFF24B0FF),
                    //                       fontWeight: FontWeight.w500,
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                   TextSpan(
                    //                     text: " File",
                    //                     style: TextStyle(
                    //                       color: Color(0xFF000000),
                    //                       fontWeight: FontWeight.w400,
                    //                       fontSize: 14,
                    //                     ),
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // )
                    //     : Column(
                    //   crossAxisAlignment: CrossAxisAlignment.center,
                    //   children: [
                    //     Container(
                    //       height: 480,
                    //       width: MediaQuery.of(context).size.width,
                    //       child: PDFView(
                    //         filePath: filepath!.path,
                    //         autoSpacing: false,
                    //         enableSwipe: false,
                    //         pageSnap: false,
                    //         defaultPage: 0,
                    //         fitEachPage: false,
                    //         onRender: (pages) {
                    //           setState(() {
                    //
                    //           }); // Update UI after rendering
                    //         },
                    //         onViewCreated: (PDFViewController pdfViewController) {
                    //           pdfViewController.setPage(0); // Display only the first page
                    //         },
                    //         onError: (error) {
                    //           print(error.toString());
                    //         },
                    //         onPageError: (page, error) {
                    //           print('$page: ${error.toString()}');
                    //         },
                    //       ),
                    //     ),
                    //   ],
                    // ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add top margin
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          if(_isLoading){

                          }else{
                            setState(() {
                              _isLoading=true;
                            });
                            if(filepath!=null) {
                              UploadBankStatement(filepath!);
                            }else{
                              setState(() {
                                _isLoading=false;
                              });
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                                  "Please upload bank statement!",
                                  style: TextStyle(color: Color(0xff000000)),
                                ),
                                duration: Duration(seconds: 1),
                                backgroundColor: Color(0xFFCDE2FB),
                              ));
                            }
                          }
                        },
                        child: Container(
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xFF2DB3FF),
                          ),
                          child: Center(
                            child:_isLoading
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
                  ],
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.2), // Add bottom margin
          ],
        ),
      ),
    ):
      NoInternetWidget();
  }
}
