import 'package:fincalis/screens/PanDetailsScreen.dart';
import 'package:fincalis/student/selfie.dart';
import 'package:flutter/material.dart';

import '../Services/user_api.dart';
import '../utils/Preferances.dart';

class Fatherdetailsscreen extends StatefulWidget {
  final String schoolname;
  final String branch_name;
  final String student_name;
  final String standard;
  final String fee;

  const Fatherdetailsscreen({super.key,
    required this.schoolname, required this.branch_name, required this.student_name, required this.standard, required this.fee});

  @override
  State<Fatherdetailsscreen> createState() => _FatherdetailsscreenState();
}

class _FatherdetailsscreenState extends State<Fatherdetailsscreen> {
  bool _isContinueClicked = false;
  final TextEditingController _fatherController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _aadharController = TextEditingController();
  final TextEditingController _panController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  bool _validateFields() {
    return _fatherController.text.isNotEmpty &&
        _dobController.text.isNotEmpty &&
        _aadharController.text.isNotEmpty &&
        _panController.text.isNotEmpty &&
        _phoneNumberController.text.isNotEmpty;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.now()) {
      setState(() {
        _dobController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }



  // Future<void> SubmittingStudentDetails() async {
  //   var Userid = await PreferenceService().getString('user_id');
  //   await UserApi.SubmittingStudentDetailsApi(
  //       widget.schoolname,
  //       widget.branch_name,
  //       widget.student_name,
  //       widget.fee,
  //       _fatherController.text,
  //       _aadharController.text,
  //       _panController.text,
  //       Userid!
  //   ).then((data) => {
  //     if (data != null)
  //       {
  //         setState(() {
  //           if (data.settings?.success == 1) {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(builder: (context) => const UploadSelfie()),
  //             );
  //           }
  //         })
  //       }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
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
              padding: const EdgeInsets.only(bottom: 65, top: 40),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: const Color(0xFFCDE2FB).withOpacity(0.25),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      _buildTextField("Father / Guardian Name", _fatherController),
                      const SizedBox(height: 30),
                      _buildDateField("DOB", _dobController),
                      const SizedBox(height: 30),
                      _buildTextField("Aadhaar Number (Guardian Details)", _aadharController),
                      const SizedBox(height: 30),
                      _buildTextField("PAN (Guardian Details)", _panController),
                      const SizedBox(height: 30),
                      _buildTextField("Phone Number", _phoneNumberController),
                      const SizedBox(height: 30),
                      if (_isContinueClicked && !_validateFields())
                        const Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            "Please fill all required fields",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      const SizedBox(height: 20),
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _isContinueClicked = true;
                            });
                            if (_validateFields()) {
                              // SubmittingStudentDetails();
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Please fill all required fields"),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 56,
                            width: 180,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: const Color(0xFF2DB3FF),
                            ),
                            child: const Center(
                              child: Text(
                                "Next",
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
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Enter $label",
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

  Widget _buildDateField(String label, TextEditingController controller) {
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
        GestureDetector(
          onTap: () => _selectDate(context),
          child: AbsorbPointer(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                hintText: "Select $label",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
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

  Widget _buildStep(int stepIndex) {
    bool isCompleted = _isContinueClicked && stepIndex < 2;
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
    bool isCompleted = _isContinueClicked && separatorIndex < 2;
    Color separatorColor = isCompleted ? const Color(0xFF44BC0B) : const Color(0xFF7F807E);
    return Expanded(
      child: Container(
        height: 2,
        color: separatorColor,
        alignment: Alignment.center,
      ),
    );
  }
}
