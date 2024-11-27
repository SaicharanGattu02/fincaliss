import 'package:android_sms_retriever/android_sms_retriever.dart';
import 'package:fincalis/screens/ConsentScreen.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:fincalis/utils/ShakeWidget.dart';
import 'package:flutter/material.dart';
import 'package:fincalis/screens/otp.dart';
import 'package:flutter/services.dart';
import '../Services/user_api.dart';
import '../classes/FirstLetterCaps.dart';
import '../utils/Preferances.dart';


class Registration extends StatefulWidget {
  final bool consent_status;
  const Registration({super.key, required this.consent_status});

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emialController = TextEditingController();
  bool _isLoading = false;
  String _validateFullName = "";
  String _validateEmail = "";
  String _requestedPhoneNumber = "";

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNodeFullName.requestFocus();
    });
    _retrievePhoneNumber();
  }


  Future<void> _submitDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.RegistrationApi(_fullNameController.text,_emialController.text,Userid!).then((data) => {
      if (data != null) {
        setState(() {
          if (data.success == 1) {
            _isLoading=false;
            if(widget.consent_status==false){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>Consentscreen(),
                ),
              );
            }else{
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>MyMainHome(),
                ),
              );
            }
          }else{
            _isLoading=false;
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "${data.message}.",
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
  bool validateFullname() {
    String fullName = _fullNameController.text!.trim(); // Trim to remove leading/trailing spaces
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


  @override
  void dispose() {
    _focusNodeFullName.dispose();
    _emialController.dispose();
    _fullNameController.dispose();
    _focusNodeEmail.dispose();
    super.dispose();
  }

  Future<void> _retrievePhoneNumber() async {
    try {
      final value = await AndroidSmsRetriever.requestPhoneNumber();
      setState(() {
        _requestedPhoneNumber = value ?? 'Phone Number Not Found';
        _emialController.text = _removeCountryCode(_requestedPhoneNumber);
      });
    } catch (e) {
      // Handle the error if necessary
      print('Error retrieving phone number: $e');
    }
  }

  String _removeCountryCode(String phoneNumber) {
    // Check if the phone number starts with +91 and remove it
    if (phoneNumber.startsWith('+91')) {
      return phoneNumber.substring(3); // Remove +91
    }
    return phoneNumber;
  }

  void _handleSignup() {
    setState(() {
      _isLoading=true;
      _validateFullName = _fullNameController.text.isEmpty || !validateFullname()
          ? "Please enter your full name (e.g., First Last)"
          : "";
      _validateEmail = _emialController.text.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(_emialController.text)
          ? "Please enter a valid email"
          : "";
    });
    if (_validateFullName.isEmpty && _validateEmail.isEmpty) {
      _submitDetails();
    } else {
      setState(() {
        _isLoading=false;
      });
    }
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      String validationMessage,
      FocusNode focus,
      String pattern,
      int length,
      List<TextInputFormatter> additionalFormatters,
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
            ...additionalFormatters,
          ],
          onTap: () {
            setState(() {
              if (label == "Full Name") _validateFullName = "";
              if (label == "Email") _validateEmail = "";
            });
          },
          onChanged: (v){
            setState(() {
              if (label == "Full Name") _validateFullName = "";
              if (label == "Email") _validateEmail = "";
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
            hintText: "Enter your $label",
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
              borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
        ),
        if (validationMessage.isNotEmpty) ...[
          ShakeWidget(
            key: Key("value"),
            duration: Duration(milliseconds: 700),
            child: Text(
              validationMessage,
              style: TextStyle(
                fontFamily: "Poppins",
                fontSize: 12,
                color: Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: () async {
        // Exit the app
        SystemNavigator.pop();
        // Return false to prevent default back navigation behavior
        return false;
      },
      child:Scaffold(
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 120),
                      child: Image.asset("assets/logo1.png",
                        width: 230,
                        height: 50,),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 78),
                      child: Text(
                        "Registration",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                        "Full Name(as per PAN)",
                        _fullNameController,
                        TextInputType.name,
                        _validateFullName,
                        _focusNodeFullName,
                        r'^[a-zA-Z\s]+$',
                        0,
                        [CapitalizationInputFormatter()]
                    ),
                    const SizedBox(height: 24),
                    _buildTextField(
                        "Email",
                        _emialController,
                        TextInputType.emailAddress,
                        _validateEmail,
                        _focusNodeEmail,
                        r'[a-zA-Z0-9@._-]',
                        0,
                        []
                    ),
                    GestureDetector(
                      onTap:(){
                        if(_isLoading){

                        }else{
                          _handleSignup();
                        }
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(44),
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFF2DB3FF),
                            ),
                            child: Center(
                              child: _isLoading
                                  ? CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              )
                                  :
                              Text(
                                "Submit",
                                style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 24,
                                  fontFamily: 'Poppins',
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
            ],
          ),
        ),
      ),);
  }
}