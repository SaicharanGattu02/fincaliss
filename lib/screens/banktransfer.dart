import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/screens/ReferencesScreen.dart';
import 'package:fincalis/screens/applicationtiming.dart';
import 'package:fincalis/screens/enach.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fincalis/utils/ShakeWidget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'dart:developer' as developer;
import '../Services/other_services.dart';
import '../model/GetBankListModel.dart';


class MyBankTransfer extends StatefulWidget {
  const MyBankTransfer({Key? key}) : super(key: key);

  @override
  State<MyBankTransfer> createState() => _MyBankTransferState();
}

class _MyBankTransferState extends State<MyBankTransfer> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;


  final FocusNode acntnumFocus = FocusNode();
  final FocusNode confirmacntnumFocus = FocusNode();
  final FocusNode ifscFocus = FocusNode();

  final TextEditingController _bankController = TextEditingController();
  final TextEditingController _accountNumberController = TextEditingController();
  final TextEditingController _confirmAccountNumberController = TextEditingController();
  final TextEditingController _ifscCodeController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();

  bool _isLoading = false;
  List<String> filteredItems = [
    "State Bank of India (SBI)",
    "Punjab National Bank (PNB)",
    "Bank of Baroda",
    "Canara Bank",
    "Union Bank of India",
    "Bank of India",
    "Indian Bank",
    "Central Bank of India",
    "Indian Overseas Bank",
    "UCO Bank",
    "HDFC Bank",
    "ICICI Bank",
    "Axis Bank",
    "Kotak Mahindra Bank",
    "Yes Bank",
    "IDFC FIRST Bank",
    "IndusInd Bank",
    "Bandhan Bank",
    "Federal Bank",
    "RBL Bank",
  ];
  String selectedItem="";


  String _validateAccountnum = "";
  String _validateConfirmAccountnum = "";
  String _validateIfsc = "";
  String _validateBank = "";

  @override
  void dispose() {
    _bankController.dispose();
    _accountNumberController.dispose();
    _confirmAccountNumberController.dispose();
    _ifscCodeController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    ShowBankList() ;
    _accountNumberController.addListener(() {
      setState(() {
        _validateAccountnum = "";
      });
    });
    _confirmAccountNumberController.addListener(() {
      setState(() {
        _validateConfirmAccountnum = "";
      });
    });
    _ifscCodeController.addListener(() {
      setState(() {
        _validateIfsc = "";
      });
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


  Future<void> ShowBankList() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final data = await UserApi.GetBankListApi();
      if (data != null && data.settings?.success == 1) {
        setState(() {
           filteredItems = data.data?.result?.map((item) => item.bankName ?? "").toList() ?? [];
        });
      } else {
        // Handle the case where the bank list is not fetched
        print("Bank list is Not Fetched");
      }
    } catch (e) {
      // Handle error
      print("Error fetching bank list: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Result result = Result();

  Future<void> SubmitBankDetails() async {
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.BankTransferApi(
        Userid!, _accountNumberController.text, _ifscCodeController.text,)
        .then((data) {
      if (data != null) {
        if (mounted) {  // Check if widget is still mounted
          setState(() {
            _isLoading = false;
          });
          if (data.success == 1) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ReferencesScreen()),
            );
            Flashbar(context, "Bank details verified successfully!", "bank1");

          } else {
            setState(() {
              _isLoading = false;
            });
            Flashbar(context, "Bank details verification failed!", "bank2");
          }
        }
      }
    });
  }

  void _validateFields() {
    setState(() {
      _isLoading = true;
      _validateAccountnum = _accountNumberController.text.isEmpty
          ? "Please enter your account number"
          : '';
      _validateConfirmAccountnum = _confirmAccountNumberController.text.isEmpty
          ? "Please confirm your account number"
          : (_confirmAccountNumberController.text !=
          _accountNumberController.text
          ? "Account numbers do not match"
          : '');

      _validateIfsc =
      _ifscCodeController.text.isEmpty ? "Please enter your IFSC code" : '';
      _validateBank = _bankController.text.isEmpty ? "Please select a bank" : '';
    });

    if (_validateAccountnum.isEmpty &&
        _validateConfirmAccountnum.isEmpty &&
        _validateIfsc.isEmpty &&
        _validateBank.isEmpty) {
      SubmitBankDetails();
    }else{
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFCDE2FB).withOpacity(0.25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: Text(
                        "Bank Information",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 24,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: Text(
                        "Your loan amount will be transferred to and EMI’s be deducted from your account",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 44),
                    // _buildDropdownField("Select Bank", _selectedBank),
                    Text(
                      "Bank Name",
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 10),
                    TypeAheadFormField<String>(
                      textFieldConfiguration: TextFieldConfiguration(
                        controller:_bankController,
                        onTap: (){
                          setState(() {
                            _validateBank="";
                          });
                        },
                        onChanged: (v){
                          setState(() {
                            _validateBank="";
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
                          hintText: "Enter your full name",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Color(0xFF004AADF).withOpacity(0.30),
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
                          _bankController.text=selectedItem!;
                          _validateBank="";
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
                    if (_validateBank.isNotEmpty) ...[
                      Container(
                        alignment: Alignment.topLeft,
                        // margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
                        // width: screenWidth * 0.8,
                        child: ShakeWidget(
                          key: Key("value"),
                          duration: Duration(milliseconds: 700),
                          child: Text(
                            _validateBank,
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
                         height: 10,
                      ),
                    ],
                    SizedBox(height: 10),
                    _buildTextField(
                        "Account Number",
                        _accountNumberController,
                        TextInputType.number,
                        acntnumFocus,
                        r'[0-9\s]',
                        _validateAccountnum,
                        true),
                    const SizedBox(height: 15),
                    _buildTextField(
                        "Confirm Account Number",
                        _confirmAccountNumberController,
                        TextInputType.number,
                        confirmacntnumFocus,
                        r'[0-9\s]',
                        _validateConfirmAccountnum,
                        false),
                    const SizedBox(height: 15),
                    _buildTextField(
                        "IFSC CODE",
                        _ifscCodeController,
                        TextInputType.text,
                        ifscFocus,
                        r'[A-Z0-9]',
                        _validateIfsc,
                        false),
                    const SizedBox(height: 80),
                    Center(
                      child: GestureDetector(
                        onTap: (){
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
    ):
      NoInternetWidget();
  }

  Widget _buildTextField(
      String label,
      TextEditingController controller,
      TextInputType keyboardType,
      FocusNode focusNode,
      String validationPattern,
      String validateMessage,
      bool obscure) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
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
          textCapitalization: TextCapitalization.characters,
          keyboardType: keyboardType,
          obscureText: obscure,
          onTap: () {
            setState(() {
              validateMessage = "";
            });
          },
          decoration: InputDecoration(
            hintText: "Enter $label",
            hintStyle: TextStyle(
              fontSize: 15,
              letterSpacing: 0,
              height: 1.2,
              color: Color(0xFF004AADF).withOpacity(0.30),
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: Color(0xffffffff),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(width: 1, color: Color(0xffCDE2FB)),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(validationPattern)),
          ],
        ),
        if (validateMessage.isNotEmpty) ...[
          Container(
            alignment: Alignment.topLeft,
            // margin: EdgeInsets.only(left: 8,bottom: 10,top: 5),
            // width: screenWidth * 0.8,
            child: ShakeWidget(
              key: Key("value"),
              duration: Duration(milliseconds: 700),
              child: Text(
                validateMessage,
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
            // height: 15,
          ),
        ],
      ],
    );
  }
  //
  // Widget _buildDropdownField(String label, String? value) {
  //   double screenWidth = MediaQuery.of(context).size.width;
  //
  //   // Debug: Print current filteredItems
  //   print("Filtered Items: $filteredItems");
  //
  //   // Ensure that all items are unique
  //   final uniqueFilteredItems = filteredItems.toSet().toList();
  //
  //   return Column(
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text(
  //         label,
  //         style: const TextStyle(
  //           fontSize: 16,
  //           fontWeight: FontWeight.w500,
  //           color: Color(0xFF000000),
  //         ),
  //       ),
  //       const SizedBox(height: 5),
  //       Container(
  //         width: screenWidth,
  //         height: 55,
  //         decoration: BoxDecoration(
  //           color: Color(0xFFFFFFFF),
  //           borderRadius: BorderRadius.circular(15),
  //           border: Border.all(color: Color(0xffCDE2FB)),
  //         ),
  //         child: DropdownButtonHideUnderline(
  //           child: DropdownButton2<String>(
  //             isExpanded: true,
  //             hint: Text(
  //               'Select your bank',
  //               style: TextStyle(
  //                 fontSize: 14,
  //                 color: Color(0xFF004AADF).withOpacity(0.30),
  //               ),
  //             ),
  //             items: uniqueFilteredItems
  //                 .map((item) => DropdownMenuItem<String>(
  //               value: item,
  //               child: Text(
  //                 item,
  //                 style: const TextStyle(
  //                   fontSize: 14,
  //                 ),
  //               ),
  //             ))
  //                 .toList(),
  //             value: value,
  //             onChanged: (value) {
  //               setState(() {
  //                 _selectedBank = value;
  //               });
  //             },
  //             buttonStyleData: const ButtonStyleData(
  //               padding: EdgeInsets.symmetric(horizontal: 16),
  //               height: 40,
  //               width: 200,
  //             ),
  //             dropdownStyleData: const DropdownStyleData(
  //               maxHeight: 300,
  //               decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.all(Radius.circular(15)),
  //               ),
  //             ),
  //             menuItemStyleData: const MenuItemStyleData(
  //               height: 40,
  //             ),
  //             dropdownSearchData: DropdownSearchData(
  //               searchController: _bankController,
  //               searchInnerWidgetHeight: 50,
  //               searchInnerWidget: Container(
  //                 height: 50,
  //                 padding: const EdgeInsets.all(8),
  //                 child: TextFormField(
  //                   expands: true,
  //                   maxLines: null,
  //                   controller: _bankController,
  //                   style: TextStyle(
  //                     fontSize: 15,
  //                     fontWeight: FontWeight.w500,
  //                     fontFamily: "Inter",
  //                   ),
  //                   onChanged: _filterItems,
  //                   decoration: InputDecoration(
  //                     isDense: true,
  //                     contentPadding: const EdgeInsets.symmetric(
  //                       horizontal: 10,
  //                       vertical: 8,
  //                     ),
  //                     hintText: 'Search for a bank...',
  //                     hintStyle: const TextStyle(fontSize: 12),
  //                     border: OutlineInputBorder(
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             onMenuStateChange: (isOpen) {
  //               if (!isOpen) {
  //                 _bankController.clear();
  //                 // Reset filteredItems to unique items
  //                 filteredItems = tempfilteredItems.toSet().toList();
  //               }
  //             },
  //           ),
  //         ),
  //       ),
  //       if (_isContinueClicked && _validateBank.isNotEmpty)
  //         Container(
  //           alignment: Alignment.topLeft,
  //           margin: const EdgeInsets.only(left: 8, bottom: 10, top: 5),
  //           width: screenWidth * 0.8,
  //           child: ShakeWidget(
  //             key: Key("dropdown"),
  //             duration: const Duration(milliseconds: 700),
  //             child: Text(
  //               _validateBank,
  //               style: const TextStyle(
  //                 fontFamily: "Poppins",
  //                 fontSize: 12,
  //                 color: Colors.red,
  //                 fontWeight: FontWeight.w500,
  //               ),
  //             ),
  //           ),
  //         ),
  //     ],
  //   );
  // }


}