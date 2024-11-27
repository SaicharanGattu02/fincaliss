import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/screens/mainhome.dart';
import 'package:fincalis/screens/signup.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:developer' as developer;

import '../Services/other_services.dart';

class Consentscreen extends StatefulWidget {
  const Consentscreen({super.key});

  @override
  State<Consentscreen> createState() => _ConsentscreenState();
}

class _ConsentscreenState extends State<Consentscreen> {
  var isDeviceConnected = "";
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;
  bool _agreeToAll = false;
  bool _consentNo1 = false;
  bool _consentNo2 = false;
  bool _consentNo3 = false;
  bool _consentNo4 = false;
  bool _consentNo5 = false;
  bool consentNo6 = false;

  bool consent_status=false;

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

  Future<void> ConsentApi(consent_status) async {
    print("Consent Check Box Are selected");
    var Userid = await PreferenceService().getString('user_id');
    await UserApi.Consentapi(Userid!,consent_status)
        .then((data) => {
              if (data != null)
                {
                  setState(() {
                    if (data.success == 1) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const MyMainHome()),
                      );
                    }
                  })
                }
            });
  }
  @override
  Widget build(BuildContext context) {
    return  (isDeviceConnected=="ConnectivityResult.wifi" || isDeviceConnected=="ConnectivityResult.mobile")?
      Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 50),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFFCDE2FB).withOpacity(0.25),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text(
                      "Customer Consent",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  _buildCheckbox1(
                    value: _agreeToAll,
                    onChanged: (value) {
                      setState(() {
                        _agreeToAll = value!;
                        _consentNo1 = value;
                        _consentNo2 = value;
                        _consentNo3 = value;
                        _consentNo4 = value;
                        _consentNo5 = value;
                        consentNo6 = value;
                      });
                    },
                    label: "I Agree To All",
                  ),
                  _buildDivider(),
                  SizedBox(height: 30),
                  _buildCheckbox(
                    value: _consentNo4,
                    onChanged: (value) {
                      setState(() {
                        _consentNo4 = value!;
                      });
                    },
                    label:
                    "You consent to the collection, use, and disclosure of your personal information, including but not limited to:Identification details (e.g., name, address, Social Security Number) Financial information (e.g., income, bank statements, credit history)Employment information",
                  ),
                  SizedBox(height: 30),
                  _buildCheckbox(
                    value: _consentNo1,
                    onChanged: (value) {
                      setState(() {
                        _consentNo1 = value!;
                      });
                    },
                    label:
                        "I hereby consent to receive various offers or promotional schemes from time to time by phone calls, SMS, Whatsapp, electronic e-mails or through any other modes of communication.",
                  ),
                  SizedBox(height: 30),
                  _buildCheckbox(
                    value: _consentNo2,
                    onChanged: (value) {
                      setState(() {
                        _consentNo2 = value!;
                      });
                    },
                    label:
                        "Your personal information will be used for the following purposes: Processing your loan application, Assessing your creditworthiness, Verifying the information provide, Complying with legal and regulatory requirements",
                  ),
                  SizedBox(height: 30),
                  _buildCheckbox(
                    value: _consentNo3,
                    onChanged: (value) {
                      setState(() {
                        _consentNo3 = value!;
                      });
                    },
                    label:
                        "I hereby confirm that I do not fall under the definition of Politically Exposed Persons (PEP).",
                  ),

                  // SizedBox(height: 30),
                  // _buildCheckbox(
                  //   value: _consentNo5,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       _consentNo5 = value!;
                  //     });
                  //   },
                  //   label:
                  //       "I hereby consent to receive various offers or promotional schemes from time to time by ",
                  // ),
                  // SizedBox(height: 30),
                  // _buildCheckbox(
                  //   value: consentNo6,
                  //   onChanged: (value) {
                  //     setState(() {
                  //       consentNo6 = value!;
                  //     });
                  //   },
                  //   label:
                  //       "I agree with your Terms of Services and Privacy Policy",
                  // ),
                  GestureDetector(
                    onTap: () {
                      if (_consentNo1 &&
                          _consentNo2 &&
                          _consentNo3 &&
                          _consentNo4
                       //   _consentNo5 &&
                         // consentNo6
                      ) {
                        setState(() {
                          consent_status=true;
                        });
                          ConsentApi(consent_status);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            "To continue, agree to all the terms above.",
                          style: TextStyle(color: Color(0xFF000000),fontSize: 16),),
                          duration: Duration(seconds: 2),
                          backgroundColor: Color(0xFFCDE2FB),
                        ));
                      }
                    },
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Container(
                          width: 220,
                          height: 56,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Color(0xFF2DB3FF)),
                          child: Center(
                              child: Text(
                            "Agree & continue",
                            style: TextStyle(
                                color: Color(0xFFFFFFFF),
                                fontSize: 20,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600),
                          )),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    ):
    NoInternetWidget();
  }

  Widget _buildCheckbox({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,// Align items at the start
        children: [
          Checkbox(
            value: value,
            visualDensity: VisualDensity.standard,
            onChanged: onChanged,
            activeColor: Color(0xff2DB3FF),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Align(
                alignment: Alignment.centerLeft, // Align text to the start
                child: Text(
                  label,
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCheckbox1({
    required bool value,
    required ValueChanged<bool?> onChanged,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 10,right: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Checkbox(
            value: value,
            activeColor: Color(0xff2DB3FF),
            visualDensity: VisualDensity.standard,
            onChanged: onChanged,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                label,
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 18,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 13),
      child: Container(
        height: 1,
        width: double.infinity,
        color: Color(0xFFD1D5DB),
      ),
    );
  }
}
