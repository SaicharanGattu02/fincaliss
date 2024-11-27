import 'package:fincalis/screens/ReferencesScreen.dart';
import 'package:flutter/material.dart';

class MyAproove extends StatefulWidget {
  const MyAproove({super.key});

  @override
  State<MyAproove> createState() => _MyAprooveState();
}

class _MyAprooveState extends State<MyAproove> {
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFCDE2FB).withOpacity(0.25),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset("assets/aproove.png"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 78,right: 78,top: 50),
                  child: const Text(
                    "Your Application Is Approved!",
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.only(top: 159,bottom: 50),
                  child: GestureDetector(onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>ReferencesScreen()));
                  },
                    child: Container(
                      width: 240,
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
                ),
                
              ],
            ),
          ),
        ),
      ),
    );
  }
}
