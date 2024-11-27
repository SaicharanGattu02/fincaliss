import 'package:flutter/material.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Privacy Policy",
          style: TextStyle(
            color: Colors.black,
            fontSize: 22,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
          ),
        ),


      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              "1.",
              "Introduction",
              "Welcome to FINCALIS. We are committed to protecting your privacy and safeguarding your personal information. This Privacy Policy outlines how we collect, use, disclose, and protect your data when you use our instant loan app and related services.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "2.",
              "Information We Collect",
              "We may collect the following types of information:\nPersonal Identification Information: Includes your name, contact details (e.g., phone number, email address), government-issued ID, and bank account information.\nFinancial Information: Includes your credit history, income, and other financial details relevant to your loan application.\nUsage Data: Information about how you use our app, including IP address, device type, and browser type.\nCookies and Tracking Technologies: We use cookies and similar technologies to enhance your experience and analyze usage patterns.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "3.",
              "How We Use Your Information",
              "We use your information for the following purposes:\nLoan Processing: To assess your eligibility, approve loan applications, and disburse funds.Customer Service: To respond to your inquiries, provide support, and improve our services.Marketing and Communications: To send you updates, promotional materials, and offers related to our services, subject to your consent.\nLegal and Regulatory Compliance: To comply with legal obligations and regulatory requirements.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "4.",
              "How We Share Your Information",
              "We may share your information with:\nThird-Party Service Providers: To assist with loan processing, data analysis, and other functions.\nRegulatory Authorities: As required by law or to comply with regulatory requirements.Business Partners: In connection with joint ventures or partnerships that may involve our services.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "5.",
              "Data Security",
              "We implement appropriate security measures to protect your data from unauthorized access, alteration, disclosure, or destruction. However, no system can be entirely secure, and we cannot guarantee the absolute security of your information.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "6.",
              "Your Rights",
              "You have the following rights regarding your personal information:\nAccess: You can request access to the personal data we hold about you.\nCorrection: You can request corrections to any inaccuracies in your personal data.Deletion: You can request the deletion of your personal data, subject to legal and regulatory obligations.\nOpt-Out: You can opt-out of receiving marketing communications at any time.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "7.",
              "Cookies and Tracking Technologies",
              "We use cookies and similar technologies to collect and store information about your usage of our app. You can manage your cookie preferences through your browser settings.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "8.",
              "Changes to This Privacy Policy",
              "We may update this Privacy Policy from time to time. Any changes will be posted on our app or website, and we encourage you to review this policy periodically.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "9.",
              "Contact Us",
              "If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at  info@fincalis.in",
            ),
            SizedBox(height: 20),
            _buildSection(
              "10.",
              "International Transfers",
              "If you are accessing our services from outside [Your Country/Region], your information may be transferred to and processed in [Your Country/Region]. By using our services, you consent to such transfers.",
            ),
            SizedBox(height: 20),
            _buildSection(
              "11.",
              "Children's Privacy",
              "Our services are not intended for use by individuals under the age of 18. We do not knowingly collect personal information from children under 18. If we become aware that we have collected such information, we will take steps to delete it.",
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