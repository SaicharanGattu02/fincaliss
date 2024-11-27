import 'package:flutter/material.dart';

class MyFAQ extends StatefulWidget {
  const MyFAQ({super.key});

  @override
  State<MyFAQ> createState() => _MyFAQState();
}

class _MyFAQState extends State<MyFAQ> {
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
            SizedBox(width: 10),
            Text(
              "FAQs",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFFCDE2FB).withOpacity(0.25),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "eNACH Process",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 6),
                    child: Text(
                      "Frequently Asked Questions (FAQs)",
                      style: TextStyle(
                        color: Color(0xFF374151),
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "1. What is eNACH?",
                    "eNACH (Electronic National Automated Clearing House) is a digital process that allows for the automatic and recurring collection of payments from your bank account. It simplifies the management of recurring transactions like loan EMI payments, utility bill payments, and subscription services.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "2. How does eNACH work?",
                    "eNACH works by electronically authorizing your bank to debit your account on a scheduled basis. Once you provide your consent and details, the bank processes the payments automatically according to the agreed schedule.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "3. How do I register for eNACH?",
                    "To register for eNACH, follow these steps:\n1. Fill Out the eNACH Mandate Form: Complete the mandate form provided by your lender or service provider.\n2. Submit the Form: Submit the completed form to your bank or financial institution.\n3. Verification: Your bank will verify the details and set up the eNACH instructions.\n4. Confirmation: You will receive a confirmation once the registration is successful.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "4. What information is required to set up eNACH?",
                    "You will need to provide the following information:\n- Your bank account details (account number and IFSC code).\n- Your personal details (name, contact number, etc.).\n- Details of the recurring transaction (amount, frequency, etc.).",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "5. How long does it take to process eNACH registration?",
                    "The registration process typically takes 7-10 business days. However, the exact time may vary depending on your bank and the complexity of the transaction.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "6. Can I modify or cancel an eNACH mandate?",
                    "Yes, you can modify or cancel an eNACH mandate. To do so, you need to:\nSubmit a Request: Provide a written request to your bank or financial institution.\nProvide Details: Include the details of the mandate you wish to modify or cancel.\nVerification: Your request will be processed after verification.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                    "7. Are there any charges associated with eNACH?",
                    "eNACH may involve nominal charges depending on your bank’s policies. It is advisable to check with your bank for details on any applicable fees.",
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                      "8. What happens if there are insufficient funds in my account?",
                      "If there are insufficient funds in your account on the scheduled date, the transaction may be declined. You may incur penalties or late fees as per your agreement with the service provider. It’s important to ensure adequate balance in your account to avoid such issues."
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                      "9. Is my information safe with eNACH?",
                      "Yes, your information is protected through secure banking channels. Banks and financial institutions follow stringent security measures to ensure the safety of your data during the eNACH process."
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                      "10.Who should I contact for issues or queries regarding eNACH?",
                      "For any issues or queries regarding eNACH, you can contact:\nYour Bank: For assistance with the registration, modification, or cancellation of eNACH.\nYour Lender/Service Provider: For issues related to the transactions or payments."
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                      "11. Can eNACH be used for international transactions?",
                      "eNACH is typically used for domestic transactions within India. For international transactions, you may need to explore alternative payment methods."
                  ),
                  SizedBox(height: 30),
                  _buildFAQItem(
                      "12. What should I do if I receive an unauthorized eNACH debit?",
                      "If you notice an unauthorized eNACH debit from your account, immediately contact your bank to report the issue and request a reversal. It’s also advisable to notify your service provider about the unauthorized transaction."
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
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                question,
                style: TextStyle(
                  color: Color(0xFF374151),
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down_outlined),
          ],
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                color: Color(0xFFD1D5DB),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                answer,
                style: TextStyle(
                  color: Color(0xFF888383),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}