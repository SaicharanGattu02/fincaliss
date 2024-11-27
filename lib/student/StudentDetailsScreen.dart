import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/screens/PanDetailsScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../Services/user_api.dart';
import '../classes/FirstLetterCaps.dart';
import '../model/StudentModel.dart';
import '../utils/Preferances.dart';
import '../utils/ShakeWidget.dart';
import 'dart:developer' as developer;

class Studentdetailsscreen extends StatefulWidget {
  final bool isBasicCompleted;
  const Studentdetailsscreen({super.key, required this.isBasicCompleted});
  @override
  State<Studentdetailsscreen> createState() => _StudentdetailsscreenState();
}

class _StudentdetailsscreenState extends State<Studentdetailsscreen> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _isContinueClicked = false;

  final TextEditingController _nameOfSchoolController = TextEditingController();
  final TextEditingController _branchOfSchoolController =
  TextEditingController();
  final TextEditingController _studentNameController = TextEditingController();
  final TextEditingController _classController = TextEditingController();
  final TextEditingController _feeController = TextEditingController();
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  final FocusNode studentfocus = FocusNode();
  final FocusNode branchofschool = FocusNode();
  final FocusNode classfocus = FocusNode();
  final FocusNode feefocus = FocusNode();
  final FocusNode fathergaurdian = FocusNode();
  final FocusNode gardianaadhar = FocusNode();
  final FocusNode gardianpan = FocusNode();
  final FocusNode gardianNum = FocusNode();
  final FocusNode address = FocusNode();

  bool isFetched = false;
  var is_loading = true;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    GetStudentDetails();
    GetSchoolnames();

    // Add listeners to controllers
    _nameOfSchoolController.addListener(() {
      setState(() {
        _validateSchoolName = "";
      });
    });
    _studentNameController.addListener(() {
      setState(() {
        _validateFullName = "";
      });
    });
    _classController.addListener(() {
      setState(() {
        _validateClass = "";
      });
    });
    _feeController.addListener(() {
      setState(() {
        _validateFee = "";
      });
    });
    _fatherController.addListener(() {
      setState(() {
        _validateFatherName = "";
      });
    });

    _phoneNumberController.addListener(() {
      setState(() {
        _validatePhoneNumber = "";
      });
    });
    _studentNameController.addListener(() {
      setState(() {
        _validStudentName = "";
      });
    });
    _branchOfSchoolController.addListener(() {
      setState(() {
        _validateBranchOfSchool = "";
      });
    });
    _addressController.addListener(() {
      setState(() {
        _validateAddress = "";
      });
    });
  }

  Future<void> GetSchoolnames() async {
    try {
      final data = await UserApi.GetSchoolnamesApi();
      if (data != null) {
        setState(() {
          if (data.settings?.success == 1) {
            filteredItems = data.data?.result?.map((item) => item.name ?? "").toList() ?? [];
          } else {
            is_loading = false;
          }
        });
      }
    } catch (e) {
      print('Error fetching school names: $e');
    }
  }


  @override
  void dispose() {
    _nameOfSchoolController.dispose();
    _branchOfSchoolController.dispose();
    _studentNameController.dispose();
    _classController.dispose();
    _feeController.dispose();
    _fatherController.dispose();
    _phoneNumberController.dispose();
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

  String _validateFullName = "";
  String _validateClass = "";
  String _validateFee = "";
  String _validateFatherName = "";
  String _validatePhoneNumber = "";
  String _validateAddress = "";
  String _validateSchoolName = "";
  String _validStudentName = "";
  String _validateBranchOfSchool = "";

  bool isworkcompleted = false;
  List<String> filteredItems = [];
  String selectedItem="";

  _validateFields() {
    setState(() {
      _isLoading=true;
      _validateFullName = _studentNameController.text.isEmpty
          ? "Please enter the student's name"
          : "";
      _validateSchoolName = _nameOfSchoolController.text.isEmpty
          ? "Please select your school name"
          : "";
      _validateClass =
      _classController.text.isEmpty ? "Please enter the class" : "";
      _validateFee = _feeController.text.isEmpty ? "Please enter the fee" : "";
      _validateFatherName = _fatherController.text.isEmpty
          ? "Please enter the father/guardian's name"
          : "";

      _validStudentName = _studentNameController.text.isEmpty
          ? "Please enter your full name"
          : "";
      _validatePhoneNumber = _phoneNumberController.text.isEmpty || _phoneNumberController.text.length<10
          ? "Please enter your Phone number"
          : "";

      _validateBranchOfSchool = _branchOfSchoolController.text.isEmpty
          ? "Please enter your branch"
          : "";
      _validateAddress = _addressController.text.isEmpty
          ? "Please enter your school address"
          : "";
    });

    if (_validateFullName.isEmpty &&
        _validateClass.isEmpty &&
        _validateFee.isEmpty &&
        _validateFatherName.isEmpty &&
        _validateSchoolName.isEmpty &&
        _validateAddress.isEmpty &&
        _validatePhoneNumber.isEmpty) {
      String status = isFetched ? "Update" : "Insert";
      SubmittingStudentDetails(status);
    }else{
      setState(() {
        _isLoading=false;
      });
    }
  }

  Result? result = Result();

  Future<void> GetStudentDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.GetSchoolDetailsApi(Userid!).then((data) => {
      if (data != null)
        {
          setState(() {
            if (data.settings?.success == 1) {
              isFetched = true;
              is_loading = false;
              isworkcompleted = true;
              result=data.data?.result;
              _nameOfSchoolController.text = result?.schoolName ?? "";
              _branchOfSchoolController.text = result?.branch ?? "";
              _classController.text = result?.studentClass ?? "";
              _studentNameController.text = result?.studentName ?? "";
              double fee = result?.fee ?? 0.0;
              _feeController.text = fee.toString();
              _fatherController.text = result?.guardianName ?? "";
              _phoneNumberController.text = result?.guardianMobile ?? "";
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                  "Student Details fetched successfully!",
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

  Future<void> SubmittingStudentDetails(status) async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.SubmittingStudentDetailsApi(
        _nameOfSchoolController.text,
        _branchOfSchoolController.text,
        _classController.text,
        _studentNameController.text,
        _feeController.text,
        _fatherController.text,
        _phoneNumberController.text,
        Userid!,
        _addressController.text,
        status)
        .then((data) => {
      if (data != null)
        {
          setState(() async {
            if (data.success == 1) {
              _isLoading=false;
              var res= await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                    const PanDetails(isworkdetailsCompleted: true,from:"Student")),
              );
              if(res==true){
                is_loading = true;
                GetStudentDetails();
                GetSchoolnames();
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
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
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
        body: (is_loading)
            ? Center(child: CircularProgressIndicator(
          color: Color(0xff2DB3FF),
         ))
            : SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 25,right: 25,top:10,bottom: 10),
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
              Padding(
                padding: EdgeInsets.only(left: 15,right: 16),
                child: Row(
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
              ),
              Container(
                margin: EdgeInsets.only(top: 40,bottom: 40,left: 20,right: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFCDE2FB).withOpacity(0.25),
                ),
                child: Padding(
                  padding: EdgeInsets.only(left: 20,right: 20,top: 30,bottom: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "School Details",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter your School Name",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TypeAheadFormField<String>(
                        textFieldConfiguration: TextFieldConfiguration(
                          controller:_nameOfSchoolController,
                          onTap: (){
                            setState(() {
                              _validateSchoolName="";
                            });
                          },
                          onChanged: (v){
                            setState(() {
                              _validateSchoolName="";
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
                            hintText: "Enter your school name",
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
                        suggestionsCallback: (pattern) {
                          return filteredItems.where((item) => item.toLowerCase().contains(pattern.toLowerCase())).toList();
                        },
                        itemBuilder: (context, suggestion) {
                          return ListTile(
                            title: Text(suggestion,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily:"Inter",
                                  fontWeight: FontWeight.w400
                              ),
                            ),
                          );
                        },
                        onSuggestionSelected: (suggestion) {
                          setState(() {
                            selectedItem = suggestion;
                            _nameOfSchoolController.text=selectedItem!;
                            _validateSchoolName="";
                          });
                        },
                        onSuggestionsBoxToggle: (p0) {

                        },
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select an item';
                          }
                          return null;
                        },
                      ),
                      if (_validateSchoolName.isNotEmpty) ...[
                        ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            "Please select your school",
                            style: TextStyle(
                              fontFamily: "Poppins",
                              fontSize: 12,
                              color: Colors.red,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Branch of School",
                          _branchOfSchoolController,
                          TextInputType.text,
                          _validateBranchOfSchool,
                          branchofschool,
                          r'^[a-zA-Z\s]+$',
                          0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Student Name",
                          _studentNameController,
                          TextInputType.name,
                          _validStudentName,
                          studentfocus,
                          r'^[a-zA-Z\s]+$',
                      0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Class",
                          _classController,
                          TextInputType.text,
                          _validateClass,
                          classfocus,
                          r'^[0-9\s]+$',
                        0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Fee",
                          _feeController,
                          TextInputType.number,
                          _validateFee,
                          feefocus,
                          r'^\d+(\.\d{1,2})?$',
                          0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Father / Guardian Name",
                          _fatherController,
                          TextInputType.name,
                          _validateFatherName,
                          fathergaurdian,
                          r'^[a-zA-Z\s]+$',
                           0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                          "Mobile Number",
                          _phoneNumberController,
                          TextInputType.number,
                          _validatePhoneNumber,
                          gardianNum,
                          r'^\d+(\.\d{1,2})?$',
                        10,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 15),
                      _buildTextField(
                        "School Address",
                        _addressController,
                        TextInputType.text,
                          _validateAddress,
                        address,
                        r'[a-zA-Z0-9\s,.-]',
                        0,
                        [CapitalizationInputFormatter()],
                      ),
                      const SizedBox(height: 50),
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
                              color: const Color(0xFF2DB3FF),
                            ),
                            child: Center(
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
      ):
      Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/nointernet.png",
              width: 47,
              height: 47,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 48),
              child: Text(
                "Connect to the Internet",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 13),
              child: Text(
                "You are Offline. Please Check Your Connection",
                style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 16,
                    fontWeight: FontWeight.w400),
              ),
            ),
            GestureDetector(
              onTap: () {
                (context as Element).reassemble();
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 38),
                child: Container(
                  width: 240,
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: const Color(0xFF2DB3FF),
                  ),
                  child: const Center(
                    child: Text(
                      "Retry",
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
    );
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
          onChanged: (text) {
            setState(() {
              // Clear validation message when user starts typing
              if (label == "Name of School") _validateSchoolName = "";
              if (label == "Student Name") _validateFullName = "";
              if (label == "Class") _validateClass = "";
              if (label == "Fee") _validateFee = "";
              if (label == "Father / Guardian Name") _validateFatherName = "";
              if (label == "PhoneNumber") _validatePhoneNumber = "";
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

  Widget _buildStep(int stepIndex) {
    bool isCompleted = (isworkcompleted) && stepIndex < 2 ||  (widget.isBasicCompleted) && stepIndex < 1 ;
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