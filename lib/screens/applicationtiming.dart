
import 'package:flutter/material.dart';

class MyAppTiming extends StatefulWidget {
  const MyAppTiming({super.key});

  @override
  State<MyAppTiming> createState() => _MyAppTimingState();
}

class _MyAppTimingState extends State<MyAppTiming> {
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24,vertical: 10),
        child: Container(
          height: MediaQuery.of(context).size.height*0.8, // Set the desired height
          width: double.infinity, // Set the desired width
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: const Color(0xFFCDE2FB).withOpacity(0.25),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  "Personal Loan Application",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                  // textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 150), // Adjusted height
              Text(
                "We Are Evaluating Your \nApplication",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
                // textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20), // Adjusted height
              GestureDetector(
                onTap: (){

                 },
                child: Image.asset(
                  "assets/hourglass.png",
                  width: 150,
                  height: 150,
                ),
              ),
              const SizedBox(height: 30), // Adjusted height
              Text(
                "Please Wait",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                ),
                // textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
