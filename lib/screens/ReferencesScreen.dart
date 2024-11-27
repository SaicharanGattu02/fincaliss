import 'package:fincalis/screens/modeofverification.dart';
import 'package:flutter/material.dart';

import 'CreditScore.dart';
import 'PendingScreen.dart';
import 'StudentFriendReference.dart';
import 'StudentGaurdianReference.dart';

class ReferencesScreen extends StatefulWidget {
  const ReferencesScreen({super.key});

  @override
  State<ReferencesScreen> createState() => _MyReferencesState();
}

class _MyReferencesState extends State<ReferencesScreen> {
  final TextEditingController _fatherreferenceController = TextEditingController();
  final TextEditingController _FreferenceController = TextEditingController();
  bool _isContinueClicked = false;

  bool _validateFields() {
    return _fatherreferenceController.text.isNotEmpty &&
        _FreferenceController.text.isNotEmpty;
  }

  String Gaurdian="";
  String Friend="";

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
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
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            height: screenHeight*0.88,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Center(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 76, right: 76),
                    child: Image.asset(
                      "assets/reference.png",
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 14, right: 14, top: 24),
                    child: Column(
                      children: [
                        Text(
                          "Personal References For Your Loan",
                          style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 24,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Poppins'),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "As part of your loan agreement review we’d like to provide details of 2 personal references for further verification",
                          style: TextStyle(
                              color: Color(0xFF374151),
                              fontSize: 14,
                              fontWeight: FontWeight.w400),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, top: 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Family or Relatives reference",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        InkWell(
                          onTap: () async {
                            var res= await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => GuardianReferenceScreen()),
                            );
                            if(res=="Reference1 Added"){
                              setState(() {
                                Gaurdian="Reference1 Added";
                              });
                            }
                          },
                          child: Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 10),
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color:(Gaurdian!="")?Color(0xFF44BC0B): Color(0xFFCDE2FB)),
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Color(0xFF000000),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text((Gaurdian!="")?Gaurdian:"Add Reference",
                                    style: TextStyle(
                                        color: Color(0xFF004AAD).withOpacity(0.50),
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      SizedBox(height: 10,),
                        Text(
                          "Friends Reference",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF374151),
                          ),
                        ),
                        InkWell(
                          onTap: () async{
                            var result= await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => FriendReferenceScreen()),
                            );
                            print("res:${result}");
                            if(result=="Reference2 Added"){
                              setState(() {
                                Friend="Reference2 Added";
                              });
                            }
                          },
                          child:Container(
                            height: 50,
                            margin: EdgeInsets.only(top: 15),
                            padding: EdgeInsets.only(left: 15),
                            decoration: BoxDecoration(
                              border: Border.all(color:(Friend!="")?Color(0xFF44BC0B):  Color(0xFFCDE2FB)),
                              borderRadius: BorderRadius.circular(15),
                              color: Color(0xFFFFFFFF),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Icon(
                                  Icons.add,
                                  size: 20,
                                  color: Color(0xFF000000),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text((Friend!="")?Friend:
                                    "Add Reference",
                                    style: TextStyle(
                                        color: Color(0xFF004AAD).withOpacity(0.50),
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: screenHeight*0.1,),
                  GestureDetector(
                    onTap: () {
                      if (Gaurdian != "Reference1 Added") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please add Guardian reference.",
                              style: TextStyle(color: Color(0xff000000)),
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color(0xFFCDE2FB),
                          ),
                        );
                      } else if (Friend != "Reference2 Added") {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              "Please add Friend reference.",
                              style: TextStyle(color: Color(0xff000000)),
                            ),
                            duration: Duration(seconds: 1),
                            backgroundColor: Color(0xFFCDE2FB),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CreditScore(),
                          ),
                        );
                      }

                    },
                    child: Container(
                      width: 240,
                      height: 56,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: const Color(0xFF2DB3FF),
                      ),
                      child: const Center(
                        child: Text(
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
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
        TextField(
          controller: controller,
          decoration: InputDecoration(
            suffixIcon: Icon(Icons.phone,
                size: 24, color: const Color(0xFF004AAD).withOpacity(0.30)),
            hintText: "Select Your Mobile Number",
            hintStyle: TextStyle(color: const Color(0xFF004AAD).withOpacity(0.30)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
        if (_isContinueClicked && controller.text.isEmpty)
          const Padding(
            padding: EdgeInsets.only(top: 8.0),
            child: Text(
              "Please fill this field",
              style: TextStyle(
                color: Colors.red,
                fontSize: 12,
              ),
            ),
          ),
      ],
    );
  }
}
