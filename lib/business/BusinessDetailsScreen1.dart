import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/screens/PanDetailsScreen.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Services/other_services.dart';
import '../classes/FirstLetterCaps.dart';
import '../model/BusinessDetailsModel.dart';
import '../utils/ShakeWidget.dart';
import 'dart:developer' as developer;

class BusinessDetails1 extends StatefulWidget {
  final bool isBasicCompleted;
  const BusinessDetails1({super.key, required this.isBasicCompleted});

  @override
  State<BusinessDetails1> createState() => _BusinessDetails1State();
}

class _BusinessDetails1State extends State<BusinessDetails1> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  final TextEditingController _businessNameController = TextEditingController();
  final TextEditingController _RegisteredaddressController =
      TextEditingController();
  final TextEditingController _OfficialEmailController =
      TextEditingController();
  final TextEditingController _annualIncomeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  final FocusNode _businessNameFocus = FocusNode();
  final FocusNode _RegisteredaddressFocus = FocusNode();
  final FocusNode _pincodeFocus = FocusNode();
  final FocusNode _annualIncomeFocus = FocusNode();
  final FocusNode _officialEmailFocus = FocusNode();

  bool isworkcompleted = false;
  String registration_type="";
  String industry_type="";
  bool isfetched = false;
  var is_loading = true;

  bool _isLoading = false;

  String? selectedKey;  // Key to be sent to the server
  String? selectedValue; // Value to be displayed in the dropdown
  Map<String, String> optionsMap = {};

  String? selectedKey1;  // Key to be sent to the server
  String? selectedValue1; // Value to be displayed in the dropdown
  Map<String, String> optionsMap1 = {};


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    GetBusinessDetails();
    GetRegistrationDetials();
    GetNatueOfBusinessDetails();
    _businessNameController.addListener(() {
      setState(() {
        _validateCompanyName = "";
      });
    });
    _RegisteredaddressController.addListener(() {
      setState(() {
        _validateRegisteredAddress = "";
      });
    });
    _OfficialEmailController.addListener(() {
      setState(() {
        _validateOfficialEmail = "";
      });
    });
    _annualIncomeController.addListener(() {
      setState(() {
        _validateAnnualIncome = "";
      });
    });
    _pincodeController.addListener(() {
      setState(() {
        _validatePincode = "";
      });
    });
    _businessNameController.addListener(() {
      setState(() {
        _validateCompanyName = "";
      });
    });

  }

  @override
  void dispose() {
    _businessNameController.dispose();
    _RegisteredaddressController.dispose();
    _OfficialEmailController.dispose();
    _annualIncomeController.dispose();
    _pincodeController.dispose();
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

  String _validateCompanyName = "";
  String _validateRegistarationType = "";
  String _validateIndustryType = "";
  String _validateRegisteredAddress = "";
  String _validateOfficialEmail = "";
  String _validateAnnualIncome = "";
  String _validatePincode = "";

  _validateFields() {
    // Initialize variables to accumulate validation messages
    String? validateCompanyName;
    String? validateRegistrationType;
    String? validateRegisteredAddress;
    String? validateOfficialEmail;
    String? validateAnnualIncome;
    String? validatePincode;
    String? validateIndustryType;
    setState(() {
      _isLoading=true;
    });

    // Check each field individually
    if (_businessNameController.text.isEmpty) {
      validateCompanyName = "Please enter your company name";
    }

    if (registration_type=="") {
      validateRegistrationType = "Please enter your registration type";
    }

    if (industry_type=="") {
      validateIndustryType = "Please enter your industry type";
    }

    if (_RegisteredaddressController.text.isEmpty) {
      validateRegisteredAddress = "Please enter your registered address";
    }

    if (_OfficialEmailController.text.isEmpty  || !RegExp(r'\S+@\S+\.\S+').hasMatch(_OfficialEmailController.text)) {
      validateOfficialEmail = "Please enter a valid official email";
    }

    if (_annualIncomeController.text.isEmpty) {
      validateAnnualIncome = "Please enter your annual income";
    }

    if (_pincodeController.text.isEmpty || _pincodeController.text.length<6) {
      validatePincode = "Please enter your pincode";
    }

    // Check if any validations failed
    if (validateCompanyName != null ||
        validateIndustryType != null ||
        validateRegistrationType != null ||
        validateRegisteredAddress != null ||
        validateOfficialEmail != null ||
        validateAnnualIncome != null ||
        validatePincode != null) {
      // Update state with all validation messages
      setState(() {
        _validateCompanyName = validateCompanyName ?? '';
        _validateIndustryType = validateIndustryType ?? '';
        _validateRegistarationType = validateRegistrationType ?? '';
        _validateRegisteredAddress = validateRegisteredAddress ?? '';
        _validateOfficialEmail = validateOfficialEmail ?? '';
        _validateAnnualIncome = validateAnnualIncome ?? '';
        _validatePincode = validatePincode ?? '';
        _isLoading=false;
      });
    } else {
      // All fields are valid, proceed with submitting data
      String status = isfetched ? "Update" : "Insert";
      SubmittBusinessDetails(status);
    }
  }

  Result? result;
  Future<void> GetBusinessDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetBusinessDetailsApi(Userid!).then((data) => {
          if (data != null)
            {
              setState(() {
                if (data.settings?.success == 1) {
                  isworkcompleted = true;
                  isfetched = true;
                  is_loading = false;
                  result = data.data?.result;
                  _businessNameController.text = result?.businessName ?? "";
                  int? registrationtype = result?.registrationTypeId;
                  selectedValue=registrationtype.toString();
                  registration_type = selectedValue??"";
                  int? industrytype = result?.natureOfBusinessId;
                  selectedValue1=industrytype.toString();
                  industry_type=selectedValue1??"";
                  _RegisteredaddressController.text =result?.registeredAddress??"";
                  _OfficialEmailController.text = result?.officialEmail ?? "";
                  double? annual_income = result?.annualIncome;
                  _annualIncomeController.text = annual_income.toString();
                  int pincode=result?.pincode ??0;
                  _pincodeController.text =pincode.toString();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                      "Business Details fetched successfully!",
                      style: TextStyle(color: Color(0xff000000)),
                    ),
                    duration: Duration(seconds: 1),
                    backgroundColor: Color(0xFFCDE2FB),
                  ));
                }else{
                  is_loading = false;
                }
              })
            }
        });
  }

  Future<void> GetRegistrationDetials() async {
      try {
        final data = await UserApi.GetRegistrationDetialsApi();
        if (data != null && data.settings?.success == 1) {
          final result = data.data?.result?.values;
          if (result != null) {
            setState(() {
              optionsMap = result;
              if (optionsMap.isNotEmpty) {
                selectedValue = optionsMap.keys.first; // Set the initial value to the first key
                selectedKey = optionsMap[selectedValue!]; // Set the initial key based on the first value
              }
            });
          } else {
            resetOptions();
          }
        } else {
          resetOptions();
        }
      } catch (e) {
        print('Error fetching registration details: $e');
        resetOptions();
      }
    }

    void resetOptions() {
      setState(() {
        optionsMap = {};
        selectedValue = null;
        selectedKey = null;
      });
    }

  Future<void> GetNatueOfBusinessDetails() async {
    await UserApi.GetNatueOfBusinessDetailsApi().then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              final result = data.data?.result;
              if (result != null) {
                final map = Map<String, String>.from(result.values);
                setState(() {
                  optionsMap1 = map;
                  if (map.isNotEmpty) {
                    selectedValue1 = map.keys.first;  // Set the initial value to the first key
                    selectedKey1 = map.values.first;  // Set the initial key to the first value
                  }
                });
              } else {
                // Handle the case where the result is null (e.g., show an error message or default value)
                setState(() {
                  optionsMap1 = {};
                  selectedValue1 = null;
                  selectedKey1 = null;
                });
              }
            }else{

            }
          })
        }
    });
  }

  Future<void> SubmittBusinessDetails(status) async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.SubmittBusineesDetailsApi(
            _businessNameController.text,
            _RegisteredaddressController.text,
            _OfficialEmailController.text,
            _annualIncomeController.text,
            _pincodeController.text,
            int.parse(registration_type),
            Userid!,
            status,
      industry_type
    )
        .then((data) => {
              if (data != null)
                {
                  setState(() async {
                    if (data.success == 1) {
                      _isLoading=false;
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Business Details submitted successfully!",
                          style: TextStyle(color: Color(0xff000000)),
                        ),
                        duration: Duration(seconds: 1),
                        backgroundColor: Color(0xFFCDE2FB),
                      ));
                      var res= await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PanDetails(
                                  isworkdetailsCompleted: true,from: "Business",
                                )),
                      );
                      if(res==true){
                        is_loading = true;
                        GetNatueOfBusinessDetails();
                        GetRegistrationDetials();
                        GetBusinessDetails();
                      }
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
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile" )?
    WillPopScope(
        onWillPop: () async{
          Navigator.pop(context,true);
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context,true);
                  },
                ),
              ],
            ),
          ),
        body:(is_loading)
            ? Center(child: CircularProgressIndicator(color: Color(0xff2DB3FF),))
        :SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
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
              Padding(
                padding: const EdgeInsets.only(bottom: 65, top: 40),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xFFCDE2FB).withOpacity(0.25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        const Text(
                          "Add Business Details",
                          style: TextStyle(
                            color: Color(0xFF000000),
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Text(
                          "Enter details about your current working office",
                          style: TextStyle(
                            fontSize: 13,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 30),
                        _buildTextField(
                            "Company Name",
                            _businessNameController,
                            TextInputType.name,
                            _businessNameFocus,
                            r'^[a-zA-Z\s]+$',
                            "Enter your comapany name",
                            _validateCompanyName,
                          0,
                          [CapitalizationInputFormatter()],
                        ),
                        Text(
                          "Registration Type",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: selectedValue,
                          onChanged: (value) {
                            setState(() {
                              selectedValue = value;
                              selectedKey = optionsMap[value!]; // Update selectedKey based on selectedValue
                              registration_type = selectedValue!;
                              _validateRegistarationType = "";
                            });
                            // You can now use selectedKey to send to the server
                            print('Selected key to send to server: $selectedValue');
                          },
                          items: optionsMap.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key, // The key is used as the value
                              child: Text(
                                entry.value, // The value is displayed as text
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
                              "Select registration type",
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
                        if (_validateRegistarationType.isNotEmpty) ...[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                            width: screenWidth * 0.6,
                            child: ShakeWidget(
                              key: Key("value"),
                              duration: Duration(milliseconds: 700),
                              child: Text(
                                _validateRegistarationType,
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
                          "Industry Type",
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        const SizedBox(height: 4),
                        DropdownButtonFormField<String>(
                          value: selectedValue1,
                          onChanged: (value) {
                            setState(() {
                              selectedValue1 = value;
                              selectedKey1 = optionsMap1[value!]; // Update selectedKey based on selectedValue
                              industry_type = selectedValue1!;
                              _validateIndustryType = "";
                            });
                            // You can now use selectedKey to send to the server
                            print('Selected key to send to server: $selectedValue1');
                          },
                          items: optionsMap1.entries.map((entry) {
                            return DropdownMenuItem<String>(
                              value: entry.key, // The key is used as the value
                              child: Text(
                                entry.value, // The value is displayed as text
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
                              "Select registration type",
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
                        if (_validateIndustryType.isNotEmpty) ...[
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                            width: screenWidth * 0.6,
                            child: ShakeWidget(
                              key: Key("value"),
                              duration: Duration(milliseconds: 700),
                              child: Text(
                                _validateIndustryType,
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
                        _buildTextField(
                            "Registered Address",
                            _RegisteredaddressController,
                            TextInputType.text,
                            _RegisteredaddressFocus,
                            r'[a-zA-Z0-9\s,.-]',
                            "Enter your registered address",
                            _validateRegisteredAddress,
                          0,
                          [CapitalizationInputFormatter()],
                        ),
                        _buildTextField(
                            "Official Email",
                            _OfficialEmailController,
                            TextInputType.emailAddress,
                            _officialEmailFocus,
                            r'[a-zA-Z0-9@._-]',
                            "Enter your officil email",
                            _validateOfficialEmail,
                          0,
                          [],
                        ),
                        _buildTextField(
                            "Annual Income",
                            _annualIncomeController,
                            TextInputType.number,
                            _annualIncomeFocus,
                            r'[a-zA-Z0-9\s,.-]',
                            "Enter your annual income",
                            _validateAnnualIncome,
                             0,
                          [CapitalizationInputFormatter()]
                        ),
                        _buildTextField(
                            "Pincode",
                            _pincodeController,
                            TextInputType.number,
                            _pincodeFocus,
                            r'[0-9\s]',
                            "Enter your pincode",
                            _validatePincode,
                            6,
                            [CapitalizationInputFormatter()]
                        ),
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
                              width: 342,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: const Color(0xFF2DB3FF),
                              ),
                              child: Center(
                                child: (_isLoading)
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
                ),
              ),
            ],
          ),
        ),
            ),
      ):
      NoInternetWidget();
  }

  Widget _buildTextField(
    String labelText,
    TextEditingController controller,
    TextInputType keyboardType,
    FocusNode focusNode,
    String validationPattern,
    String hinttext,
      String validateMessage,
      int length,
      List<TextInputFormatter> additionalFormatters,
  ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          labelText,
          style:TextStyle(
            fontSize: 16,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 5),
        TextFormField(
          focusNode: focusNode,
          controller: controller,
          cursorColor: Colors.black,
          keyboardType: keyboardType,
          onTap: (){
            setState(() {
              validateMessage="";
            });
          },
          decoration: InputDecoration(
            hintText: hinttext,
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
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(validationPattern)),
            if (length > 0) LengthLimitingTextInputFormatter(length),
            ...additionalFormatters,
          ],
        ),
        if (validateMessage.isNotEmpty) ...[
          Container(
            alignment: Alignment.topLeft,
            margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
            width: screenWidth * 0.8,
            child: ShakeWidget(
              key: Key("value"),
              duration: Duration(milliseconds: 700),
              child: Text(
                validateMessage,
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
      ],
    );
  }

  Widget _buildStep(int stepIndex) {
    bool isCompleted = (isworkcompleted) && stepIndex < 2 ||  (widget.isBasicCompleted) && stepIndex < 1 ;
    Color stepColor = isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
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
    bool isCompleted = (isworkcompleted) && separatorIndex < 2 ||  (widget.isBasicCompleted) && separatorIndex < 1 ;
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
