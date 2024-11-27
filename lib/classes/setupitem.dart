import 'package:fincalis/classes/octagonal.dart';
import 'package:flutter/material.dart';

Widget buildStepItem(String number, String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 17),
      child: Row(
        children: [
          ClipPath(
            clipper: OctagonClipper(),
            child: Container(
              width: 40,
              height: 40,
              color: Color(0xFF08A4FF),
              child: Center(
                child: Text(
                  number,
                  style: TextStyle(
                    color: Color(0xFFFFFFFF),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Text(
            title,
            style: TextStyle(
              color: Color(0xFF374151),
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

