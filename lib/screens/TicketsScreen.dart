import 'package:fincalis/Services/user_api.dart';
import 'package:fincalis/utils/Preferances.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/ShakeWidget.dart';

class MyTickets extends StatefulWidget {
  const MyTickets({super.key});

  @override
  State<MyTickets> createState() => _MyTicketsState();
}

class _MyTicketsState extends State<MyTickets> {
  bool showEmiDetails = true;
  bool _isLoading = false;
  final TextEditingController _tittle = TextEditingController();
  final TextEditingController _description = TextEditingController();
  String _validatetitle = "";
  String _validateDesc = "";

  Future<void> TicketRaise() async {
    var Userid = await PreferenceService().getString('user_id');
      var data = await UserApi.TicketsRaiseapi(
          Userid!, _tittle.text, _description.text);
      if (data != null) {
        setState(() {
          if (data.success == 1) {
            _isLoading = false;
            Navigator.pop(context,true);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "Ticket raised successfully!",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                "${data.message}",
                style: TextStyle(color: Color(0xff000000)),
              ),
              duration: Duration(seconds: 1),
              backgroundColor: Color(0xFFCDE2FB),
            ));
          }
        });
      }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  SvgPicture.asset(
                    "assets/myticketsbg.svg",
                    fit: BoxFit.fitHeight,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 24, top: 40),
                        child: GestureDetector(onTap: (){
                          Navigator.pop(context);
                        },
                            child: Icon(Icons.arrow_back)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 35),
                        child: Container(
                          height: 50,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Color(0xFF2889BF).withOpacity(0.86),
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(50),
                                  bottomRight: Radius.circular(50))),
                          child: Center(
                            child: Text(
                              "My Tickets",
                              style: TextStyle(
                                  color: Color(0xFFFFFFFF),
                                  fontSize: 22,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: 'Poppins'),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24, right: 24, top: 8),
                child: Column(
                  children: [
                    Container(
                      height: 69,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Color(0xFFCDE2FB).withOpacity(0.25),
                        borderRadius: BorderRadius.circular(100),
                        border: Border.all(
                          color: Color(0xFFCDE2FB).withOpacity(0.45),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 17, right: 17),
                        child: Center(
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showEmiDetails = true;
                                  });
                                },
                                child: Container(
                                  height: 44,
                                  width: 164,
                                  decoration: BoxDecoration(
                                    color: showEmiDetails
                                        ? Color(0xFF44BC0B)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: showEmiDetails
                                          ? Colors.transparent
                                          : Color(0xFF000000).withOpacity(0.20),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Active",
                                      style: TextStyle(
                                        color: showEmiDetails
                                            ? Colors.white
                                            : Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Spacer(),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    showEmiDetails = false;
                                  });
                                },
                                child: Container(
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: !showEmiDetails
                                        ? Color(0xFF44BC0B)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: !showEmiDetails
                                          ? Colors.transparent
                                          : Color(0xFF000000).withOpacity(0.20),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 17, right: 17),
                                    child: Center(
                                      child: Text(
                                        "Completed",
                                        style: TextStyle(
                                          color: !showEmiDetails
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
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
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: showEmiDetails
                          ? _ActiveTickets()
                          : _CompleteTickets(),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 16,
            right: 16,
            child: Center(
              child: GestureDetector(
                onTap: () {
                  _showBottomSheet(context);
                },
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xFF2DB3FF),
                  ),
                  child: Center(
                    child: Text(
                      "Raise A Ticket",
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
          ),
        ],
      ),
    );
  }


  void _showBottomSheet(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            void _validateFields() {
              print("_validateFields called!");
              setState(() {
                _isLoading = true;
                _validatetitle = _tittle.text.isEmpty
                    ? "Please enter title"
                    : "";
                _validateDesc = _description.text.isEmpty
                    ? "Please enter description"
                    : "";
              });

              if (_validatetitle.isEmpty &&
                  _validateDesc.isEmpty) {
                TicketRaise() ;
              } else {
                setState(() {
                  _isLoading = false;
                });
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Please fill all required fields",
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                  duration: Duration(seconds: 1),
                  backgroundColor: Color(0xFFCDE2FB),
                ));
              }
            }
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom,
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Title",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _tittle,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.text,
                        inputFormatters: [
                        ],
                        onTap: () {
                          setState(() {
                            _validatetitle = "";
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            _validatetitle = "";
                          });
                        },
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter title",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Color(0xffAFAFAF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: Color(0xffffffff),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide:
                            BorderSide(width: 1, color: Color(0xffCDE2FB)),
                          ),
                        ),
                      ),
                      if (_validatetitle.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                          width: screenWidth * 0.6,
                          child: ShakeWidget(
                            key: Key("value"),
                            duration: Duration(milliseconds: 700),
                            child: Text(
                              _validatetitle,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else
                        ...[
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      Text(
                        "Description",
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        controller: _description,
                        cursorColor: Colors.black,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,  // Allows for unlimited lines within the specified height
                        inputFormatters: [
                          // Add any input formatters if needed
                        ],
                        onTap: () {
                          setState(() {
                            _validateDesc = "";
                          });
                        },
                        onChanged: (v) {
                          setState(() {
                            _validateDesc = "";
                          });
                        },
                        style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 0,
                          height: 1.2,
                          color: Colors.black,
                          fontWeight: FontWeight.w400,
                        ),
                        decoration: InputDecoration(
                          hintText: "Enter description.",
                          hintStyle: TextStyle(
                            fontSize: 15,
                            letterSpacing: 0,
                            height: 1.2,
                            color: Color(0xffAFAFAF),
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                          ),
                          filled: true,
                          fillColor: Color(0xffffffff),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                            borderSide: BorderSide(width: 1, color: Color(0xffCDE2FB)),
                          ),
                        ),
                      ),
                      if (_validateDesc.isNotEmpty) ...[
                        Container(
                          alignment: Alignment.topLeft,
                          margin: EdgeInsets.only(left: 8, bottom: 10, top: 5),
                          width: screenWidth * 0.6,
                          child: ShakeWidget(
                            key: Key("value"),
                            duration: Duration(milliseconds: 700),
                            child: Text(
                              _validateDesc,
                              style: TextStyle(
                                fontFamily: "Poppins",
                                fontSize: 12,
                                color: Colors.red,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ] else
                        ...[
                          const SizedBox(
                            height: 15,
                          ),
                        ],
                      SizedBox(
                        height: 35,
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child:InkWell(
                            onTap: () {
                              _validateFields();
                            },
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                color: Color(0xFF2DB3FF),
                              ),
                              child: Center(
                                child:_isLoading
                                    ? CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                )
                                    :
                                Text(
                                  "Submit",
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
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    ).whenComplete(() {
      _validatetitle="";
      _validateDesc="";
    });
  }

  Widget _ActiveTickets() {
    // Add your active tickets widget here
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

        ],
      ),
    );
  }

  Widget _CompleteTickets() {
    // Add your completed tickets widget here
    return Container(
      child: Text("Completed Tickets"),
    );
  }
}

