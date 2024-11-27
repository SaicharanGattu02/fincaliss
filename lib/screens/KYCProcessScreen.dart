import 'package:fincalis/classes/setupitem.dart';
import 'package:fincalis/screens/BasicDetailsScreen.dart';
import 'package:fincalis/screens/CreditScore.dart';
import 'package:fincalis/screens/PanDetailsScreen.dart';
import 'package:fincalis/screens/PendingScreen.dart';
import 'package:fincalis/screens/ReferencesScreen.dart';
import 'package:fincalis/screens/banktransfer.dart';
import 'package:fincalis/student/StudentDetailsScreen.dart';
import 'package:fincalis/student/selfie.dart';
import 'package:flutter/material.dart';

import '../Services/user_api.dart';
import '../business/BusinessDetailsScreen1.dart';
import '../employe/EmployeeDetailsScreen.dart';
import '../model/KycProcessStatusModel.dart';
import '../utils/Preferances.dart';
import 'BankDetailsScreen.dart';
import 'congratulations.dart';


class Kycprocessscreen extends StatefulWidget {
  const Kycprocessscreen({super.key});
  @override
  State<Kycprocessscreen> createState() => _KycprocessscreenState();
}
class _KycprocessscreenState extends State<Kycprocessscreen> {
  String provision_status="";
  bool is_basic_completed=false;
  bool is_work_completed=false;
  bool is_pan_verified=false;
  bool is_adhaar_verified=false;
  bool is_pan_image_uploaded=false;
  bool is_document_completed=false;

  Result? result=Result();
  @override
  void initState() {
    super.initState();
    KycProcessStatus();
  }


  Future<void> KycProcessStatus() async {
    var userId = await PreferenceService().getString('user_id');
    await UserApi.KycProcessStatusapi(userId!).then((data) {
      if (data != null && data.data != null) {
        setState(() {
          result = data.data!.result;
        });
      } else {
        setState(() {
          result = null; // Set to null or some default value if needed
        });
      }
    }).catchError((error) {
      // Handle error, e.g., show an error message
      print('Error fetching KYC status: $error');
    });
  }


  void NavigationBasedOnCondition() {
    if (result == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => BasicDetails()), // Replace with your next screen
      );
    }
    if(result!.provisionStatus=="employee"){
      if(result!.isBasicCompleted==true){
        if(result!.isWorkCompleted==true){
          if(result!.isPanVerified==true && result!.isAdhaarVerified==true && result!.isPanImageUploaded==true && result!.isAadharImageUploaded==true){
            if(result!.isLivenessCompleted==true){
              if(result!.isDocumentCompleted==true){
                if(result!.isBankVerified==true){
                  if(result!.isReferenceCompleted==true){
                    if(result!.isCreditReportAdded==true){

                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CreditScore()),
                      );
                    }

                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ReferencesScreen()),
                    );
                  }

                }else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyBankTransfer()),
                  );
                }

              }else{
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BankDetailsScreen(isKycCompleted: true)),
                );
              }

            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UploadSelfie()),
              );
            }
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PanDetails(isworkdetailsCompleted:result!.isWorkCompleted ?? false,from: "",)), // Replace with your next screen
            );
          }
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => EmploymentDetails(isBasicCompleted:result!.isBasicCompleted ?? false,)), // Replace with your next screen
          );
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BasicDetails()), // Replace with your next screen
        );
      }
    }else if(result!.provisionStatus=="student"){
      if(result!.isBasicCompleted==true){
        if(result!.isWorkCompleted==true){
          if(result!.isPanVerified==true && result!.isAdhaarVerified==true && result!.isPanImageUploaded==true && result!.isAadharImageUploaded==true){
            if(result!.isLivenessCompleted==true){
              if(result!.isDocumentCompleted==true){
                if(result!.isBankVerified==true){
                  if(result!.isReferenceCompleted==true){
                    if(result!.isCreditReportAdded==true){

                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CreditScore()),
                      );
                    }

                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ReferencesScreen()),
                    );
                  }

                }else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyBankTransfer()),
                  );
                }

              }else{
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BankDetailsScreen(isKycCompleted: true)),
                );
              }

            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UploadSelfie()),
              );
            }
          }
        } else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Studentdetailsscreen(isBasicCompleted:result!.isBasicCompleted ?? false,)), // Replace with your next screen
          );
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BasicDetails()), // Replace with your next screen
        );
      }

    }else if(result!.provisionStatus=="business"){
      if(result!.isBasicCompleted==true){
        if(result!.isWorkCompleted==true){
          if(result!.isPanVerified==true && result!.isAdhaarVerified==true && result!.isPanImageUploaded==true && result!.isAadharImageUploaded==true){
            if(result!.isLivenessCompleted==true){
              if(result!.isDocumentCompleted==true){
                if(result!.isBankVerified==true){
                  if(result!.isReferenceCompleted==true){
                    if(result!.isCreditReportAdded==true){

                    }else{
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => CreditScore()),
                      );
                    }

                  }else{
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => ReferencesScreen()),
                    );
                  }

                }else{
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => MyBankTransfer()),
                  );
                }

              }else{
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BankDetailsScreen(isKycCompleted: true)),
                );
              }

            }else{
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UploadSelfie()),
              );
            }
          }else{
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PanDetails(isworkdetailsCompleted:result!.isWorkCompleted ?? false,from: "",)), // Replace with your next screen
            );
          }
        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BusinessDetails1(isBasicCompleted:result!.isBasicCompleted ?? false,)), // Replace with your next screen
          );
        }
      }else{
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => BasicDetails()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
      Navigator.pop(context,true);
      return false;
    },
        child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 24, top: 12),
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context,true);
              },
              child: Image.asset(
                "assets/farrow.png",
                width: 24,
                height: 24,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 18, right: 18, top: 10, bottom: 70),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xFFCDE2FB).withOpacity(0.25),
                  ),
                  child: Column(children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Text(
                        "Great",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Poppins',
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Center(
                        child: Text(
                          "You are just a few more steps away \nfrom getting the Loan",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Color(0xFF374151),
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 30,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 250,
                                child: buildStepItem("1", "Basic Information")),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 40, top: 10),
                            //   child:(result!.isBasicCompleted ?? false)?_buildStep():Container(),
                            // )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 250,
                                child: buildStepItem("2", "Verify KYC")),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 40, top: 10),
                            //   child: (result!.isPanImageUploaded!! && result!.isAadharImageUploaded!! && result!.isPanVerified!! && result!.isAdhaarVerified!!) ? _buildStep() : Container(),
                            // )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                                width: 250,
                                child:
                                buildStepItem("3", "Setup EMI auto debit")),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 40, top: 10),
                            //   child: _buildStep(),
                            // ),
                          ],
                        ),
                        Row(
                          children: [
                            Container(width: 250,
                                child: buildStepItem(
                                    "4", "Review and sign \nagreement")),
                            // Padding(
                            //   padding: const EdgeInsets.only(left: 40, top: 10),
                            //   child: _buildStep(),
                            // ),
                          ],
                        ),
                      ],
                    ),
                    Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 40),
                      child: GestureDetector(
                        onTap: () async {
                          var res= await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BasicDetails()),
                          );
                          if(res==true){
                            KycProcessStatus();
                          }
                         //  NavigationBasedOnCondition();
                        },
                        child: Container(
                          width: 183,
                          height: 53,
                          decoration: BoxDecoration(
                              color: Color(0xFF24B0FF),
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Let's Go",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.arrow_forward_rounded,
                              color: Color(0xffffffff))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
                ),
              ),
            )
          ],
        ),
            ),
      );
  }
}

Widget _buildStep() {
  Color stepColor = const Color(0xFF44BC0B);
  return Container(
    width: 20,
    height: 20,
    decoration: BoxDecoration(
      color: stepColor,
      borderRadius: BorderRadius.circular(100),
    ),
    child: Center(
        child: const Icon(
          Icons.check,
          color: Colors.white,
          size: 10,
        )),
  );
}