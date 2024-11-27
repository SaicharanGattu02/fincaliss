import 'package:fincalis/screens/loanoverview.dart';
import 'package:flutter/material.dart';

class Disbursedscreen extends StatefulWidget {
  const Disbursedscreen({super.key});

  @override
  State<Disbursedscreen> createState() => _DisbursedscreenState();
}

class _DisbursedscreenState extends State<Disbursedscreen> {
  @override
  Widget build(BuildContext context) {
    return
      WillPopScope(
        onWillPop: () async{
      Navigator.pop(context,true);
      return false;
    },
        child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context,true);
                },
              ),
            ],
          ),
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
        ),
        body: Center(
         child:   Padding(
           padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
           child: Container(
             height: MediaQuery.of(context).size.height*0.5, // Set the desired height
             width: double.infinity, // Set the desired width
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20),
               color: const Color(0xFFCDE2FB).withOpacity(0.25),
             ),
             child: Padding(
               padding: const EdgeInsets.symmetric(horizontal: 29),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   Image.asset(
                     "assets/peace.png",
                     width: 100,
                     height: 50,
                   ),
                   const SizedBox(height: 44), // Adjusted height
                   Image.asset(
                     "assets/ok.png",
                     width: 50,
                     height: 50,
                   ),
                   const SizedBox(height: 20), // Adjusted height
                   Text(
                     "Your Amount is Disbursed",
                     style: TextStyle(
                       color: Color(0xFF034469),
                       fontSize: 20,
                       fontFamily: "Poppins",
                       fontWeight: FontWeight.w400,
                     ),
                     textAlign: TextAlign.center,
                   ),
                   SizedBox(height: 80),
                   GestureDetector(
                     onTap: () {
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) =>LoanOverView()), // Replace with your next screen
                       );
                     },
                     child: Center(
                       child: Container(
                         height: 56,
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
                   ), // Adjusted height

                 ],
               ),
             ),
           ),
         ),
        ),
            ),
      );
  }
}
