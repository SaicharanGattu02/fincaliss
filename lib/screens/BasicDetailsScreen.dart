import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/business/BusinessDetailsScreen1.dart';
import 'package:fincalis/employe/EmployeeDetailsScreen.dart';
import 'package:fincalis/student/StudentDetailsScreen.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../classes/FirstLetterCaps.dart';
import '../model/BasicDetailsModel.dart';
import '../utils/Preferances.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;
import '../utils/ShakeWidget.dart';

class BasicDetails extends StatefulWidget {
  const BasicDetails({Key? key}) : super(key: key);
  @override
  State<BasicDetails> createState() => _BasicDetailsState();
}

class _BasicDetailsState extends State<BasicDetails> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _fathernameController = TextEditingController();
  final TextEditingController _mothernameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _adressController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FocusNode _fullnameFocus = FocusNode();
  final FocusNode _fathernameFocus = FocusNode();
  final FocusNode _mothernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _addressFocus = FocusNode();
  final FocusNode _pincodeFocus = FocusNode();

  bool male = false;
  bool female = false;
  bool others = false;
  bool student = false;
  bool business = false;
  bool employee = false;
  bool isbasicCompleted = false;
  String? maritalStatus;
  String? purposeOfLoan;
  String profession="";
  String gender="";
  bool _isContinueClicked = false;
  bool _isLoading = false;
  var is_loading = true;
  bool isfetched = false;
  var status = "";
   bool is_update=false;

  String _validateFullName = "";
  String _validateFatherName = "";
  String _validateMotherName = "";
  String _validateDob = "";
  String _validateMaritalstatus = "";
  String _validateAddress = "";
  String _validatePincode = "";
  String _validatePurposeofloan = "";
  String _validateGender = "";
  String _validateProfession = "";
  String _validateEmail = "";

  @override
  void initState() {
    super.initState();
     GetBasicDetails();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _fathernameController.dispose();
    _mothernameController.dispose();
    _dobController.dispose();
    _adressController.dispose();
    _pincodeController.dispose();
    _emailController.dispose();
    super.dispose();
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


  bool validateFullname() {
    String fullName = _fullnameController.text!.trim(); // Trim to remove leading/trailing spaces
    List<String> nameParts = fullName.split(' ');
    // Check if the full name has exactly two parts (first name and last name)
    if (nameParts.length < 2) {
      return false;
    }

    // Check if both parts have content
    for (String part in nameParts) {
      if (part.isEmpty) {
        return false;
      }
    }

    // Validation passed
    return true;
  }


  _validateFields() {
    String? validateFullName;
    String? validateFatherName;
    String? validateMotherName;
    String? validateDob;
    String? validateMaritalStatus;
    String? validateAddress;
    String? validatePincode;
    String? validatePurposeOfLoan;
    String? validateGender;
    String? validateProfession;
    String? validateEmail;

    setState(() {
      _isLoading=true;
    });
    // Check each field individually
    // if (_fullnameController.text == null || _fullnameController.text!.isEmpty || !validateFullname()) {
    //   validateFullName = "Please enter your full name (e.g., First Last)";
    // }

    if (_fathernameController.text == null || _fathernameController.text!.isEmpty) {
      validateFatherName = "Please enter your father name";
    }

    if (_mothernameController.text == null || _mothernameController.text!.isEmpty) {
      validateMotherName = "Please enter your mother name";
    }
    // if (_emailController.text.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(_emailController.text)) {
    //   validateEmail = "Please enter a valid email";
    // }

    if (_dobController.text == null || _dobController.text!.isEmpty) {
      validateDob = "Please enter your dob";
    }

    if (maritalStatus == null || maritalStatus!.isEmpty) {
      validateMaritalStatus = "Please select marital status";
    }

    if (_adressController.text == null || _adressController.text!.isEmpty) {
      validateAddress = "Please enter your address";
    }

    if (_pincodeController.text == null || _pincodeController.text!.isEmpty || _pincodeController.text.length<6) {
      validatePincode = "Please enter your pincode";
    }

    if (purposeOfLoan == null || purposeOfLoan!.isEmpty) {
      validatePurposeOfLoan = "Please select your purpose of loan";
    }

    if (gender == "") {
      validateGender = "Please select gender";
    }

    if (profession == "") {
      validateProfession = "Please select profession";
    }

    // Check if any validations failed
    if (
    // validateFullName != null ||
        validateFatherName != null ||
        validateMotherName != null ||
        validateDob != null ||
        validateMaritalStatus != null ||
        validateAddress != null ||
        validatePincode != null ||
        validatePurposeOfLoan != null ||
        validateGender != null ||
        // validateEmail != null ||
        validateProfession != null) {
      setState(() {
        // _validateFullName = validateFullName??"";
        _validateFatherName = validateFatherName??"";
        _validateMotherName = validateMotherName??"";
        _validateDob = validateDob??"";
        _validateMaritalstatus = validateMaritalStatus??"";
        _validateAddress = validateAddress??"";
        _validatePincode = validatePincode??"";
        _validatePurposeofloan = validatePurposeOfLoan??"";
        _validateGender = validateGender??"";
        _validateProfession = validateProfession??"";
        // _validateEmail = validateEmail??"";
          _isLoading=false;
      });
    } else {
      String status = isfetched ? "Update" : "Insert";
      SubmittingBasicDetails(status);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        var dob = DateFormat('dd-MM-yyyy').format(picked);
        _dobController.text = dob!;
      });
    }
  }
  String capitalizeFirstLetter(String text) {
    if (text == null || text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  Result? result = Result();
  Future<void> GetBasicDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetBasicDetailsApi(Userid!).then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.settings?.success == 1) {
                  is_loading = false;
                  isbasicCompleted = true;
                  isfetched = true;
                  is_update=true;
                   result = data.data?.result;
                  _fullnameController.text = result?.fullName ?? "";
                  _fathernameController.text = result?.fatherName ?? "";
                  _mothernameController.text = result?.motherName ?? "";
                  _emailController.text = result?.email ?? "";
                  _dobController.text = result?.dob ?? "";
                  String maritalstatus = result?.maritalStatus ?? "";
                  maritalStatus = capitalizeFirstLetter(maritalstatus);
                  _adressController.text = result?.address ?? "";
                  _pincodeController.text = (result?.pincode ?? 0).toString();
                  profession = result?.profession ?? "";
                  gender = result?.gender ?? "";
                  if (gender == "male") {
                    male = true;
                  } else {
                    male = false;
                  }
                  // purposeOfLoan = result?.loanPurpose ?? "";
                  if (profession == "employee") {
                    employee = true;
                  } else if (profession == "student") {
                    student = true;
                  } else {
                    business = true;
                  }
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Basic Details fetched successfully!",
                      style: TextStyle(color: Color(0xff000000)),
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFFCDE2FB),
                  ));
                } else {
                  is_loading = false;
                }
              })
            }
        });
  }

  Future<void> SubmittingBasicDetails(status) async {
    var Userid = await PreferenceService().getString('user_id');
    // int userIdInt = int.parse(Userid!);
    await UserApi.SubmittingBasicDetailsApi(
            _fathernameController.text!,
            _mothernameController.text!,
            _dobController.text!,
            maritalStatus!.toLowerCase(),
            _adressController.text!,
            _pincodeController.text!,
            gender!.toLowerCase(),
            purposeOfLoan!,
            profession!.toLowerCase(),
        Userid!,
            status)
        .then((data) => {
              if (data != null)
                {
                  setState(() async {
                    if (data.success == 1) {
                      _isLoading=false;
                      if (employee == true){
                        var status = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EmploymentDetails(
                                  isBasicCompleted:
                                      true)), // Replace with your next screen
                        );
                        if (status == true) {
                          is_loading = true;
                          GetBasicDetails();
                        }
                      } else if (student == true) {
                        var status = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Studentdetailsscreen(
                                  isBasicCompleted:
                                      true)), // Replace with your next screen
                        );
                        if (status == true) {
                          is_loading = true;
                          GetBasicDetails();
                        }
                      } else {
                        var status = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BusinessDetails1(
                                  isBasicCompleted:
                                      true)), // Replace with your next screen
                        );
                        if (status == true) {
                          is_loading = true;
                          GetBasicDetails();
                        }
                      }
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Basic Details submitted successfully!",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                    }else{
                      _isLoading=false;
                    }
                  })
                }
            });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return
      (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile" )?
      Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        shadowColor: Colors.white,
        title: Row(
          children: [
            Text(
              "Provide A Few Basic Details",
              style: TextStyle(
                color: Colors.black,
                fontFamily: 'Poppins',
                fontSize: 22,
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        leadingWidth: 25,
      ),
      body: (is_loading)
          ? Center(child: CircularProgressIndicator(
        color: Color(0xff2DB3FF),))
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12,right: 12,top:10,bottom: 10),
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
                      SizedBox(width: 10,),
                      Expanded(child: Text(
                        "Basic",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                      Expanded(child: Center(child: Text(
                        "Work",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ))),
                      SizedBox(width: 10,),
                      Expanded(child: Center(child: Text(
                        "KYC",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ))),
                      SizedBox(width: 10,),
                      Expanded(child: Center(child: Text(
                        "Documents",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ))),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // Text(
                  //   "Full Name",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xFF374151),
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  // TextFormField(
                  //   controller: _fullnameController,
                  //   cursorColor: Colors.black,
                  //   focusNode: _fullnameFocus,
                  //   keyboardType: TextInputType.name,
                  //   onTap: (){
                  //     setState(() {
                  //       _validateFullName="";
                  //     });
                  //   },
                  //   onChanged: (v) {
                  //     setState(() {
                  //       _validateFullName="";
                  //     });
                  //   },
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                  //     CapitalizationInputFormatter()
                  //   ],
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     letterSpacing: 0,
                  //     height: 1.2,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  //   decoration: InputDecoration(
                  //     hintText: "Enter your full name",
                  //     hintStyle: TextStyle(
                  //       fontSize: 15,
                  //       letterSpacing: 0,
                  //       height: 1.2,
                  //       color: Color(0xffAFAFAF),
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     filled: true,
                  //     fillColor: Color(0xffffffff),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       borderSide:
                  //           BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       borderSide:
                  //           BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  //     ),
                  //   ),
                  // ),
                  // if (_validateFullName.isNotEmpty) ...[
                  //   Container(
                  //     alignment: Alignment.topLeft,
                  //     margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                  //     width: screenWidth * 0.8,
                  //     child: ShakeWidget(
                  //       key: Key("value"),
                  //       duration: Duration(milliseconds: 700),
                  //       child: Text(
                  //         _validateFullName,
                  //         style: TextStyle(
                  //           fontFamily: "Poppins",
                  //           fontSize: 12,
                  //           color:Colors.red,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ] else ...[
                  //   const SizedBox(
                  //     height: 15,
                  //   ),
                  // ],
                  Text(
                    "Father Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _fathernameController,
                    cursorColor: Colors.black,
                    focusNode:_fathernameFocus,
                    keyboardType: TextInputType.name,
                    onTap: (){
                      setState(() {
                        _validateFatherName="";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateFatherName="";
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z\s]+$')),
                      CapitalizationInputFormatter()
                    ],
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      height: 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your father name",
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
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                  ),
                  if (_validateFatherName.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateFatherName,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Mother Name",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _mothernameController,
                    cursorColor: Colors.black,
                    focusNode:_mothernameFocus,
                    keyboardType: TextInputType.name,
                    onTap: (){
                      setState(() {
                        _validateMotherName="";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validateMotherName="";
                      });
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z\s]+$')),
                      CapitalizationInputFormatter()
                    ],
                    style: TextStyle(
                      fontSize: 16,
                      letterSpacing: 0,
                      height: 1.2,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    decoration: InputDecoration(
                      hintText: "Enter your mother name",
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
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                  ),
                  if (_validateMotherName.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateMotherName,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  // Text(
                  //   "Email",
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     fontFamily: 'Poppins',
                  //     fontWeight: FontWeight.w500,
                  //     color: Color(0xFF374151),
                  //   ),
                  // ),
                  // const SizedBox(height: 4),
                  // TextFormField(
                  //   controller: _emailController,
                  //   cursorColor: Colors.black,
                  //   focusNode:_emailFocus,
                  //   keyboardType: TextInputType.emailAddress,
                  //   onTap: (){
                  //     setState(() {
                  //       _validateEmail="";
                  //     });
                  //   },
                  //   onChanged: (v) {
                  //     setState(() {
                  //       _validateEmail="";
                  //     });
                  //   },
                  //   inputFormatters: [
                  //     FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                  //   ],
                  //   style: TextStyle(
                  //     fontSize: 16,
                  //     letterSpacing: 0,
                  //     height: 1.2,
                  //     color: Colors.black,
                  //     fontWeight: FontWeight.w400,
                  //   ),
                  //   decoration: InputDecoration(
                  //     hintText: "Enter your email.",
                  //     hintStyle: TextStyle(
                  //       fontSize: 15,
                  //       letterSpacing: 0,
                  //       height: 1.2,
                  //       color: Color(0xffAFAFAF),
                  //       fontFamily: 'Poppins',
                  //       fontWeight: FontWeight.w400,
                  //     ),
                  //     filled: true,
                  //     fillColor: Color(0xffffffff),
                  //     enabledBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       borderSide:
                  //       BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  //     ),
                  //     focusedBorder: OutlineInputBorder(
                  //       borderRadius: BorderRadius.circular(15.0),
                  //       borderSide:
                  //       BorderSide(width: 1, color: Color(0xffCDE2FB)),
                  //     ),
                  //   ),
                  // ),
                  // if (_validateEmail.isNotEmpty) ...[
                  //   Container(
                  //     alignment: Alignment.topLeft,
                  //     margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                  //     width: screenWidth * 0.6,
                  //     child: ShakeWidget(
                  //       key: Key("value"),
                  //       duration: Duration(milliseconds: 700),
                  //       child: Text(
                  //         _validateEmail,
                  //         style: TextStyle(
                  //           fontFamily: "Poppins",
                  //           fontSize: 12,
                  //           color:Colors.red,
                  //           fontWeight: FontWeight.w500,
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                  // ] else ...[
                  //   const SizedBox(
                  //     height: 15,
                  //   ),
                  // ],
                  _buildDateField("Date Of Birth (as per PAN)", _dobController),
                  if (_validateDob.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateDob,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Marital Status",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: maritalStatus,
                    onChanged: (value) {
                      setState(() {
                        maritalStatus = value;
                        _validateMaritalstatus="";
                      });
                    },
                    items: ['Single', 'Married', 'Divorced'].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(status,
                          style: TextStyle(
                            fontSize: 16,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Color(0xffffffff),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                          BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide:
                          BorderSide(width: 1, color: Color(0xffCDE2FB)),
                        ),
                      ),
                    hint: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Select marital status",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  if (_validateMaritalstatus.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateMaritalstatus,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Address",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),

                  Container(
                    height: screenHeight * 0.1,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Color(0xffCDE2FB))),
                    child: TextFormField(
                      controller: _adressController,
                      cursorColor: Colors.black,
                      focusNode:_addressFocus,
                      keyboardType: TextInputType.text,
                      maxLines: 100,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\- ,]')),
                        CapitalizationInputFormatter()
                      ],
                      onTap: (){
                        setState(() {
                          _validateAddress="";
                        });
                      },
                      onChanged: (v) {
                        setState(() {
                          _validateAddress="";
                        });
                      },
                      style: TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                        height: 1.2,
                        fontFamily: "Inter",
                        color: Colors.black,
                        fontWeight: FontWeight.w400,
                      ),
                      decoration: InputDecoration(
                        contentPadding:
                        const EdgeInsets.only(left: 10, top: 10),
                        hintText: "Enter your address",
                        hintStyle: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                      ),
                    ),
                  ),
                  if (_validateAddress.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateAddress,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Pincode",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  TextFormField(
                    controller: _pincodeController,
                    cursorColor: Colors.black,
                    focusNode:_pincodeFocus,
                    keyboardType: TextInputType.phone,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(6)// Allows only digits
                    ],
                    onTap: () {
                      setState(() {
                        _validatePincode="";
                      });
                    },
                    onChanged: (v) {
                      setState(() {
                        _validatePincode="";
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
                      hintText: "Enter your pincode",
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
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide:
                        BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                  ),
                  if (_validatePincode.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validatePincode,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Gender",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Checkbox(
                          value: male,
                          activeColor:Color(0xff24B0FF),
                          onChanged: (value) {
                            setState(() {
                              male = value!;
                              _validateGender="";
                              if (male) {
                                gender = "Male";
                                female = false;
                                others = false;
                              }else{
                                gender = "";
                              }
                            });
                          },
                        ),
                        Text(
                          "Male",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        SizedBox(width: 30,),
                        Checkbox(
                          value: female,
                          activeColor:Color(0xff24B0FF) ,
                          onChanged: (value) {
                            setState(() {
                              female = value!;
                              _validateGender="";
                              if (female) {
                                gender = "Female";
                                male = false;
                                others = false;
                              }else{
                                gender = "";
                              }
                            });
                          },
                        ),
                        Text(
                          "Female",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        // Checkbox(
                        //   value: others,
                        //   activeColor:Color(0xff24B0FF) ,
                        //   onChanged: (value) {
                        //     setState(() {
                        //       others = value!;
                        //       _validateGender="";
                        //       if (others) {
                        //         gender = "Others";
                        //         male = false;
                        //         female = false;
                        //       }else{
                        //         gender = "";
                        //       }
                        //     });
                        //   },
                        // ),
                        // Text(
                        //   "Others",
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontFamily: 'Poppins',
                        //     fontWeight: FontWeight.w500,
                        //     color: Color(0xFF374151),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                  if (_validateGender.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateGender,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Purpose Of Loan",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    value: purposeOfLoan,
                    onChanged: (value) {
                      setState(() {
                        purposeOfLoan = value;
                        _validatePurposeofloan="";
                      });
                    },
                    items: [
                      'Home Loan',
                      'Business Loan',
                      'Car Loan',
                      'Education Loan',
                      'Personal Loan',
                    ].map((status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: "Poppins",
                            letterSpacing: 0,
                            height: 1.2,
                            color: Colors.black,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Color(0xffffffff),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                      ),
                    ),
                    hint: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Select purpose of loan",
                        style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          color: Color(0xffAFAFAF),
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  if (_validatePurposeofloan.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validatePurposeofloan,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  Text(
                    "Profession",
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                      color: Color(0xFF374151),
                    ),
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        Checkbox(
                          value: employee,
                          activeColor:Color(0xff24B0FF) ,
                          onChanged: (value) {
                            setState(() {
                              employee = value!;
                              _validateProfession="";
                              if (employee) {
                                profession = "Employee";
                                student = false;
                                business = false;
                              }else{
                                profession = "";
                              }
                            });
                          },
                        ),
                        Text(
                          "Employee",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        Checkbox(
                          value: student,
                          activeColor:Color(0xff24B0FF) ,
                          onChanged: (value) {
                            setState(() {
                              student = value!;
                              _validateProfession="";
                              if (student) {
                                profession = "Student";
                                employee = false;
                                business = false;
                              }else{
                                profession = "";
                              }
                            });
                          },
                        ),
                        Text(
                          "Student",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        Checkbox(
                          value: business,
                          activeColor:Color(0xff24B0FF) ,
                          onChanged: (value) {
                            setState(() {
                              business = value!;
                              _validateProfession="";
                              if (business) {
                                profession = "Business";
                                student = false;
                                employee = false;
                              }else{
                                profession = "";
                              }
                            });
                          },
                        ),
                        Text(
                          "Business",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_validateProfession.isNotEmpty) ...[
                    Container(
                      alignment: Alignment.topLeft,
                      margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                      width: screenWidth * 0.6,
                      child: ShakeWidget(
                        key: Key("value"),
                        duration: Duration(milliseconds: 700),
                        child: Text(
                          _validateProfession,
                          style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 12,
                            color:Colors.red,
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
                  const SizedBox(height: 20),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                       if(_isLoading){

                       }else{
                         _validateFields();
                       }
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Color(0xFF2DB3FF),
                        ),
                        margin: EdgeInsets.only(bottom: 30),
                        child:Center(
                          child: _isLoading
                              ? CircularProgressIndicator(
                            strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                              : Text(
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
    ):
      NoInternetWidget();
  }

  Widget _buildDateField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: () {
            _selectDate(context);
            setState(() {
              _validateDob="";
            });
          },
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Select dob from date picker",
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
                  borderSide:
                  BorderSide(width: 1, color: Color(0xffCDE2FB)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15.0),
                  borderSide:
                  BorderSide(width: 1, color: Color(0xffCDE2FB)),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStep(int stepIndex) {
    bool isCompleted = isbasicCompleted && stepIndex < 1;
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
            ? Icon(
                Icons.check,
                color: Colors.white,
                size: 10,
              )
            : Text(
                (stepIndex + 1).toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Widget _buildSeparator(int separatorIndex) {
    bool isCompleted = isbasicCompleted && separatorIndex < 1;
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
}
