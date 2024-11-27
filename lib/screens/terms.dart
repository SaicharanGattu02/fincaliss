import 'package:flutter/material.dart';

class MyTerms extends StatefulWidget {
  const MyTerms({super.key});

  @override
  State<MyTerms> createState() => _MyTermsState();
}

class _MyTermsState extends State<MyTerms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Terms and Conditions",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "1.",
              "Introduction",
              "Welcome to FINCALIS. By accessing and using our instant loan app and services, you agree to comply with and be bound by the following Terms and Conditions. Please read them carefully before using our services.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "2.",
              "Eligibility",
              "To use our services, you must:\nBe at least 18 years old.\nBe a resident of [Your Country/Region].\nHave a valid government-issued ID.\nHave a bank account in your name.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "3.",
              "Loan Application and Approval",
              "All loan applications are subject to approval based on our assessment criteria.\nWe reserve the right to reject any application without providing reasons.\nLoan amounts, terms, and conditions are determined based on your creditworthiness and other relevant factors.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "4.",
              "Interest Rates and Fees",
              "Interest rates are determined at the time of loan approval and are subject to change.Additional fees may apply, including but not limited to processing fees, late payment fees, and prepayment penalties.\nAll fees and charges will be disclosed to you before finalizing your loan agreement.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "5.",
              "Privacy and Data Security",
              "Repayment terms, including the amount and frequency of payments, will be specified in your loan agreement.\nYou are responsible for making timely payments as per the agreed schedule.\nFailure to make payments on time may result in additional fees, increased interest rates, and negative impacts on your credit score.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "6.",
              "Repayment",
              "We are committed to protecting your privacy and data security. Please review our Privacy Policy for details on how we collect, use, and protect your personal information.\nBy using our services, you consent to the collection and processing of your personal data as outlined in our Privacy Policy.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "7.",
              "Use of Services",
              "You agree to use our services for lawful purposes only and in accordance with these Terms and Conditions.\nYou are responsible for ensuring that the information you provide is accurate and up-to-date.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "8.",
              "Modification of Terms",
              "We may modify these Terms and Conditions from time to time. Any changes will be effective immediately upon posting on our app or website.\nYour continued use of our services after any modifications constitutes your acceptance of the revised Terms and Conditions.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "9.",
              "Termination",
              "We reserve the right to suspend or terminate your access to our services at our sole discretion if you breach these Terms and Conditions or for any other reason.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "10.",
              "Limitation of Liability",
              "To the fullest extent permitted by law, FINCALIS shall not be liable for any indirect, incidental, consequential, or punitive damages arising out of or in connection with your use of our services.\nOur total liability for any claims related to our services shall be limited to the amount paid by you for the loan, if applicable.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "11.",
              "Governing Law",
              "These Terms and Conditions shall be governed by and construed in accordance with the laws of Hyderabad , INDIA\nAny disputes arising from these Terms and Conditions shall be subject to the exclusive jurisdiction of the courts in  Hyderabad , INDIA",
            ),
            SizedBox(height: 24),
            // GestureDetector(
            //   onTap: () {},
            //   child: Container(
            //     height: 53,
            //     decoration: BoxDecoration(
            //       color: const Color(0xFF24B0FF),
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     child: Center(
            //       child: Text(
            //         "Accept & continue",
            //         style: TextStyle(
            //           fontSize: 20,
            //           fontFamily: 'Poppins',
            //           fontWeight: FontWeight.w600,
            //           color: Colors.white,
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String number, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              number,
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 18,
                fontFamily: 'Inter',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 18,
                  fontFamily: 'Inter',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
        Text(
          content,
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 14,
            fontFamily: 'Inter',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}