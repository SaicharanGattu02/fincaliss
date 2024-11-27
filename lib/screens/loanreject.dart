import 'package:flutter/material.dart';

class MyLoanReject extends StatefulWidget {
  const MyLoanReject({super.key});

  @override
  State<MyLoanReject> createState() => _MyLoanRejectState();
}

class _MyLoanRejectState extends State<MyLoanReject> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 174,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color(0xFFB7E1F8).withOpacity(0.40),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 44, right: 24, left: 24),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back),
                      ),
                      Spacer(),
                      Text(
                        "Refer & Earn",
                        style: TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Spacer(),
                      Icon(Icons.wifi_calling_3_sharp),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, left: 50, right: 50),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          _buildStep(0),
                          const SizedBox(height: 5),
                          Text("Basic Details"),
                        ],
                      ),
                      _buildSeparator(),
                      Column(
                        children: [
                          _buildStep(1),
                          const SizedBox(height: 5),
                          Text("Additional Details"),
                        ],
                      ),
                      _buildSeparator(),
                      Column(
                        children: [
                          _buildStep(2, isFinalStep: true),
                          const SizedBox(height: 5),
                          Text("Loan Offer"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStep(int stepIndex, {bool isFinalStep = false}) {
    Color stepColor = const Color(0xFF44BC0B);
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: stepColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Icon(
          isFinalStep ? Icons.close : Icons.check,
          color: Colors.white,
          size: 10,
        ),
      ),
    );
  }

  Widget _buildSeparator() {
    Color separatorColor = const Color(0xFF44BC0B);
    return Container(
      width: 20, // Added width to the container to make it visible
      height: 2,
      color: separatorColor,
      margin: const EdgeInsets.symmetric(horizontal: 10),
    );
  }
}
