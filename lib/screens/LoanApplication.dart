import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoanApplication extends StatefulWidget {
  const LoanApplication({super.key});

  @override
  State<LoanApplication> createState() => _LoanApplicationState();
}

class _LoanApplicationState extends State<LoanApplication> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        height:screenHeight,
        padding: EdgeInsets.only(left: 15,right: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Loan application",
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 20,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 10,),
            Text(
              "Please complete this application to borrow money. You need to provide us the below information. ",
              style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 15,
                  fontFamily: "Inter",
                  fontWeight: FontWeight.w400),
            ),
            SizedBox(height: screenHeight*0.05),
            SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child:  Column(
                children: [
                  InkResponse(
                      onTap: () {

                      },
                      child: buildCard("assets/personalinfo.svg", "Personal information", "Provide details about yourself and family")),
                  SizedBox(height: screenHeight*0.03),

                  InkResponse(
                      onTap: () {
                      },
                      child: buildCard("assets/employeinfo.svg", "Employment information", "Provide details about yourself and family")),
                  SizedBox(height: screenHeight*0.03),
                  InkResponse(
                      onTap: () {
                        
                      },
                      child: buildCard("assets/kycinfo.svg", "KYC information", "Provide details about yourself and family")),
                  SizedBox(height: screenHeight*0.03),

                  InkResponse(
                      onTap: () {

                      },
                      child: buildCard("assets/kycinfo.svg", "Setup EMI auto debit", "")),
                ],
              ),
            ),



          ],
        ),
      ),
    );
  }
  Widget buildCard(
      String iconAsset,
      String title,
      String subtitle,
      ) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      width: screenWidth,
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Color(0xFFE1E7FD),
            blurRadius: 4.0,  // Increased blur radius for a smoother shadow
            spreadRadius: 0.5,
            offset: Offset(0, 4),  // Move the shadow downwards to appear only at the bottom
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(iconAsset),
          SizedBox(width: 20),
          // Adding spacing between icon and text
          Container(
            width: screenWidth*0.55,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the start of the column
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Inter",
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 5), // Adding spacing between title and subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontFamily: "Inter",
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          Icon(
            Icons.person, // You might want to use `iconAsset` here instead if you want dynamic icons
            size: 25,
          ),
        ],
      ),
    );
  }

}