import 'package:fincalis/screens/congratulations.dart';
import 'package:flutter/material.dart';

class MyModeOfVerification extends StatefulWidget {
  const MyModeOfVerification({super.key});

  @override
  State<MyModeOfVerification> createState() => _MyModeOfVerificationState();
}

class _MyModeOfVerificationState extends State<MyModeOfVerification> {
  final TextEditingController _incomeVerificationController =
      TextEditingController();
  bool _isContinueClicked = false;
  String? _selectedBank;
  final List<String> _bankNames = [
    "Bank Of India",
    "State Bank Of India",
    "HDFC Bank",
    "ICICI Bank",
    "Axis Bank",
  ];

  bool _validateFields() {
    return _selectedBank != null && _selectedBank!.isNotEmpty;
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
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 44, left: 14, right: 14),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Let's Verify Your Income",
                      style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 20,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 15),
                    _buildDropdownField("", _selectedBank, _bankNames),
                    const Padding(
                      padding: EdgeInsets.only(top: 30),
                      child: Text(
                        "Choose mode of Verification",
                        style: TextStyle(
                            color: Color(0xFF034469),
                            fontSize: 20,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: VerificationCard(
                        iconPath: "assets/mobilbankig.png",
                        title: "Net Banking",
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(top: 24),
                      child: VerificationCard(
                        iconPath: "assets/price.png",
                        title: "Upload bank statements",
                      ),
                    ),
                    const SizedBox(height: 30),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _isContinueClicked = true;
                          });
                          if (_validateFields()) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyCongratulations()));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:
                                    Text("Please fill the required fields"),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        child: Center(
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
                                    fontWeight: FontWeight.w600),
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
        ),
      ),
    );
  }

  Widget _buildDropdownField(
      String label, String? selectedValue, List<String> items) {
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
        DropdownButtonFormField<String>(
          value: selectedValue,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            floatingLabelBehavior: FloatingLabelBehavior.auto,
          ),
          hint: const Text("Select Your Bank"),
          onChanged: (value) {
            setState(() {
              _selectedBank = value;
            });
          },
          items: items
              .map((item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ))
              .toList(),
        ),
        if (_isContinueClicked &&
            (selectedValue == null || selectedValue.isEmpty))
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

class VerificationCard extends StatelessWidget {
  final String iconPath;
  final String title;

  const VerificationCard({
    Key? key,
    required this.iconPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        child: Row(
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(1000),
                color: const Color(0xFFCDE2FB).withOpacity(0.25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(3),
                child: Image.asset(iconPath),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const Spacer(),
            Icon(
              Icons.keyboard_arrow_down_sharp,
              size: 24,
              color: const Color(0xFF004AAD).withOpacity(0.30),
            ),
          ],
        ),
      ),
    );
  }
}
