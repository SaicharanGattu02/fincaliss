import 'package:flutter/material.dart';

import 'banktransfer.dart';

class MyAppStatus extends StatefulWidget {
  const MyAppStatus({Key? key}) : super(key: key);

  @override
  State<MyAppStatus> createState() => _MyAppStatusState();
}

class _MyAppStatusState extends State<MyAppStatus> {
  // State variable for checkboxes
  Map<String, bool> selectionMap = {
    "1": false,
    "2": false,
    "3": false,
    "4": false,
    "5": false,
  };

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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Application Status",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 26),
                  Text(
                    "Review and sign via OTP",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontFamily: "Inter",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 20),
                  buildSelectionItem(
                      "1", "EMI Selected", "₹ 5000 for 9 months"),
                  const SizedBox(height: 20),
                  buildSelectionItem("2", "Document Verification"),
                  const SizedBox(height: 20),
                  buildSelectionItem("3", "Enable verify Auto debit (NACH)"),
                  const SizedBox(height: 20),
                  buildSelectionItem("4", "Review and submit Agreement"),
                  const SizedBox(height: 20),
                  buildSelectionItem("5", "Money Transferred to bank"),
                  const SizedBox(height: 70),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyBankTransfer()), // Replace with your next screen
                        );
                        // UploadBankStatement(filepath!);
                      },
                      child: Container(
                        height: 56,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color(0xFF2DB3FF),
                        ),
                        child: Center(
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
      ),
    );
  }

  Widget buildSelectionItem(String index, String title, [String? subtitle]) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFD1D5DB)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: const Color(0xFFE3EEFF),
              ),
              child: Center(
                child: Text(index),
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Color(0xFF111827),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  if (subtitle != null) const SizedBox(height: 8),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFF111827),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                ],
              ),
            ),
            Checkbox(
              value: selectionMap[index] ?? false,
              onChanged: (newValue) {
                setState(() {
                  selectionMap[index] = newValue ?? false;
                });
              },
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }
}