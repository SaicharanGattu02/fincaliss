import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/PanDetailsScreen.dart';
import 'package:fincalis/student/selfie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../Services/other_services.dart';
import '../Services/user_api.dart';
import '../classes/FirstLetterCaps.dart';
import '../model/GetEmployeeDetailsModel.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';
import 'dart:developer' as developer;

class EmploymentDetails extends StatefulWidget {
  final bool isBasicCompleted;
  const EmploymentDetails({super.key, required this.isBasicCompleted});
  @override
  State<EmploymentDetails> createState() => _EmploymentDetailsState();
}

class _EmploymentDetailsState extends State<EmploymentDetails> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isLoading = false;
  bool declare = false;
  String industry_type="";
  bool isworkcompleted = false;
  bool isfetched = false;
  var is_loading=true;
  var status="";

  String? selectedKey1;  // Key to be sent to the server
  String? selectedValue1; // Value to be displayed in the dropdown
  Map<String, String> optionsMap1 = {};

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _designationController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _workExperienceController = TextEditingController();
  final TextEditingController _officialEmailController = TextEditingController();
  final TextEditingController _companyAddressController = TextEditingController();
  final TextEditingController _pinCodeController = TextEditingController();
  final TextEditingController _mobilenumberController = TextEditingController();

  final FocusNode _companyNameFocus = FocusNode();
  final FocusNode _mobilenumberFocus = FocusNode();
  final FocusNode _designationFocus = FocusNode();
  final FocusNode _salaryFocus = FocusNode();
  final FocusNode _workExperienceFocus = FocusNode();
  final FocusNode _officialEmailFocus = FocusNode();
  final FocusNode _companyAddressFocus = FocusNode();
  final FocusNode _pinCodeFocus = FocusNode();


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    GetEmployeeDetails();
    GetNatueOfBusinessDetails();
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _designationController.dispose();
    _salaryController.dispose();
    _workExperienceController.dispose();
    _officialEmailController.dispose();
    _companyAddressController.dispose();
    _pinCodeController.dispose();
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

  String _validateCompanyName = '';
  String _validateMobilenumber = '';
  String _validateDesignation = '';
  String _validateIndustryType = '';
  String _validateSalary = '';
  String _validateWorkExperience = '';
  String _validateOfficialEmail = '';
  String _validateCompanyAddress = '';
  String _validatePinCode = '';
  String _validateDeclaration = '';

  void _validateFields() {
    setState(() {
      _isLoading=true;
    });
    // Initialize variables to accumulate validation messages
    String validateCompanyName = '';
    String validateDesignation = '';
    String validateIndustryType = '';
    String validateSalary = '';
    String validateWorkExperience = '';
    String validateOfficialEmail = '';
    String validateCompanyAddress = '';
    String validatePinCode = '';
    String validateDeclaration = '';
    String validateMobilenumber = '';

    // Validate each field
    if (_companyNameController.text.isEmpty) {
      validateCompanyName = "Please enter your company name";
    }

    if (_designationController.text.isEmpty) {
      validateDesignation = "Please enter your designation";
    }

    if (industry_type=="") {
      validateIndustryType = "Please select industry type";
    }

    if (_salaryController.text.isEmpty) {
      validateSalary = "Please enter your salary";
    }

    if (_workExperienceController.text.isEmpty) {
      validateWorkExperience = "Please enter your work experience";
    }

    if (_officialEmailController.text.isEmpty || !RegExp(r'\S+@\S+\.\S+').hasMatch(_officialEmailController.text)) {
      validateOfficialEmail = "Please enter a valid official email";
    }

    if (_companyAddressController.text.isEmpty) {
      validateCompanyAddress = "Please enter your company address";
    }

    if (_pinCodeController.text.isEmpty || _pinCodeController.text.length<6) {
      validatePinCode = "Please enter your pin code";
    }

    if(_mobilenumberController.text.isEmpty || _mobilenumberController.text.length<10){
      validateMobilenumber="Please enter a valid mobile number";
    }

    // Check declaration checkbox
    if (!declare) {
      validateDeclaration = "Please check the box to confirm that you have agreed to the declaration.";
    }

    // Update state with validation messages
    setState(() {
      _validateCompanyName = validateCompanyName;
      _validateDesignation = validateDesignation;
      _validateIndustryType = validateIndustryType;
      _validateSalary = validateSalary;
      _validateWorkExperience = validateWorkExperience;
      _validateOfficialEmail = validateOfficialEmail;
      _validateCompanyAddress = validateCompanyAddress;
      _validatePinCode = validatePinCode;
      _validateDeclaration = validateDeclaration;
      _validateMobilenumber = validateMobilenumber;
    });

    // Check if all validations passed
    if (validateCompanyName.isEmpty &&
        validateDesignation.isEmpty &&
        validateIndustryType.isEmpty &&
        validateSalary.isEmpty &&
        validateWorkExperience.isEmpty &&
        validateOfficialEmail.isEmpty &&
        validateCompanyAddress.isEmpty &&
        validatePinCode.isEmpty &&
        validateMobilenumber.isEmpty &&
        declare) {
      // All fields are valid, proceed with submitting data
      String status = isfetched ? "Update" : "Insert";
      SubmittingEmployeeDetails(status);
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }


  Result? result=Result();
  Future<void> GetEmployeeDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetEmployeeDetailsApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if(data.settings?.success==1){
              isworkcompleted=true;
              isfetched=true;
              is_loading=false;
              result=data.data?.result;
              _companyNameController.text=result?.companyName??"";
              _designationController.text=result?.designation??"";
              _mobilenumberController.text=result?.mobile??"";
               double workExperience = result?.workExp?? 0.0;
              _workExperienceController.text = workExperience.toString();
              _officialEmailController.text=result?.officeEmail??"";
              _companyAddressController.text=result?.companyAddress??"";
               int pincode = result?.pincode?? 0;
              _pinCodeController.text= pincode.toString()??"";
              double salary = result?.salary?? 0.0;
              _salaryController.text=salary.toString();
              int industrytype=result?.industry_type_id?? 0;
              selectedValue1 = industrytype.toString()??"";
              industry_type = selectedValue1!;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Employee Details fetched successfully!",
                  style: TextStyle(
                      color: Color(0xff000000)
                  ),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }else{
              is_loading=false;
            }
          })
        }
    });
  }

  Future<void> SubmittingEmployeeDetails(status) async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.SubmittingEmployeeDetailsApi(_companyNameController.text,_designationController.text, _officialEmailController.text,
        _workExperienceController.text, _companyAddressController.text,_pinCodeController.text,Userid!,_salaryController.text,int.parse(industry_type),status,_mobilenumberController.text).then((data) => {
      if (data != null)
        {
          setState(() async {
            if (data.success == 1) {
              _isLoading=false;
              var res= await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) =>PanDetails(isworkdetailsCompleted: true,from: "Employee",)), // Replace with your next screen
              );
              if(res==true){
                is_loading=true;
                GetEmployeeDetails();
              }
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Employee Details submitted successfully!",
                  style: TextStyle(
                      color: Color(0xff000000)
                  ),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }else{
              _isLoading=false;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(data.message ??"",
                  style: TextStyle(
                    color: Color(0xff000000)
                  ),
                ),
                duration: Duration(seconds: 2),
                backgroundColor: Color(0xFFCDE2FB),
              ));
            }
          })
        }
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
                 child: Text(
                  "Employment Details",
                  style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Poppins',
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        body: (is_loading)
            ? Center(child: CircularProgressIndicator(color: Color(0xff2DB3FF),))
            :
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
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
                const Text(
                  "Company Name",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _companyNameController,
                  cursorColor: Colors.black,
                  focusNode:_companyNameFocus,
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                    CapitalizationInputFormatter()
                  ],
                  onTap: (){
                    setState(() {
                      _validateCompanyName="";
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
                    hintText: "Enter your company name",
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
                if (_validateCompanyName.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateCompanyName,
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
                const Text(
                  "Company Mobile Number",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _mobilenumberController,
                  cursorColor: Colors.black,
                  focusNode:_mobilenumberFocus,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[0-9]+$')),
                    LengthLimitingTextInputFormatter(10)
                  ],
                  onTap: (){
                    setState(() {
                      _validateMobilenumber="";
                    });
                  },
                  onChanged: (v){
                    setState(() {
                      _validateMobilenumber="";
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
                    hintText: "Enter your company mobile number.",
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
                if (_validateMobilenumber.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateMobilenumber,
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
                const Text(
                  "Designation",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _designationController,
                  cursorColor: Colors.black,
                  focusNode:_designationFocus,
                  keyboardType: TextInputType.name,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]+$')),
                    CapitalizationInputFormatter()
                  ],
                  onTap: (){
                    setState(() {
                      _validateDesignation="";
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
                    hintText: "Enter your designation",
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
                if (_validateDesignation.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateDesignation,
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
                      "Select industry type",
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
                const Text(
                  "Salary (per annum)",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _salaryController,
                  cursorColor: Colors.black,
                  focusNode:_salaryFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                  ],
                  onTap: () {
                    setState(() {
                      _validateSalary="";
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
                    hintText: "Enter your salary (per annum)",
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
                if (_validateSalary.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateSalary,
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
                const Text(
                  "Work Experience (in years)",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _workExperienceController,
                  cursorColor: Colors.black,
                  focusNode:_workExperienceFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                  ],
                  onTap: (){
                    setState(() {
                      _validateWorkExperience="";
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
                    hintText: "Enter your work experience (in years)",
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
                if (_validateWorkExperience.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateWorkExperience,
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
                const Text(
                  "Official Email",
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF374151),
                  ),
                ),
                const SizedBox(height: 4),
                TextFormField(
                  controller: _officialEmailController,
                  cursorColor: Colors.black,
                  focusNode:_officialEmailFocus,
                  keyboardType: TextInputType.emailAddress,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]')),
                  ],
                  onTap: (){
                    setState(() {
                      _validateOfficialEmail="";
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
                    hintText: "Enter your official email.",
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
                if (_validateOfficialEmail.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateOfficialEmail,
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
                const Text(
                  "Company Address",
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
                    controller: _companyAddressController,
                    cursorColor: Colors.black,
                    focusNode:_companyAddressFocus,
                    keyboardType: TextInputType.text,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._\- ,]')),
                      CapitalizationInputFormatter()
                    ],
                    onTap: () {
                      setState(() {
                        _validateCompanyAddress="";
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
                      const EdgeInsets.only(left: 10),
                      hintText: "Enter your company address",
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
                if (_validateCompanyAddress.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.8,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateCompanyAddress,
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
                const Text(
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
                  controller: _pinCodeController,
                  cursorColor: Colors.black,
                  focusNode:_pinCodeFocus,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(6)// Allows only digits
                  ],
                  onTap: (){
                    setState(() {
                      _validatePinCode="";
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
                    hintText: "Enter your company pincode",
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
                if (_validatePinCode.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.6,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validatePinCode,
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Checkbox(
                      value: declare,
                      activeColor:Color(0xff24B0FF) ,
                      onChanged: (value) {
                        setState(() {
                          declare = value!;
                          _validateDeclaration="";
                        });
                      },
                    ),
                    const Expanded(
                      child: Text(
                        "I Declare above Information is correct and True I allow Fincalis to be my Authorised representative and fetch my credit Information.",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          color: Color(0xFF374151),
                        ),
                      ),
                    ),
                  ],
                ),
                if (_validateDeclaration.isNotEmpty) ...[
                  Container(
                    alignment: Alignment.topLeft,
                    margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                    width: screenWidth * 0.9,
                    child: ShakeWidget(
                      key: Key("value"),
                      duration: Duration(milliseconds: 700),
                      child: Text(
                        _validateDeclaration,
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
                    onTap:(){
                      if(_isLoading){

                      }else{
                      _validateFields();
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
                        child:  Center(
                          child: _isLoading
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
                              letterSpacing: 1,
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
      ):
      NoInternetWidget();
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

