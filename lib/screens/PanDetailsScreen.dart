import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/student/selfie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../classes/dashedborder.dart';
import '../model/SubmittDataModel.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';
import 'dart:developer' as developer;

class PanDetails extends StatefulWidget {
  final bool isworkdetailsCompleted;
  final String from;
  const PanDetails({super.key, required this.isworkdetailsCompleted,required this.from});
  @override
  State<PanDetails> createState() => _PanDetailsState();
}

class _PanDetailsState extends State<PanDetails> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();

  var pan_status = false;
  String pan_image = "";
  var upload_pan_image = false;
  var upload_aadhar_image = false;
  var aadhar_status = false;

  bool _isFormatting = false;
  var _validateaadhar = "";
  var _validatePAN = "";
  String OTP = "";
  String transid = "";
  bool panverifying = false;
  bool aadharverifying = false;
  bool aadharOTPverifying = false;
  String validateOtp="";

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    _aadhaarController.addListener(() {
      if (!_isFormatting) {
        setState(() {
          _isFormatting = true;
          _formatAadhaarNumber();
          _isFormatting = false;
        });
      }
    });
    GetKycDetails();
    KycProcessStatus();
  }

  Future<void> KycProcessStatus() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.KycProcessStatusapi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if(data?.settings?.success==1) {
              if (data?.data?.result?.isAdhaarVerified == true) {
                aadhar_status = true;
              }
              if (data?.data?.result?.isPanImageUploaded == true) {
                upload_pan_image = true;
              }
              if (data?.data?.result?.isPanVerified == true) {
                pan_status = true;
              }
              if (data?.data?.result?.isAadharImageUploaded == true) {
                upload_aadhar_image = true;
              }
            }
          })
        }
    });
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

  void _formatAadhaarNumber() {
    String text = _aadhaarController.text;
    text = text.replaceAll(' ', ''); // Remove any existing spaces
    if (text.length > 12) {
      text = text.substring(0, 12); // Limit to 12 characters
    }
    String formattedText = '';
    for (int i = 0; i < text.length; i++) {
      formattedText += text[i];
      if ((i + 1) % 4 == 0 && i != text.length - 1) {
        formattedText += ' '; // Add space after every 4 characters
      }
    }
    _aadhaarController.value = _aadhaarController.value.copyWith(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
      composing: TextRange.empty,
    );
  }

  Future<void> VerifyPanNumber() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.VerifyPanNumberApi(_panController.text, Userid!)
        .then((data) => {
              if (data != null)
                {
                  setState(() {
                    if (data.success == 1) {
                      pan_status = true;
                      panverifying = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "PAN number Verified successfully!",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                    } else {
                      panverifying = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Please enter a valid PAN number.",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                    }
                  })
                }
            });
  }

  Future<void> VerifyAadharNumber() async {
    await UserApi.VerifyAaadharNumberApi(_aadhaarController.text)
        .then((data) => {
              if (data != null)
                {
                  setState(() {
                    if (data.settings?.success == 1) {
                      aadharverifying=false;
                      transid = data.data?.result?.tsTransId ?? '';
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "${data.settings?.message}",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                      _showBottomSheet(context);
                    }else {
                      aadharverifying = false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "${data.settings?.message}",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                    }

                  })
                }
            });
  }

  // Future<void> VerifyAadharNumber1() async {
  //   await UserApi.VerifyAaadharNumberApi(_aadhaarController.text)
  //       .then((data) => {
  //             if (data != null)
  //               {
  //                 setState(() {
  //                   if (data.settings?.success == 1) {
  //                     transid = data.data?.result?.tsTransId ?? '';
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                       content: Text(
  //                         "OTP send to linked mobile number!",
  //                         style: TextStyle(color: Color(0xff000000)),
  //                       ),
  //                       duration: Duration(seconds: 1),
  //                       backgroundColor: Color(0xFFCDE2FB),
  //                     ));
  //                   }else{
  //                     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
  //                       content: Text(
  //                         "${data.settings?.message}!",
  //                         style: TextStyle(color: Color(0xff000000)),
  //                       ),
  //                       duration: Duration(seconds: 1),
  //                       backgroundColor: Color(0xFFCDE2FB),
  //                     ));
  //                   }
  //                 })
  //               }
  //           });
  // }


  Future<void> GetKycDetails() async {
    try {
      var Userid = await PreferenceService().getString('user_id');
      var data = await UserApi.GetKycDetailsApi(Userid!);

      if (data != null) {
        setState(() {
          if (data.settings?.success == 1) {
            _panController.text = data.data?.result?.pan ?? "";
            _aadhaarController.text = data.data?.result?.adhaar ?? "";
            pan_image = data.data?.result?.pan_img_path ?? "";
          } else {
            // Handle cases where success is not 1
            print("Failed to fetch KYC details");
          }
        });
      } else {
        // Handle the case where data is null
        print("No data received from API");
      }
    } catch (e) {
      // Handle different types of exceptions here
      if (e is TimeoutException) {
        // Handle timeout exception
        print("Request timed out");
      } else if (e is SocketException) {
        // Handle network issues
        print("Network error: ${e.message}");
      } else {
        // Handle other exceptions
        print("An error occurred: ${e.toString()}");
      }
    }
  }

  XFile? _imageFile;
  // Function to pick image from camera or gallery
  Future<void> _pickImage(ImageSource source) async {
    var Userid = await PreferenceService().getString('user_id');
    XFile? selected = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile = selected;
    });
    SubmittDataModel? data = await UserApi.UploadPanImageApi(File(selected!.path), Userid!);
    if (data != null && data.success == 1) {
      setState(() {
        upload_pan_image = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "PAN image Uploaded successfully!",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${data?.message}",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    }
  }

  XFile? _imageFile1;
  // Function to pick image from camera or gallery
  Future<void> _pickImage1(ImageSource source) async {
    var Userid = await PreferenceService().getString('user_id');
    XFile? selected = await ImagePicker().pickImage(source: source);
    setState(() {
      _imageFile1 = selected;
    });
    SubmittDataModel? data = await UserApi.UploadAadharImageApi(File(selected!.path), Userid!);
    if (data != null && data.success == 1) {
      setState(() {
        upload_aadhar_image = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Aadhar image Uploaded successfully!",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "${data?.message}",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (isDeviceConnected == "ConnectivityResult.wifi" ||
            isDeviceConnected == "ConnectivityResult.mobile")
        ?
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
                      child: Text(
                        "Pan Details",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 12, right: 12, top: 10, bottom: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildStep(0),
                          _buildSeparator(0),
                          _buildStep(1),
                          _buildSeparator(1),
                          _buildStep(2),
                          _buildSeparator(2),
                          _buildStep(3),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Text(
                          "Basic",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        )),
                        Expanded(
                            child: Center(
                                child: Text(
                          "Work",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ))),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          "KYC",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ))),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                            child: Center(
                                child: Text(
                          "Documents",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ))),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: const Color(0xFFCDE2FB).withOpacity(0.25),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Pan Card Details",
                              style: TextStyle(
                                color: Color(0xFF000000),
                                fontFamily: 'Poppins',
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 30),
                             Text((widget.from=="Student")? "Pan Card Number(Gaurdian)":"Pan Card Number",
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: "Inter",
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(color: Color(0xffCDE2FB))),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: TextFormField(
                                      controller: _panController,
                                      cursorColor: Colors.black,
                                      keyboardType: TextInputType.text,
                                      readOnly: pan_status,
                                      textCapitalization:
                                          TextCapitalization.characters,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'^[A-Z0-9]+$')),
                                        LengthLimitingTextInputFormatter(10),
                                      ],
                                      onTap: () {
                                        setState(() {
                                          _validatePAN = "";
                                        });
                                      },
                                      style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        height: 1.2,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      decoration: InputDecoration(
                                        hintText:(widget.from=="Student")?"Enter gaurdian PAN Number":"Enter your PAN Number",
                                        hintStyle: TextStyle(
                                          fontSize: 15,
                                          letterSpacing: 0,
                                          height: 1.2,
                                          color: Color(0xffAFAFAF),
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                        ),
                                        filled: true,
                                        fillColor: Color(0xffffffff),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              width: 1, color: Color(0xffffffff)),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          borderSide: BorderSide(
                                              width: 1, color: Color(0xffffffff)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  InkWell(
                                      onTap: () {
                                        if(pan_status==false) {
                                          if (panverifying) {
                                          } else {
                                            setState(() {
                                              panverifying = true;
                                            });
                                            if (_panController.text.length < 10) {
                                              setState(() {
                                                panverifying = false;
                                                _validatePAN =
                                                "Please enter a valid PAN number";
                                              });
                                            } else {
                                              VerifyPanNumber();
                                            }
                                          }
                                        }
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            top: 6,
                                            bottom: 6),
                                        decoration: BoxDecoration(
                                          color: (pan_status)
                                              ? Color(0x3D38A106)
                                              : Color(0xff24B0FF),
                                          borderRadius: BorderRadius.circular(5),
                                        ),
                                        child: panverifying
                                            ? SizedBox(
                                                width:
                                                    20.0, // Adjust the width as needed
                                                height:
                                                    20.0, // Adjust the height as needed
                                                child: CircularProgressIndicator(
                                                  strokeWidth:
                                                      2, // Adjust the stroke width as needed
                                                  valueColor:
                                                      AlwaysStoppedAnimation<
                                                          Color>(Colors.white),
                                                ),
                                              )
                                            : Text(
                                                (pan_status)
                                                    ? "Verified"
                                                    : "Verify",
                                                style: TextStyle(
                                                  fontFamily: "Inter",
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w400,
                                                  color: (pan_status)
                                                      ? Color(0xFF38A106)
                                                      : Color(0xFFffffff),
                                                ),
                                              ),
                                      )),
                                ],
                              ),
                            ),
                            if (_validatePAN.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin:
                                    EdgeInsets.only(left: 8, bottom: 10, top: 5),
                                width: screenWidth * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validatePAN,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 35, right: 35, top: 20, bottom: 55),
                              child: InkWell(
                                onTap: () {
                                  // if(upload_aadhar_image){
                                  // }else{
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SafeArea(
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text('Take a photo'),
                                                onTap: () {
                                                  _pickImage(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.photo_library),
                                                title: Text('Choose from gallery'),
                                                onTap: () {
                                                  _pickImage(ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                    //}
                                },
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Container color
                                  ),
                                  child: CustomPaint(
                                    painter: DashedBorderPainter(
                                      color: Color(0xFFBBBBBB),
                                      width: 2.0,
                                      dashWidth: 3.5,
                                      dashSpace: 4.0,
                                    ),
                                    child: Center(
                                      child: _imageFile == null
                                          ? Text((widget.from=="Student")? "Upload gaurdian Pan Image":"Upload Pan Image",
                                              style: TextStyle(
                                                color: Color(0xFFBBBBBB),
                                                fontFamily: "Inter",
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            )
                                          : Image.file(
                                              File(_imageFile!.path),
                                              height: 105,
                                              width: 205,
                                              fit: BoxFit.fill,
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 35, right: 35, top: 20, bottom: 55),
                              child: InkWell(
                                onTap: () {
                                  // if(upload_aadhar_image){
                                  // }else{
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SafeArea(
                                          child: Wrap(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.camera_alt),
                                                title: Text('Take a photo'),
                                                onTap: () {
                                                  _pickImage1(ImageSource.camera);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                              ListTile(
                                                leading: Icon(Icons.photo_library),
                                                title: Text('Choose from gallery'),
                                                onTap: () {
                                                  _pickImage1(ImageSource.gallery);
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                //  }

                                },
                                child: Container(
                                  height: 110,
                                  decoration: BoxDecoration(
                                    color: Colors.white, // Container color
                                  ),
                                  child: CustomPaint(
                                    painter: DashedBorderPainter(
                                      color: Color(0xFFBBBBBB),
                                      width: 2.0,
                                      dashWidth: 3.5,
                                      dashSpace: 4.0,
                                    ),
                                    child: Center(
                                      child: _imageFile1 == null
                                          ? Text((widget.from=="Student")? "Upload gaurdian Aadhar Image":"Upload Aadhar Image",
                                        style: TextStyle(
                                          color: Color(0xFFBBBBBB),
                                          fontFamily: "Inter",
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      )
                                          : Image.file(
                                        File(_imageFile1!.path),
                                        height: 105,
                                        width: 205,
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                             Text((widget.from=="Student")? "Aadhaar Number(Gaurdian)":"Aadhaar Number",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                fontFamily: "Inter",
                                color: Color(0xFF374151),
                              ),
                            ),
                            const SizedBox(height: 4),
                            TextFormField(
                              controller: _aadhaarController,
                              cursorColor: Colors.black,
                              keyboardType: TextInputType.number,
                              readOnly: aadhar_status,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onTap: () {
                                _validateaadhar = "";
                              },
                              style: TextStyle(
                                fontSize: 16,
                                letterSpacing: 0,
                                height: 1.2,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
                              ),
                              decoration: InputDecoration(
                                hintText:(widget.from=="Student")?"Enter gaurdian 12 digit Aadhaar number": "Enter your 12 digit Aadhaar number",
                                hintStyle: TextStyle(
                                  fontSize: 15,
                                  letterSpacing: 0,
                                  height: 1.2,
                                  color: Color(0xffAFAFAF),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Color(0xffffffff),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xffCDE2FB)),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(
                                      width: 1, color: Color(0xffCDE2FB)),
                                ),
                              ),
                            ),
                            if (_validateaadhar.isNotEmpty) ...[
                              Container(
                                alignment: Alignment.topLeft,
                                margin:
                                    EdgeInsets.only(left: 8, bottom: 10, top: 5),
                                width: screenWidth * 0.6,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    _validateaadhar,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 12,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ] else ...[
                              const SizedBox(
                                height: 15,
                              ),
                            ],
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Color(0x3D38A106),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: InkWell(
                                    onTap: () {
                                      if(aadhar_status==false) {
                                        if (aadharverifying) {

                                        } else {
                                          setState(() {
                                            aadharverifying = true;
                                          });
                                          if (_aadhaarController.text.length <
                                              13) {
                                            setState(() {
                                              _validateaadhar =
                                              "Please enter valid aadhar number";
                                              aadharverifying = false;
                                            });
                                          } else {
                                            VerifyAadharNumber();
                                          }
                                        }
                                      }
                                    },
                                    child:aadharverifying
                                        ? SizedBox(
                                      width:
                                      15.0, // Adjust the width as needed
                                      height:
                                      15.0, // Adjust the height as needed
                                      child: CircularProgressIndicator(
                                        strokeWidth:
                                        2, // Adjust the stroke width as needed
                                        valueColor:
                                        AlwaysStoppedAnimation<
                                            Color>(Colors.white),
                                      ),
                                    )
                                        :
                                    Text(
                                      (aadhar_status) ? "Verified" : "Send OTP",
                                      style: TextStyle(
                                        color: Color(0xFF38A106),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
                                  if (!pan_status) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please verify PAN number.",
                                          style: TextStyle(color: Color(0xff000000)),
                                        ),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFFCDE2FB),
                                      ),
                                    );
                                  }  else if (!upload_pan_image) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please upload PAN image.",
                                          style: TextStyle(color: Color(0xff000000)),
                                        ),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFFCDE2FB),
                                      ),
                                    );
                                  } else if (!upload_aadhar_image) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please upload Aadhar image.",
                                          style: TextStyle(color: Color(0xff000000)),
                                        ),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFFCDE2FB),
                                      ),
                                    );
                                  }
                                  else if (!aadhar_status) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          "Please verify Aadhar number.",
                                          style: TextStyle(color: Color(0xff000000)),
                                        ),
                                        duration: Duration(seconds: 1),
                                        backgroundColor: Color(0xFFCDE2FB),
                                      ),
                                    );
                                  }
                                  else {
                                    var res= await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const UploadSelfie(),
                                      ),
                                    );
                                    if(res==true){
                                      GetKycDetails();
                                      KycProcessStatus();
                                    }
                                  }

                                },
                                child: Container(
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
                  ],
                ),
              ),
            ),
    )
        : NoInternetWidget();
  }

  Widget _buildStep(int stepIndex) {
    bool isCompleted = (widget.isworkdetailsCompleted) && stepIndex < 2;
    Color stepColor =
        isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: stepColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: isCompleted
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              )
            : Text(
                (stepIndex + 1).toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSeparator(int separatorIndex) {
    bool isCompleted = (widget.isworkdetailsCompleted) && separatorIndex < 2;
    Color separatorColor =
        isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
    return Expanded(
      child: Container(
        height: 2,
        color: separatorColor,
        alignment: Alignment.center,
      ),
    );
  }

  void _showBottomSheet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    final TextEditingController otpController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            bool recieving=false;
            Future<void> VerifyAadharOTP(otp) async {
              var Userid = await PreferenceService().getString('user_id');
              await UserApi.VerifyAadharOTPApi(
                  _aadhaarController.text,otp, transid, Userid!)
                  .then((data) => {
                if (data != null)
                  {
                    setState(() {
                      if (data.settings?.success == 1) {
                        aadharOTPverifying=false;
                        aadhar_status = true;
                        KycProcessStatus();
                        Navigator.pop(context);
                        upload_pan_image = true;
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "Aadhar Verified successfully!",
                            style: TextStyle(color: Color(0xff000000)),
                          ),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color(0xFFCDE2FB),
                        ));
                      }else{
                        aadharOTPverifying=false;
                        validateOtp="Please Enter a valid OTP recieved on your linked mobile number";
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "${data.settings?.message}!",
                            style: TextStyle(color: Color(0xff000000)),
                          ),
                          duration: Duration(seconds: 1),
                          backgroundColor: Color(0xFFCDE2FB),
                        ));
                      }
                    })
                  }
              });
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 35),
                          Text(
                            "Enter Aadhar OTP",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          SizedBox(height: 30),
                          PinCodeTextField(
                            autoFocus: true,
                            autoUnfocus: true,
                            appContext: context,
                            controller: otpController,
                            length: 6,
                            onTap: (){
                              setState(() {
                                validateOtp="";
                              });
                            },
                            onChanged: (v){
                              setState(() {
                                validateOtp="";
                              });
                            },
                            pinTheme: PinTheme(
                              shape: PinCodeFieldShape.box,
                              borderRadius: BorderRadius.circular(50),
                              fieldHeight: 48,
                              fieldWidth: 48,
                              fieldOuterPadding: EdgeInsets.only(left: 0, right: 5),
                              activeFillColor: Color(0xFFF4F4F4),
                              activeColor: Color(0xff2DB3FF),
                              selectedColor: Color(0xff2DB3FF),
                              selectedFillColor: Color(0xFFF4F4F4),
                              inactiveFillColor: Color(0xFFF4F4F4),
                              inactiveColor: Color(0xFFD2D2D2),
                              inactiveBorderWidth: 1.5,
                              selectedBorderWidth: 2.2,
                              activeBorderWidth: 2.2,
                            ),
                            textStyle: TextStyle(
                              fontFamily: "Inter",
                              fontSize: 17,
                              fontWeight: FontWeight.w400,
                            ),
                            cursorColor: Colors.black,
                            enableActiveFill: true,
                            keyboardType: TextInputType.numberWithOptions(),
                            textInputAction: TextInputAction.done,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            boxShadows: const [
                              BoxShadow(
                                offset: Offset(0, 1),
                                color: Colors.black12,
                                blurRadius: 10,
                              )
                            ],
                            enablePinAutofill: true,
                            useExternalAutoFillGroup: true,
                            beforeTextPaste: (text) {
                              return true;
                            },
                          ),
                          if (validateOtp.isNotEmpty) ...[
                            Center(
                              child: Container(
                                alignment: Alignment.topLeft,
                                margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                                width: screenWidth * 0.85,
                                child: ShakeWidget(
                                  key: Key("value"),
                                  duration: Duration(milliseconds: 700),
                                  child: Text(
                                    validateOtp,
                                    style: TextStyle(
                                      fontFamily: "Poppins",
                                      fontSize: 13,
                                      color:Colors.red,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ] else ...[
                            const SizedBox(
                              height: 40,
                            ),
                          ],
                          SizedBox(height: 40),
                          Center(
                            child: GestureDetector(
                              onTap: () async {
                                if(aadharOTPverifying){

                                }else{
                                  setState(() {
                                    aadharOTPverifying=true;
                                  });
                                  if(otpController.text.length>=6) {
                                    VerifyAadharOTP(otpController.text);
                                  }else{
                                    setState(() {
                                      validateOtp="Please Enter a valid OTP recieved on your linked mobile number.";
                                      aadharOTPverifying=false;
                                    });
                                  }
                                }

                              },
                              child: Padding(
                                padding: const EdgeInsets.all(24),
                                child: Container(
                                  height: 56,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    color: const Color(0xFF2DB3FF),
                                  ),
                                  child: Center(
                                    child: (aadharOTPverifying)
                                        ? CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                    )
                                        :
                                    Text(
                                      "Submit",
                                      style: TextStyle(
                                        color: Color(0xFFFFFFFF),
                                        fontSize: 20,
                                        fontFamily: "Inter",
                                        letterSpacing: 1,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.only(top: 10),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         "Didn’t receive the OTP?",
                          //         style: TextStyle(
                          //           fontSize: 14,
                          //           fontFamily: 'Poppins',
                          //           fontWeight: FontWeight.w400,
                          //           color: Color(0xFF4F4F4F),
                          //         ),
                          //       ),
                          //       SizedBox(width: 4),
                          //       GestureDetector(
                          //         onTap: () {
                          //           VerifyAadharNumber1();
                          //         },
                          //         child: Text(
                          //           "Resend",
                          //           style: TextStyle(
                          //             fontSize: 14,
                          //             fontFamily: 'Poppins',
                          //             fontWeight: FontWeight.w700,
                          //             color: Color(0xFF000000),
                          //             decoration: TextDecoration.underline,
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: MediaQuery.of(context).size.width * 0.89,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop(); // Close the bottom sheet
                      },
                      child: Container(
                        height: 35,
                        width: 35,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey[300],
                        ),
                        child: Icon(
                          Icons.close,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      validateOtp="";
      otpController.text="";
    });
  }
}
