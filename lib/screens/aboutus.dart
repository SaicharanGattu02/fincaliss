import 'package:flutter/material.dart';

class MyAboutUs extends StatefulWidget {
  const MyAboutUs({super.key});

  @override
  State<MyAboutUs> createState() => _MyAboutUsState();
}

class _MyAboutUsState extends State<MyAboutUs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "About Us",
          style: TextStyle(
            color: Color(0xFF374151),
            fontSize: 24,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body:
      Padding(
        padding: const EdgeInsets.only(top: 20, left: 24, right: 24),
        child:
        Column(
          children: [
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Adjust the padding as needed
                child: Text(
                  "Welcome to FINCALIS, your trusted partner for instant loans. At FINCALIS, we specialize in providing quick and hassle-free loans to individuals. Our innovative mobile app ensures that you can access funds anytime, anywhere, with just a few taps on your smartphone.",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Adjust the padding as needed
                child: Text(
                  "We take pride in our collaboration with NBFC registered companies, ensuring that all our loan offerings adhere strictly to regulatory standards. This partnership allows us to offer competitive interest rates and flexible repayment options tailored to meet your financial needs.",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Adjust the padding as needed
                child: Text(
                  "At FINCALIS, customer satisfaction is our top priority. Our dedicated team of professionals is committed to providing personalized service and guidance throughout your loan journey. Whether you're looking to fund a personal project, manage unexpected expenses, or consolidate debt, FINCALIS is here to support you every step of the way.",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20.0), // Adjust the padding as needed
                child: Text(
                  "Join thousands of satisfied customers who have experienced the ease and convenience of borrowing with FINCALIS. Discover why FINCALIS is the preferred choice for fast, reliable, and transparent loan solutions.",
                  style: TextStyle(
                    color: Color(0xFF374151),
                    fontSize: 14,
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
        )
      ),
    );
  }
}