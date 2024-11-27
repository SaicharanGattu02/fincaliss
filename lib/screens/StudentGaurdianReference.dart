import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:fincalis/utils/ShakeWidget.dart';
import 'package:fincalis/screens/StudentFriendReference.dart';
import 'dart:developer' as developer;

import '../Services/other_services.dart';
import '../classes/FirstLetterCaps.dart';

class GuardianReferenceScreen extends StatefulWidget {
  const GuardianReferenceScreen({super.key});

  @override
  State<GuardianReferenceScreen> createState() => _MyReferenceOneState();
}

class _MyReferenceOneState extends State<GuardianReferenceScreen> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodeMobileNumber = FocusNode();

  bool _isContinueClicked = false;
  String? _selectedRelation;
  String _validateFullName = "";
  String _validateNumber = "";
  String _validateRelation = "";
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
  Future<void> _submitUserReference() async {
    var userId = await PreferenceService().getString('user_id');
    await UserApi.SubmitReferenceapi(
      userId!,
      nameController.text,
      _selectedRelation!,
      mobileNumberController.text,
    ).then((data) {
      if (data != null) {
        setState(() {
          if (data.success == 1) {
            _isLoading = false;
            Navigator.pop(context,"Reference1 Added");
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Reference1 added successfully!",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
          } else {
            _isLoading = false;
          }
        });
      }
    });
  }

  bool _validateFullNameInput() {
    String fullName = nameController.text.trim();
    List<String> nameParts = fullName.split(' ');

    return nameParts.length >= 2 && nameParts.every((part) => part.isNotEmpty);
  }


  void _validateFields() {
    setState(() {
      _isLoading = true;
      _validateFullName = nameController.text.isEmpty || !_validateFullNameInput()
          ? "Please enter your full name (e.g., First Last)"
          : "";
      _validateNumber = mobileNumberController.text.isEmpty || mobileNumberController.text.length != 10
          ? "Please enter a valid mobile number"
          : "";
      _validateRelation = _selectedRelation == null ? "Please select a relation" : "";
    });

    if (_validateFullName.isEmpty &&
        _validateNumber.isEmpty &&
        _validateRelation.isEmpty) {
      _submitUserReference();
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please fill all required fields",
          style: TextStyle(color: Color(0xff000000)),
        ),
        duration: Duration(seconds: 1),
        backgroundColor: Color(0xFFCDE2FB),
      ));
    }
  }

  @override
  void dispose() {
    _focusNodeFullName.dispose();
    _focusNodeMobileNumber.dispose();
    nameController.dispose();
    mobileNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile" )?
       Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: 
      SingleChildScrollView(
        child:
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            height: screenHeight*0.88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Reference 1",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  _buildDropdownField(),
                  const SizedBox(height: 20),
                  _buildTextField("Full Name", nameController, TextInputType.name, _validateFullName, _focusNodeFullName, r'^[a-zA-Z\s]+$', 0),
                  const SizedBox(height: 20),
                  _buildTextField("Mobile Number", mobileNumberController, TextInputType.phone, _validateNumber, _focusNodeMobileNumber, r'^[0-9]+$', 10),
                  const Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 50),
                    child: GestureDetector(
                      onTap: () {
                        if(_isLoading){

                        }else{
                          _validateFields();
                        }
                      },
                      child: Center(
                        child: Container(
                          width: 240,
                          height: 56,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: const Color(0xFF2DB3FF),
                          ),
                          child: Center(
                            child:
                            _isLoading
                                ? CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            )
                                :
                            Text(
                              "Confirm",
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
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    )
        : NoInternetWidget();
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      String validationMessage,
      FocusNode focus,
      String pattern,
      int length,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          cursorColor: Colors.black,
          focusNode: focus,
          keyboardType: keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(pattern)),
            if (length > 0) LengthLimitingTextInputFormatter(length),
            CapitalizationInputFormatter()
          ],
          onTap: () {
            setState(() {
              if (label == "Full Name") _validateFullName = "";
              if (label == "Mobile Number") _validateNumber = "";
            });
          },
          style: const TextStyle(
            fontSize: 16,
            letterSpacing: 0,
            height: 1.2,
            color: Colors.black,
            fontWeight: FontWeight.w400,
          ),
          decoration: InputDecoration(
            hintText: "Enter your $label",
            hintStyle: const TextStyle(
              fontSize: 15,
              letterSpacing: 0,
              height: 1.2,
              color: Color(0xffAFAFAF),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
        ),
        if (validationMessage.isNotEmpty)
          ShakeWidget(
            key: Key(label),
            duration: const Duration(milliseconds: 700),
            child: Text(
              validationMessage,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildDropdownField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Parents/sister/Brother/Guardian",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedRelation,
          onChanged: (value) {
            setState(() {
              _selectedRelation = value;
              _validateRelation = "";
            });
          },
          items: [
            'Parent', 'Sister', 'Brother', 'Guardian'
          ].map((status) {
            return DropdownMenuItem<String>(
              value: status,
              child: Text(
                status,
                style: const TextStyle(
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
            fillColor: Colors.white,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
          hint: Align(
            alignment: Alignment.center,
            child: Text(
              "Select relation",
              style: const TextStyle(
                fontSize: 15,
                letterSpacing: 0,
                color: Color(0xffAFAFAF),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        if (_validateRelation.isNotEmpty)
          ShakeWidget(
            key: const Key("Relation"),
            duration: const Duration(milliseconds: 700),
            child: Text(
              _validateRelation,
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}