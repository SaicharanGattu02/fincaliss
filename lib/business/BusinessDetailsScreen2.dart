import 'package:fincalis/screens/BankDetailsScreen.dart';
import 'package:flutter/material.dart';

class BusinessDetails2 extends StatefulWidget {
  const BusinessDetails2({Key? key}) : super(key: key);

  @override
  State<BusinessDetails2> createState() => _BusinessDetails2State();
}

class _BusinessDetails2State extends State<BusinessDetails2> {
  bool _isContinueClicked = false;
  final TextEditingController _registeredAddressController = TextEditingController();
  final TextEditingController _officialEmailController = TextEditingController();
  final TextEditingController _annualIncomeController = TextEditingController();
  final TextEditingController _registrationTypeController = TextEditingController();
  final TextEditingController _pincodeController = TextEditingController();

  bool _validateFields() {
    return _registeredAddressController.text.isNotEmpty &&
        _officialEmailController.text.isNotEmpty &&
        _annualIncomeController.text.isNotEmpty &&
        _registrationTypeController.text.isNotEmpty &&
        _pincodeController.text.isNotEmpty;
  }

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
                      const Text(
                        "Add Business Details",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontFamily: 'Poppins',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Enter Details about your Business",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buildTextField("Registered Address", _registeredAddressController),
                      const SizedBox(height: 30),
                      _buildTextField("Official Email", _officialEmailController),
                      const SizedBox(height: 30),
                      _buildTextField("Pincode", _pincodeController),
                      const SizedBox(height: 30),
                      _buildTextField("Annual Income", _annualIncomeController),
                      const SizedBox(height: 30),
                      _buildDropdown("Registration Type", _registrationTypeController, [
                        'Private Limited',
                        'Public Limited',
                        'Partnership',
                        'Sole Proprietorship',
                      ]),
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

  Widget _buildDropdown(String label, TextEditingController controller, List<String> items) {
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
        DropdownButtonFormField<String>(
          value: controller.text.isEmpty ? null : controller.text,
          onChanged: (newValue) {
            setState(() {
              controller.text = newValue!;
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          decoration: InputDecoration(
            hintText: "Select $label",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
        ),
        if (_isContinueClicked && controller.text.isEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Please select $label",
              style: const TextStyle(
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
    bool isCompleted = _isContinueClicked && separatorIndex < 2;
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
